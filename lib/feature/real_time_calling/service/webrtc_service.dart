import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';

class WebRTCService extends GetxService {
  // Media Streams
  final Rx<webrtc.MediaStream?> localStream = Rx<webrtc.MediaStream?>(null);
  final Rx<webrtc.MediaStream?> remoteStream = Rx<webrtc.MediaStream?>(null);

  // Peer Connection
  webrtc.RTCPeerConnection? peerConnection;

  // State
  final RxBool isAudioEnabled = true.obs;
  final RxBool isVideoEnabled = true.obs;
  final RxString connectionState = 'disconnected'.obs;

  // Callbacks
  Function(webrtc.RTCIceCandidate)? onIceCandidate;
  Function(String, dynamic)? onSignalingStateChange;

  // ICE Servers configuration with multiple fallbacks
  final Map<String, dynamic> iceServers = {
    'iceServers': [
      // Google STUN servers (most reliable)
      {
        'urls': [
          'stun:stun.l.google.com:19302',
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
          'stun:stun3.l.google.com:19302',
          'stun:stun4.l.google.com:19302',
        ]
      },
      // Fallback STUN servers
      {
        'urls': [
          'stun:stun.stunprotocol.org:3478',
          'stun:stun.services.mozilla.com:3478',
          'stun:stunserver.org:3478',
          'stun:stun.xten.com:3478',
        ]
      },
      // Primary TURN server (Evan Brass free experimental server)
      {
        'urls': [
          'turn:stun.evan-brass.net',
          'turn:stun.evan-brass.net?transport=tcp',
          'stun:stun.evan-brass.net'
        ],
        'username': 'guest',
        'credential': 'password'
      },
      // Backup TURN servers
      {
        'urls': [
          'turn:turnserver.open-paas.org:3478',
          'turn:turnserver.open-paas.org:5349'
        ],
        'username': 'openrelayproject',
        'credential': 'openrelayproject'
      }
    ]
  };

  /// Initialize WebRTC service
  Future<void> init() async {
    await _getUserMedia();
  }

  /// Get user media (camera and microphone)
  Future<void> _getUserMedia() async {
    try {
      final constraints = {
        'audio': true,
        'video': {
          'width': {'ideal': 640},
          'height': {'ideal': 480},
        }
      };

      if (kDebugMode) {
        print('📸 Requesting user media with constraints...');
      }

      final stream = await webrtc.navigator.mediaDevices.getUserMedia(constraints);
      localStream.value = stream;

      if (kDebugMode) {
        print('✅ Local media stream obtained');
        print('📊 Local stream ID: ${stream.id}');
        print('📊 Video tracks: ${stream.getVideoTracks().length}');
        print('📊 Audio tracks: ${stream.getAudioTracks().length}');
        for (var track in stream.getVideoTracks()) {
          print('📊 Video track - kind: ${track.kind}, enabled: ${track.enabled}, label: ${track.label}');
        }
        for (var track in stream.getAudioTracks()) {
          print('📊 Audio track - kind: ${track.kind}, enabled: ${track.enabled}, label: ${track.label}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting user media: $e');
      }
      rethrow;
    }
  }

  /// Create peer connection
  Future<void> createPeerConnection() async {
    try {
      if (kDebugMode) {
        print('🔧 Creating peer connection...');
      }

      // Prevent creating a peer connection if one already exists
      if (peerConnection != null) {
        if (kDebugMode) {
          print('⚠️ Peer connection already exists, skipping creation');
        }
        return;
      }

      peerConnection = await webrtc.createPeerConnection(
        iceServers,
      );

      if (peerConnection == null) {
        throw Exception('Failed to create peer connection');
      }

      // Setup event listeners BEFORE adding tracks
      _setupPeerConnectionListeners();

      // Ensure local stream exists before adding tracks
      if (localStream.value == null) {
        if (kDebugMode) {
          print('📸 Local stream is null, initializing media...');
        }
        await _getUserMedia();
      }

      // Add local stream to peer connection with proper error handling
      if (localStream.value != null) {
        if (kDebugMode) {
          print('📤 Adding local stream tracks to peer connection...');
          print('📊 Total tracks to add: ${localStream.value!.getTracks().length}');
        }
        
        // Add all tracks from local stream
        for (var track in localStream.value!.getTracks()) {
          try {
            final sender = await peerConnection!.addTrack(track, localStream.value!);
            if (kDebugMode) {
              print('✅ Successfully added track: ${track.kind}');
              print('📊 Track sender: ${sender.senderId}');
              print('📊 Track enabled: ${track.enabled}');
            }
          } catch (e) {
            if (kDebugMode) {
              print('❌ Error adding ${track.kind} track: $e');
            }
          }
        }
      } else {
        if (kDebugMode) {
          print('⚠️ Local stream is still null - no tracks to add');
        }
      }

      // Update initial state - states should be available after creation
      if (peerConnection != null) {
        try {
          // Get states and provide better fallbacks
          final signalingStateObj = peerConnection!.signalingState;
          final connStateObj = peerConnection!.connectionState;
          final iceConnStateObj = peerConnection!.iceConnectionState;
          final iceGatherStateObj = peerConnection!.iceGatheringState;
          
          final signalingState = signalingStateObj?.name ?? 'stable (initial)';
          final connState = connStateObj?.name ?? 'new (initial)';
          final iceConnState = iceConnStateObj?.name ?? 'new (initial)';
          final iceGatherState = iceGatherStateObj?.name ?? 'new (initial)';
          
          connectionState.value = connState;
          
          if (kDebugMode) {
            print('✅ Peer connection created successfully');
            print('📊 Initial signaling state: $signalingState');
            print('📊 Connection state: $connState');
            print('📊 ICE connection state: $iceConnState');
            print('📊 ICE gathering state: $iceGatherState');
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Could not retrieve peer connection states: $e');
          }
          connectionState.value = 'new';
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating peer connection: $e');
      }
      rethrow;
    }
  }

  /// Setup peer connection listeners
  void _setupPeerConnectionListeners() {
    peerConnection?.onIceCandidate = (webrtc.RTCIceCandidate candidate) {
      if (kDebugMode) {
        print('🧊 ICE Candidate: ${candidate.candidate}');
      }
      onIceCandidate?.call(candidate);
    };

    peerConnection?.onConnectionState = (webrtc.RTCPeerConnectionState state) {
      if (kDebugMode) {
        print('📡 Connection State Changed: ${state.name}');
      }
      connectionState.value = state.name;
    };

    peerConnection?.onSignalingState = (webrtc.RTCSignalingState state) {
      if (kDebugMode) {
        print('📢 Signaling State Changed: ${state.name}');
      }
      onSignalingStateChange?.call(state.name, null);
    };

    peerConnection?.onIceConnectionState = (webrtc.RTCIceConnectionState state) {
      if (kDebugMode) {
        print('🧊 ICE Connection State Changed: ${state.name}');
        _logConnectionDiagnostics(state.name);
      }
      
      // Update connection state based on ICE connection state
      switch (state.name) {
        case 'connected':
        case 'completed':
          connectionState.value = 'connected';
          if (kDebugMode) {
            print('✅ ICE Connection Established');
          }
          break;
        case 'failed':
          connectionState.value = 'failed';
          if (kDebugMode) {
            print('❌ ICE Connection Failed - Connection cannot be established');
            print('   Possible causes:');
            print('   1. STUN server unreachable');
            print('   2. Firewall blocking WebRTC ports');
            print('   3. NAT traversal issues');
            print('   4. Both peers behind restrictive NAT without TURN');
          }
          break;
        case 'disconnected':
          connectionState.value = 'disconnected';
          if (kDebugMode) {
            print('⚠️ ICE Connection Disconnected');
          }
          break;
        case 'closed':
          connectionState.value = 'disconnected';
          if (kDebugMode) {
            print('❌ ICE Connection Closed');
          }
          break;
        default:
          if (kDebugMode) {
            print('📊 ICE State: ${state.name}');
          }
      }
    };
    
    peerConnection?.onIceGatheringState = (webrtc.RTCIceGatheringState state) {
      if (kDebugMode) {
        print('🧊 ICE Gathering State Changed: ${state.name}');
        switch (state.name) {
          case 'new':
            print('   📋 Gathering starting...');
            break;
          case 'gathering':
            print('   🔍 Gathering ICE candidates from STUN/TURN servers...');
            break;
          case 'complete':
            print('   ✅ ICE candidate gathering complete');
            _logIceCandidateCount();
            break;
        }
      }
    };

    peerConnection?.onTrack = (webrtc.RTCTrackEvent event) {
      if (kDebugMode) {
        print('\n🎬 ===== REMOTE TRACK RECEIVED =====');
        print('🎬 Track kind: ${event.track.kind}');
        print('📊 Track enabled: ${event.track.enabled}');
        print('📊 Track label: ${event.track.label}');
        print('📊 Event streams count: ${event.streams.length}');
      }

      if (event.streams.isNotEmpty) {
        remoteStream.value = event.streams[0];
        if (kDebugMode) {
          print('✅ Remote stream SET successfully');
          print('📊 Remote stream ID: ${event.streams[0].id}');
          print('📊 Remote stream tracks: ${event.streams[0].getTracks().length}');
          for (var track in event.streams[0].getTracks()) {
            print('   📊 Remote ${track.kind} track - enabled: ${track.enabled}, label: ${track.label}');
          }
          print('===== END REMOTE TRACK =====\n');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ CRITICAL: Remote track received but NO streams attached!');
          print('⚠️ This means tracks won\'t be rendered');
        }
      }
    };

    peerConnection?.onAddStream = (webrtc.MediaStream stream) {
      if (kDebugMode) {
        print('✅ Remote stream added (onAddStream callback)');
        print('📊 Stream has ${stream.getTracks().length} tracks');
      }
      remoteStream.value = stream;
    };
  }

  /// Log connection diagnostics
  void _logConnectionDiagnostics(String iceConnectionState) {
    if (peerConnection == null) return;
    
    try {
      final signalingState = peerConnection!.signalingState?.name ?? 'unknown';
      final connState = peerConnection!.connectionState?.name ?? 'unknown';
      final iceGatheringState = peerConnection!.iceGatheringState?.name ?? 'unknown';
      
      if (kDebugMode) {
        print('📊 === Connection Diagnostics ===');
              print('📊 Signaling State: $signalingState');
      print('📊 Connection State: $connState');
      print('📊 ICE Connection State: $iceConnectionState');
      print('📊 ICE Gathering State: $iceGatheringState');
      }

      
      // Log local tracks
      if (localStream.value != null) {
        final videoTracks = localStream.value!.getVideoTracks();
        final audioTracks = localStream.value!.getAudioTracks();
        if (kDebugMode) {
          print('📊 Local Tracks: Video=${videoTracks.length}, Audio=${audioTracks.length}');
        }
        for (var track in videoTracks) {
          if (kDebugMode) {
            print('   📹 Video: enabled=${track.enabled}, label=${track.label}');
          }
        }
        for (var track in audioTracks) {
          if (kDebugMode) {
            print('   🎤 Audio: enabled=${track.enabled}, label=${track.label}');
          }
        }
      } else {
        if (kDebugMode) {
          print('⚠️ No local stream');
        }
      }
      
      // Log remote tracks
      if (remoteStream.value != null) {
        final videoTracks = remoteStream.value!.getVideoTracks();
        final audioTracks = remoteStream.value!.getAudioTracks();
        if (kDebugMode) {
          print('📊 Remote Tracks: Video=${videoTracks.length}, Audio=${audioTracks.length}');
        }
        for (var track in videoTracks) {
          if (kDebugMode) {
            print('   📹 Video: enabled=${track.enabled}, label=${track.label}');
          }
        }
        for (var track in audioTracks) {
          if (kDebugMode) {
            print('   🎤 Audio: enabled=${track.enabled}, label=${track.label}');
          }
        }
      } else {
        if (kDebugMode) {
          print('⚠️ No remote stream yet');
        }
      }
      if (kDebugMode) {
        print('📊 ================================');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error logging diagnostics: $e');
      }
    }
  }

  /// Log ICE candidate count
  void _logIceCandidateCount() {
    if (peerConnection == null) return;
    
    try {
      // Get stats to see how many ICE candidates were gathered
      if (kDebugMode) {
        print('📊 ICE Candidate Gathering Summary:');
        print('   🌍 Using STUN servers for NAT discovery');
        print('   📋 Candidates will be sent via signaling channel');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error logging ICE candidates: $e');
      }
    }
  }

  /// Create and send offer
  Future<webrtc.RTCSessionDescription?> createAndSendOffer() async {
    try {
      if (peerConnection == null) {
        await createPeerConnection();
      }

      if (kDebugMode) {
        print('📤 Creating offer with proper constraints...');
        print('🔍 Peer connection signaling state: ${peerConnection?.signalingState}');
      }

      final offer = await peerConnection!.createOffer(
        <String, dynamic>{
          'offerToReceiveAudio': true,
          'offerToReceiveVideo': true,
        },
      );

      await peerConnection!.setLocalDescription(offer);

      if (kDebugMode) {
        print('📤 Offer created: ${offer.type}');
        print('🔍 After offer, signaling state: ${peerConnection?.signalingState}');
      }

      return offer;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating offer: $e');
      }
      rethrow;
    }
  }

  /// Create and send answer
  Future<webrtc.RTCSessionDescription?> createAndSendAnswer() async {
    try {
      if (peerConnection == null) {
        throw Exception('Peer connection not initialized');
      }

      if (kDebugMode) {
        print('📤 Creating answer with proper constraints...');
      }

      final answer = await peerConnection!.createAnswer(
        <String, dynamic>{
          'offerToReceiveAudio': true,
          'offerToReceiveVideo': true,
        },
      );

      await peerConnection!.setLocalDescription(answer);

      if (kDebugMode) {
        print('📤 Answer created: ${answer.type}');
      }

      return answer;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating answer: $e');
      }
      rethrow;
    }
  }

  /// Set remote description from offer
  Future<void> setRemoteDescription(
      String sdp, String type) async {
    try {
      if (peerConnection == null) {
        if (kDebugMode) {
          print('🔧 Peer connection not initialized, creating now...');
        }
        await createPeerConnection();
      }

      if (peerConnection == null) {
        throw Exception('Failed to initialize peer connection for setting remote description');
      }

      if (kDebugMode) {
        print('🔍 Setting remote description of type: $type');
        print('📊 Current signaling state: ${peerConnection!.signalingState?.name}');
        print('📊 Current connection state: ${peerConnection!.connectionState?.name}');
      }

      final description = webrtc.RTCSessionDescription(sdp, type);
      await peerConnection!.setRemoteDescription(description);

      if (kDebugMode) {
        print('✅ Remote description set: $type');
        print('📊 Signaling state after setRemoteDescription: ${peerConnection!.signalingState?.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error setting remote description: $e');
        if (peerConnection != null) {
          print('📊 Current signaling state at error: ${peerConnection!.signalingState?.name}');
          print('📊 Current connection state: ${peerConnection!.connectionState?.name}');
        }
      }
      rethrow;
    }
  }

  /// Add ICE candidate
  Future<void> addIceCandidate(
      String candidate, String sdpMid, int sdpMLineIndex) async {
    try {
      if (peerConnection == null) {
        if (kDebugMode) {
          print('⚠️ Peer connection not available for ICE candidate');
        }
        return;
      }

      if (candidate.isEmpty) {
        if (kDebugMode) {
          print('⚠️ Empty ICE candidate received');
        }
        return;
      }

      final iceCandidate = webrtc.RTCIceCandidate(candidate, sdpMid, sdpMLineIndex);
      await peerConnection!.addCandidate(iceCandidate);

      if (kDebugMode) {
        print('✅ ICE Candidate added: ${candidate.substring(0, 30)}...');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error adding ICE candidate: $e');
      }
      // Don't rethrow as ICE candidate addition can fail without breaking the connection
    }
  }

  /// Toggle audio
  Future<void> toggleAudio(bool enabled) async {
    try {
      if (localStream.value != null) {
        for (var track in localStream.value!.getAudioTracks()) {
          track.enabled = enabled;
        }
      }
      isAudioEnabled.value = enabled;
      if (kDebugMode) {
        print('🔊 Audio ${enabled ? 'enabled' : 'disabled'}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error toggling audio: $e');
      }
    }
  }

  /// Toggle video
  Future<void> toggleVideo(bool enabled) async {
    try {
      if (localStream.value != null) {
        for (var track in localStream.value!.getVideoTracks()) {
          track.enabled = enabled;
        }
      }
      isVideoEnabled.value = enabled;
      if (kDebugMode) {
        print('📹 Video ${enabled ? 'enabled' : 'disabled'}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error toggling video: $e');
      }
    }
  }

  /// Close peer connection
  Future<void> closePeerConnection() async {
    try {
      await peerConnection?.close();
      peerConnection = null;
      connectionState.value = 'disconnected';
      if (kDebugMode) {
        print('✅ Peer connection closed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error closing peer connection: $e');
      }
    }
  }

  /// Cleanup resources
  Future<void> cleanup() async {
    try {
      // Stop all local tracks
      if (localStream.value != null) {
        for (var track in localStream.value!.getTracks()) {
          await track.stop();
        }
        await localStream.value!.dispose();
      }

      // Close peer connection
      await closePeerConnection();

      localStream.value = null;
      remoteStream.value = null;

      if (kDebugMode) {
        print('✅ WebRTC resources cleaned up');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cleaning up: $e');
      }
    }
  }

  @override
  void onClose() {
    cleanup();
    super.onClose();
  }
}

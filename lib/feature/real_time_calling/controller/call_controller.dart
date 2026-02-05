import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/feature/real_time_calling/screen/incoming_call_screen.dart';
import 'package:jdadzok/feature/real_time_calling/screen/outgoing_call_screen.dart';
import 'package:jdadzok/feature/real_time_calling/service/call_service.dart';
import 'package:jdadzok/feature/real_time_calling/service/webrtc_service.dart';
import 'package:jdadzok/route/app_route.dart';

class CallController extends GetxController {
  final CallService callService = Get.find<CallService>();
  final WebRTCService webRTCService = Get.find<WebRTCService>();

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    _setupWebRTCCallbacks();
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  RxMap<String, dynamic> incomingCallData = <String, dynamic>{}.obs;
  final RxBool isCallActive = false.obs;
  final RxBool isCallEnded = false.obs;
  final RxString callId = ''.obs;
  final RxString callerId = ''.obs;
  final RxString title = ''.obs;
  final RxBool isCallAccepted = false.obs;
  final RxString receiverRxId = ''.obs;
  final RxBool isCallerInitiating = false.obs;
  final RxString callerName = ''.obs;
  final RxString callerImage = ''.obs; // To differentiate roles

  void _setupListeners() {
    // Remove the old redundant listener
    callService.on('incoming-call', (data) {
      if (kDebugMode) {
        print('📞 Incoming Call: $data');
      }
      playLoopingAudio();
      incomingCallData.value = data;
      callId.value = data['callId'] ?? '';
      callerId.value = data['from'] ?? '';  // ← Changed from 'hostUserId' to 'from'
      title.value = data['title'] ?? '';
      isCallerInitiating.value = false; // Receiver role
      if (kDebugMode) {
        print('🔍 [RECEIVER] Set callerId from incoming-call: ${callerId.value}');
      }
      fetchReceiverProfile();
      Get.to(() => IncomingCallScreen());
    });

    callService.on('call-started', (data) {
      if (kDebugMode) {
        print('📞 Call Started: $data');
      }
      isCallEnded.value = false;
      callId.value = data['callId'] ?? '';
    });

    callService.on('call-declined', (data) {
      if (kDebugMode) {
        print('📞 Call declined: $data');
      }
      stopAudio();
      isCallEnded.value = true;
      callId.value = '';
      callerId.value = '';
      title.value = '';
      _cleanupCall();
      Get.back();
    });

    callService.on('call-ended', (data) {
      if (kDebugMode) {
        print('📞 Call Ended: $data');
      }
      stopAudio();
      isCallEnded.value = true;
      isCallActive.value = false;
      
      // Cleanup WebRTC and UI
      _cleanupCall();
      
      // Navigate back if still on video call screen
      if (Get.currentRoute == AppRoute.videoCallScreen) {
        Get.back();
      }
      
      Get.showSnackbar(
        const GetSnackBar(
          title: 'Call Ended',
          message: 'The call has ended.',
          duration: Duration(seconds: 2),
        ),
      );
    });

    callService.on('call-active', (data) async {
      if (kDebugMode) {
        print('📞 Call Accepted: $data');
        print('🔍 [IMPORTANT] This event should ONLY be received by the CALLER');
        print('📍 Current role before processing: ${isCallerInitiating.value ? "CALLER" : "RECEIVER"}');
      }
      await stopAudio();
      isCallActive.value = true;
      callId.value = data['callId'] ?? '';
      isCallerInitiating.value = true; // Set caller role
      
      if (kDebugMode) {
        print('✅ [CALLER] Received call-active, setting up WebRTC...');
      }
      
      // Initialize WebRTC as caller
      try {
        // Ensure local stream is available
        if (webRTCService.localStream.value == null) {
          if (kDebugMode) {
            print('📸 Re-initializing media stream...');
          }
          await webRTCService.init();
          
          // Wait a bit for the stream to be fully initialized
          await Future.delayed(const Duration(milliseconds: 200));
        }
        
        if (kDebugMode) {
          print('📸 Local stream before peer connection: ${webRTCService.localStream.value != null}');
          if (webRTCService.localStream.value != null) {
            final stream = webRTCService.localStream.value!;
            print('📊 Local stream has ${stream.getTracks().length} tracks');
          }
        }
        
        await webRTCService.createPeerConnection();
        
        // Add a small delay to ensure peer connection is fully set up
        await Future.delayed(const Duration(milliseconds: 500));
        
        // CRITICAL: Only CALLER should create offer, NOT receiver
        if (!isCallerInitiating.value) {
          if (kDebugMode) {
            print('❌ CRITICAL BUG PREVENTION: Receiver tried to create offer in call-active! This should NEVER happen.');
            print('🔍 isCallerInitiating.value = ${isCallerInitiating.value}');
          }
          return; // Receiver must NOT create offer
        }
        
        // Create and send offer
        final offer = await webRTCService.createAndSendOffer();
        if (offer != null) {
          final rtcOffer = {
            "roomId": callId.value,
            "offer": {"type": "offer", "sdp": offer.sdp ?? ''},
            "receiverId": receiverRxId.value,
          };
          debugPrint('📞 Sending WebRTC Offer from Caller: $rtcOffer');
          callService.emit('webrtc-offer', rtcOffer);
        }
        
        // Navigate to video call screen
        Get.offNamed(AppRoute.videoCallScreen);
        
        Get.showSnackbar(
          const GetSnackBar(
            title: 'Call Accepted',
            message: 'The call has been accepted and is now active.',
            duration: Duration(seconds: 3),
          ),
        );
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error initializing WebRTC for caller: $e');
        }
        Get.showSnackbar(
          GetSnackBar(
            title: 'Error',
            message: 'Failed to start WebRTC: $e',
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    // WebRTC Signaling Listeners
    callService.on('webrtc-offer', (data) async {
      if (kDebugMode) {
        print('📞 Received WebRTC Offer: $data');
        print('📊 Current peer connection signaling state: ${webRTCService.peerConnection?.signalingState}');
      }
      try {
        final offer = data['offer'];
        if (offer != null) {
          // Log the current state before setting remote description
          if (kDebugMode) {
            print('🔍 Attempting to set remote offer...');
            print('📊 Peer connection exists: ${webRTCService.peerConnection != null}');
          }
          
          await webRTCService.setRemoteDescription(offer['sdp'], offer['type']);
          
          // Create and send answer
          final answer = await webRTCService.createAndSendAnswer();
          if (answer != null) {
            sendWebRTCAnswerFromReceiver(answer.sdp ?? '');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error handling WebRTC offer: $e');
          print('📊 Peer connection signaling state at error: ${webRTCService.peerConnection?.signalingState}');
        }
      }
    });

    callService.on('webrtc-answer', (data) async {
      if (kDebugMode) {
        print('📞 Received WebRTC Answer: $data');
      }
      try {
        final answer = data['answer'];
        if (answer != null) {
          await webRTCService.setRemoteDescription(answer['sdp'], answer['type']);
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error handling WebRTC answer: $e');
        }
      }
    });

    callService.on('ice-candidate', (data) async {
      if (kDebugMode) {
        print('📞 Received ICE Candidate: $data');
      }
      try {
        final candidate = data['candidate'];
        if (candidate != null) {
          await webRTCService.addIceCandidate(
            candidate['candidate'],
            candidate['sdpMid'] ?? '0',
            candidate['sdpMLineIndex'] ?? 0,
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error handling ICE candidate: $e');
        }
      }
    });
  }

  /// Setup WebRTC callbacks to send signaling data through socket
  void _setupWebRTCCallbacks() {
    webRTCService.onIceCandidate = (candidate) {
      if (isCallerInitiating.value) {
        iceCandidateFromCaller(candidate);
      } else {
        iceCandidateFromReceiver(candidate);
      }
    };

    webRTCService.onSignalingStateChange = (state, _) {
      if (kDebugMode) {
        print('🔔 Signaling State Changed: $state');
      }
    };
  }

  void startCallWithUser({
    required String hostId,
    required String receiverId,
    required String title,
    required String receiverName,
  }) {
    final call = {
      'hostUserId': hostId,
      'recipientUserId': receiverId,
      'title': title,
    };
    debugPrint('📞 Starting call with user: $call');
    callService.emit('start-call', call);
    receiverRxId.value = receiverId;
    isCallerInitiating.value = true; // Caller role
    if (callService.isConnected.value) {
      Get.to(() => OutgoingCallScreen(), arguments: receiverName);
    }
  }

  void declineCall() {
    final call = {'callId': callId.value};
    debugPrint('📞 Declining call: $call');
    callService.emit('decline-call', call);
    isCallEnded.value = true;
    _cleanupCall();
    Get.back();
  }

  void acceptCall() async {
    final call = {
      'callId': callId.value,
      'callerId': callerId.value,
    };
    debugPrint('📞 Accepting call: $call');
    if (kDebugMode) {
      print('🔍 [RECEIVER DEBUG] callerId.value = ${callerId.value}');
      print('🔍 [RECEIVER DEBUG] callId.value = ${callId.value}');
      print('🔍 [RECEIVER DEBUG] Sending to backend: $call');
    }
    callService.emit('accept-call', call);
    isCallActive.value = true;
    isCallerInitiating.value = false; // Set receiver role
    stopAudio();
    
    // Initialize WebRTC as receiver
    try {
      // Ensure local stream is available
      if (webRTCService.localStream.value == null) {
        if (kDebugMode) {
          print('📸 Initializing media stream for receiver...');
        }
        await webRTCService.init();
        
        // Wait a bit for the stream to be fully initialized
        await Future.delayed(const Duration(milliseconds: 200));
      }
      
      if (kDebugMode) {
        print('🔍 [RECEIVER] About to create peer connection...');
        print('📊 Local stream before PC creation: ${webRTCService.localStream.value != null}');
        if (webRTCService.localStream.value != null) {
          final stream = webRTCService.localStream.value!;
          print('📊 Local stream has ${stream.getTracks().length} tracks');
        }
      }
      
      await webRTCService.createPeerConnection();
      
      if (kDebugMode) {
        print('🔍 [RECEIVER] Peer connection created');
        print('📊 Signaling state after createPeerConnection: ${webRTCService.peerConnection?.signalingState}');
      }
      
      // DON'T create offer here - just wait for caller's offer
      // The receiver will create an answer when the offer arrives
      
      // Navigate to video call screen
      Get.offNamed(AppRoute.videoCallScreen);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error accepting call: $e');
      }
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Failed to start WebRTC: $e',
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void sendWebRTCOfferFromReceiver(String sdp) {
    final rtcOffer = {
      "roomId": callId.value,
      "offer": {"type": "offer", "sdp": sdp},
      "receiverId": callerId.value,
    };
    debugPrint('📞 Sending WebRTC Offer from Receiver: $rtcOffer');
    callService.emit('webrtc-offer', rtcOffer);
  }

  void sendWebRTCAnswerFromReceiver(String sdp) {
    final rtcAnswer = {
      "roomId": callId.value,
      "answer": {"type": "answer", "sdp": sdp},
      "callerId": callerId.value,
    };
    debugPrint('📞 Sending WebRTC Answer from Receiver: $rtcAnswer');
    callService.emit('webrtc-answer', rtcAnswer);
  }

  void sentWebRTCAnswerFromCaller(String sdp) {
    final rtcAnswer = {
      "roomId": callId.value,
      "answer": {"type": "answer", "sdp": sdp},
      "receiverId": receiverRxId.value,
    };
    debugPrint('📞 Sending WebRTC Answer from Caller: $rtcAnswer');
    callService.emit('webrtc-answer', rtcAnswer);
  }

  void iceCandidateFromCaller(dynamic candidate) {
    final iceCandidate = {
      "roomId": callId.value,
      "candidate": {
        "candidate": candidate.candidate ?? "",
        "sdpMid": candidate.sdpMid ?? "0",
        "sdpMLineIndex": candidate.sdpMLineIndex ?? 0
      },
      "targetUserId": receiverRxId.value,
    };
    debugPrint('📞 Sending ICE Candidate from Caller: $iceCandidate');
    callService.emit('ice-candidate', iceCandidate);
  }

  void iceCandidateFromReceiver(dynamic candidate) {
    final iceCandidate = {
      "roomId": callId.value,
      "candidate": {
        "candidate": candidate.candidate ?? "",
        "sdpMid": candidate.sdpMid ?? "0",
        "sdpMLineIndex": candidate.sdpMLineIndex ?? 0
      },
      "targetUserId": callerId.value,
    };
    debugPrint('📞 Sending ICE Candidate from Receiver: $iceCandidate');
    callService.emit('ice-candidate', iceCandidate);
  }

  void endCall() {
    final call = {
      'callId': callId.value,
      'callerId': callerId.value,
      'receiverId': receiverRxId.value,
    };
    debugPrint('📞 Ending call: $call');
    if (kDebugMode) {
      print('🔍 [END-CALL] Debug info:');
      print('  - callId: ${callId.value}');
      print('  - callerId: ${callerId.value}');
      print('  - receiverId: ${receiverRxId.value}');
    }
    callService.emit('end-call', call);
    _cleanupCall();
  }

  /// Cleanup call resources
  void _cleanupCall() async {
    try {
      await webRTCService.cleanup();
      callId.value = '';
      callerId.value = '';
      title.value = '';
      receiverRxId.value = '';
      isCallActive.value = false;
      isCallAccepted.value = false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cleaning up call: $e');
      }
    }
  }

   Future<void> playLoopingAudio() async {
    debugPrint('📞 Play Looping Audio');
    await audioPlayer.play(AssetSource('sounds/ringtone.wav'));
    
  }
    Future<void> stopAudio() async {
    debugPrint('📞 Stop Audio');
    await audioPlayer.stop();
    
  }

  @override
  void onClose() {
    _cleanupCall();
    callService.off('incoming-call');
    callService.off('call-active');
    callService.off('call-declined');
    callService.off('call-ended');
    callService.off('webrtc-offer');
    callService.off('webrtc-answer');
    callService.off('ice-candidate');
    audioPlayer.dispose();
    super.onClose();
  }



  Future<void> fetchReceiverProfile() async {
    if (callerId.isEmpty) {
      debugPrint('selectedUserId is empty');
      return;
    }
    

    try {

      final response = await HttpNetworkClient().getRequest(
        url: '${Urls.getUserProfile}/${callerId.value}',
      );

      debugPrint('receiver profile response: ${response.responseData}');

      if (response.statusCode == 200) {
        final data = response.responseData;
        callerName.value = data?['data']?['profile']?['name'] ?? '';
        callerImage.value = data?['data']?['profile']?['avatarUrl'] ?? '';
        debugPrint('Caller info fetched: ${callerName.value}');
      }
    } catch (e) {
      debugPrint('Error fetching receiver profile: $e');
    } finally {
      
    }
  }
}

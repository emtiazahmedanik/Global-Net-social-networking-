import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/real_time_calling/controller/call_controller.dart';
import 'package:jdadzok/feature/real_time_calling/service/webrtc_service.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final CallController callController = Get.find<CallController>();
  final WebRTCService webRTCService = Get.find<WebRTCService>();

  late RTCVideoRenderer localVideoRenderer;
  late RTCVideoRenderer remoteVideoRenderer;

  final RxBool isLocalRendererReady = false.obs;
  
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    isDisposed = false;
    localVideoRenderer = RTCVideoRenderer();
    remoteVideoRenderer = RTCVideoRenderer();
    
    // Initialize renderers and set up stream listeners immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isDisposed) {
        _initializeStreamHandling();
      }
    });
  }

  Future<void> _initializeStreamHandling() async {
    try {
      // Initialize renderers first
      await initRenderers();
      
      if (isDisposed) return;
      
      // Set up listeners to handle stream updates
      // Local stream listener
      ever(webRTCService.localStream, (stream) {
        if (isDisposed) return;
        debugPrint('📹 Local stream changed: ${stream != null ? "available" : "null"}');
        if (stream != null) {
          try {
            localVideoRenderer.srcObject = stream;
            isLocalRendererReady.value = true;
            debugPrint('✅ Local stream set to renderer');
            debugPrint('📊 Local stream tracks: ${stream.getTracks().length}');
            for (var track in stream.getTracks()) {
              debugPrint('📊 Local ${track.kind} track - enabled: ${track.enabled}, label: ${track.label}');
            }
          } catch (e) {
            debugPrint('❌ Error setting local stream: $e');
          }
        }
      });
      
      // Remote stream listener
      ever(webRTCService.remoteStream, (stream) {
        if (isDisposed) return;
        debugPrint('\n🎥 ===== REMOTE STREAM UPDATE =====');
        debugPrint('📹 Remote stream changed: ${stream != null ? "AVAILABLE ✅" : "NULL ❌"}');
        if (stream != null) {
          try {
            debugPrint('🔧 Setting remote stream to renderer...');
            remoteVideoRenderer.srcObject = stream;
            debugPrint('✅ Remote stream set to renderer SUCCESS');
            debugPrint('📊 Remote stream ID: ${stream.id}');
            debugPrint('📊 Remote stream tracks: ${stream.getTracks().length}');
            for (var track in stream.getTracks()) {
              debugPrint('   📊 Remote ${track.kind} track - enabled: ${track.enabled}, label: ${track.label}');
            }
            debugPrint('===== END REMOTE STREAM UPDATE =====\n');
          } catch (e) {
            debugPrint('❌ CRITICAL ERROR setting remote stream: $e');
            debugPrint('===== END REMOTE STREAM UPDATE =====\n');
          }
        } else {
          debugPrint('⚠️ Remote stream is NULL - no video/audio will show');
          debugPrint('===== END REMOTE STREAM UPDATE =====\n');
        }
      });
      
      // Trigger initial values if streams are already available
      if (webRTCService.localStream.value != null && !isDisposed) {
        try {
          localVideoRenderer.srcObject = webRTCService.localStream.value;
          isLocalRendererReady.value = true;
          debugPrint('✅ Local stream set to renderer (initial)');
          final stream = webRTCService.localStream.value!;
          debugPrint('📊 Local stream tracks: ${stream.getTracks().length}');
          for (var track in stream.getTracks()) {
            debugPrint('📊 Local ${track.kind} track - enabled: ${track.enabled}, label: ${track.label}');
          }
        } catch (e) {
          debugPrint('❌ Error setting initial local stream: $e');
        }
      }
      
      if (webRTCService.remoteStream.value != null && !isDisposed) {
        try {
          remoteVideoRenderer.srcObject = webRTCService.remoteStream.value;
          debugPrint('✅ Remote stream set to renderer (initial)');
          final stream = webRTCService.remoteStream.value!;
          debugPrint('📊 Remote stream tracks: ${stream.getTracks().length}');
          for (var track in stream.getTracks()) {
            debugPrint('📊 Remote ${track.kind} track - enabled: ${track.enabled}, label: ${track.label}');
          }
        } catch (e) {
          debugPrint('❌ Error setting initial remote stream: $e');
        }
      }
    } catch (e) {
      if (!isDisposed) {
        debugPrint('❌ Error during stream handling initialization: $e');
      }
    }
  }

  Future<void> initRenderers() async {
    try {
      debugPrint('🎬 Initializing local video renderer...');
      await localVideoRenderer.initialize();
      debugPrint('✅ Local renderer initialized');
      
      debugPrint('🎬 Initializing remote video renderer...');
      await remoteVideoRenderer.initialize();
      debugPrint('✅ Remote renderer initialized');

      if (isDisposed) return;

      // Don't set streams here anymore - let listeners handle it
      // This prevents timing issues and ensures proper update propagation
      debugPrint('🎬 Renderers ready, streams will be set by listeners');
    } catch (e) {
      debugPrint('❌ Error initializing renderers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            /// Remote Video (Background)
            Obx(
              () {
                if (webRTCService.remoteStream.value == null) {
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[800],
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            callController.title.value,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => Text(
                              webRTCService.connectionState.value,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RTCVideoView(
                  remoteVideoRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                );
              },
            ),

            /// Local Video (PiP - Picture in Picture)
            Positioned(
              right: 16,
              bottom: 110,
              child: Obx(
                () {
                  final lv = isLocalRendererReady.value;
                  debugPrint('📍 Building local video widget - renderer ready: $lv');
                  if (webRTCService.localStream.value == null) {
                    return Container(
                      width: 120,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.videocam_off,
                        color: Colors.white,
                      ),
                    );
                  }

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 120,
                      height: 160,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RTCVideoView(
                        localVideoRenderer,
                        mirror: true,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Top Info Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            callController.title.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(
                          () => Text(
                            webRTCService.connectionState.value,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Add any top right widgets here
                  ],
                ),
              ),
            ),

            /// Bottom Control Buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /// Mic Toggle
                    _controlButton(
                      onTap: () async {
                        final isEnabled =
                            !webRTCService.isAudioEnabled.value;
                        await webRTCService.toggleAudio(isEnabled);
                      },
                      icon: Obx(
                        () => Icon(
                          webRTCService.isAudioEnabled.value
                              ? Icons.mic
                              : Icons.mic_off,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),

                    /// End Call
                    _controlButton(
                      onTap: () {
                        _endCall();
                      },
                      icon: const Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 28,
                      ),
                      backgroundColor: Colors.red,
                    ),

                    /// Camera Toggle
                    _controlButton(
                      onTap: () async {
                        final isEnabled =
                            !webRTCService.isVideoEnabled.value;
                        await webRTCService.toggleVideo(isEnabled);
                      },
                      icon: Obx(
                        () => Icon(
                          webRTCService.isVideoEnabled.value
                              ? Icons.videocam
                              : Icons.videocam_off,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlButton({
    required VoidCallback onTap,
    required Widget icon,
    Color backgroundColor = Colors.grey,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 32,
        backgroundColor: backgroundColor,
        child: icon,
      ),
    );
  }

  void _endCall() {
    Get.dialog(
      AlertDialog(
        title: const Text('End Call'),
        content: const Text('Are you sure you want to end this call?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              callController.endCall();
              Get.back();
              _disposeRenderers();
            },
            child: const Text('End Call', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _disposeRenderers() async {
    try {
      await localVideoRenderer.dispose();
      await remoteVideoRenderer.dispose();
    } catch (e) {
      debugPrint('❌ Error disposing renderers: $e');
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    _disposeRenderers();
    super.dispose();
  }
}

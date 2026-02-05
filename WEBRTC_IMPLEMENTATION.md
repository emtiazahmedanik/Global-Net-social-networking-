# WebRTC Real-Time Calling Implementation Guide

## Overview
Complete WebRTC integration for real-time video calling with Socket.io signaling. This implementation handles both caller and receiver roles with proper WebRTC peer connection management.

## Architecture

### 1. **WebRTC Service** (`webrtc_service.dart`)
Core WebRTC peer connection management with the following features:

#### Key Components:
- **Media Streams**: 
  - `localStream`: User's camera and microphone
  - `remoteStream`: Remote participant's video/audio
  
- **Peer Connection Management**:
  - Creates RTCPeerConnection with STUN servers
  - Manages offer/answer negotiation
  - Handles ICE candidate collection and addition
  
- **State Tracking**:
  - `connectionState`: Current peer connection status
  - `isAudioEnabled`: Mic toggle state
  - `isVideoEnabled`: Camera toggle state
  
- **Key Methods**:
  ```dart
  init()                          // Initialize media streams
  createPeerConnection()          // Create peer connection
  createAndSendOffer()           // Create SDP offer
  createAndSendAnswer()          // Create SDP answer
  setRemoteDescription()         // Set remote SDP
  addIceCandidate()             // Add ICE candidate
  toggleAudio(bool enabled)     // Toggle microphone
  toggleVideo(bool enabled)     // Toggle camera
  cleanup()                     // Clean up resources
  ```

#### Callbacks:
- `onIceCandidate`: Triggered when ICE candidate is available
- `onSignalingStateChange`: Triggered on signaling state changes

---

### 2. **Call Controller** (`call_controller.dart`)
Orchestrates call logic and WebRTC signaling through Socket.io

#### State Variables:
- `callId`: Current call identifier
- `callerId`: Remote participant ID
- `title`: Caller's name/title
- `receiverRxId`: Receiver's user ID
- `isCallerInitiating`: Role identifier (true = caller, false = receiver)
- `isCallActive`: Call status
- `isCallEnded`: Call termination status

#### Call Flow - Receiver Side:
1. Socket event `incoming-call` received
2. UI shows `IncomingCallScreen`
3. User taps Accept → `acceptCall()` triggered
4. WebRTC peer connection created
5. SDP Offer generated and sent via Socket
6. Wait for remote SDP Answer
7. Navigate to `VideoCallScreen`

#### Call Flow - Caller Side:
1. `startCallWithUser()` called
2. Socket emits `start-call` event
3. UI shows `OutgoingCallScreen`
4. Receiver accepts call → Socket event `call-active` received
5. WebRTC peer connection created
6. SDP Offer generated and sent
7. Receive SDP Answer from receiver
8. Navigate to `VideoCallScreen`

#### WebRTC Signaling Methods:
```dart
sendWebRTCOfferFromReceiver(String sdp)     // Receiver sends offer
sendWebRTCAnswerFromReceiver(String sdp)    // Receiver sends answer
sentWebRTCAnswerFromCaller(String sdp)      // Caller sends answer
iceCandidateFromCaller(dynamic candidate)   // Caller sends ICE
iceCandidateFromReceiver(dynamic candidate) // Receiver sends ICE
```

#### Socket Event Listeners:
- `incoming-call`: Handle incoming call request
- `call-started`: Handle call start acknowledgment
- `call-declined`: Handle call rejection
- `call-active`: Handle call acceptance (caller side)
- `webrtc-offer`: Handle remote SDP offer
- `webrtc-answer`: Handle remote SDP answer
- `ice-candidate`: Handle remote ICE candidate

---

### 3. **Video Call Screen** (`video_call_screen.dart`)
Real-time video rendering with UI controls

#### Layout:
- **Remote Video** (Full Screen): Shows remote participant
- **Local Video** (PiP): Picture-in-picture of own camera (120x160)
- **Top Bar**: Call info (name, connection status)
- **Control Buttons**:
  - Mic Toggle (on/off)
  - End Call (red button)
  - Camera Toggle (on/off)

#### Rendering:
```dart
RTCVideoView(remoteVideoRenderer)  // Remote video
RTCVideoView(localVideoRenderer)   // Local video (mirrored)
```

#### State Management:
- Uses `Obx()` for reactive video stream updates
- Displays placeholder when streams unavailable
- Shows connection status in real-time

---

### 4. **Call Service** (`call_service.dart`)
Socket.io wrapper for call signaling

#### Key Features:
- Authentication with JWT token
- Emit and listen to socket events
- Automatic reconnection handling
- Debug logging for all socket events

#### Main Methods:
```dart
emit(String event, dynamic data)      // Send socket event
on(String event, callback)            // Listen to socket event
off(String event)                     // Remove listener
reconnect()                           // Reconnect to socket
disconnect()                          // Disconnect from socket
```

---

## WebRTC Signaling Flow

### Diagram: Call Establishment

```
Receiver                                    Caller
   |                                          |
   |<-------- Socket: start-call -----------|
   | (Show incoming call screen)             |
   |                                          |
   |-- Accept Call -->|                      |
   |                  |-- Socket: accept-call --------->|
   |                  |                      | (Show outgoing call screen)
   |                  |                      | Create peer connection
   |                  |<-- Socket: call-active --------|
   |                  |                      | Send WebRTC Offer
   |                  |                      |
   | Create peer connection                 |
   | Receive WebRTC Offer                   |
   | Send WebRTC Answer <-- Socket: webrtc-answer <--|
   |                                          |
   |-- Socket: webrtc-answer --------->|     |
   |                                   |     |
   |<---- Socket: ice-candidate <-----|<----|
   |---- Socket: ice-candidate ------->|---->|
   |                                          |
   |<========== Media Streams ==============|
   |           (Video/Audio)                 |
   |                                          |
```

### Signaling Events

1. **Call Initiation**
   - Event: `start-call`
   - Data: `{hostUserId, recipientUserId, title}`

2. **Call Acceptance**
   - Event: `accept-call` → Server → `call-active`
   - Data: `{callId}`

3. **WebRTC Offer (From Receiver)**
   - Event: `webrtc-offer`
   - Data: `{roomId, offer: {type, sdp}, receiverId}`

4. **WebRTC Answer**
   - Event: `webrtc-answer`
   - Data: `{roomId, answer: {type, sdp}, receiverId}`

5. **ICE Candidates**
   - Event: `ice-candidate`
   - Data: `{roomId, candidate: {candidate, sdpMid, sdpMLineIndex}, targetUserId}`

---

## Initialization

### In `main.dart`:

```dart
Future<void> initServices() async {
  // Notification service
  Get.put(AllNotificationController(), permanent: true);
  
  // Socket services
  Get.put(SocketService(), permanent: true);
  Get.put(CallService(), permanent: true);
  Get.put(WebRTCService(), permanent: true);
  
  // Initialize in order
  await Get.find<SocketService>().init();
  await Get.find<CallService>().init();
  await Get.find<WebRTCService>().init();
  
  // Controller (depends on above services)
  Get.put(CallController(), permanent: true);
}
```

**Initialization Order is Critical:**
1. SocketService (base communication)
2. CallService (call signaling)
3. WebRTCService (media/peer connection)
4. CallController (orchestration)

---

## Important Implementation Details

### Permission Requirements
The app requires runtime permissions:
- **Camera**: For video capture
- **Microphone**: For audio capture

Handle these in platform-specific code (Android/iOS manifest files).

### STUN/TURN Servers
Current configuration uses Google's public STUN servers:
```dart
{
  'iceServers': [
    {'urls': ['stun:stun.l.google.com:19302', 'stun:stun1.l.google.com:19302']}
  ]
}
```

For production, consider adding TURN servers for better NAT traversal:
```dart
{
  'iceServers': [
    {'urls': ['stun:stun.l.google.com:19302']},
    {
      'urls': ['turn:your-turn-server.com:3478?transport=udp'],
      'username': 'username',
      'credential': 'password'
    }
  ]
}
```

### Error Handling
- All async operations wrapped in try-catch
- User-friendly error messages via Get.showSnackbar
- Debug logging for troubleshooting

### Resource Cleanup
- Proper disposal of video renderers
- Stream cleanup on call end
- Peer connection closure
- Called automatically in `_cleanupCall()` and `onClose()`

---

## Usage Example

### Starting a Call
```dart
callController.startCallWithUser(
  hostId: 'user123',
  receiverId: 'user456',
  title: 'John Doe',
  receiverName: 'Jane Doe',
);
```

### Accepting a Call
```dart
callController.acceptCall();  // Automatically navigates to VideoCallScreen
```

### Declining a Call
```dart
callController.declineCall();  // Cleans up resources and goes back
```

### Toggling Media
```dart
webRTCService.toggleAudio(false);  // Disable mic
webRTCService.toggleVideo(false);  // Disable camera
```

---

## Troubleshooting

### WebRTC Connection Not Establishing
1. Check STUN/TURN server connectivity
2. Verify Firebase or custom signaling server is accessible
3. Check firewall settings for WebRTC ports
4. Review console logs for ICE candidate errors

### No Video/Audio
1. Ensure camera/microphone permissions granted
2. Check `localStream` is not null
3. Verify media devices are not in use elsewhere
4. Check device is not muted at OS level

### Socket Connection Issues
1. Verify JWT token is valid
2. Check socket server is running
3. Verify correct socket URL in Endpoints
4. Check network connectivity

### Performance Issues
1. Reduce video constraints (resolution/framerate)
2. Monitor ICE candidate gathering time
3. Check for WebRTC connection negotiation delays
4. Monitor memory usage during calls

---

## Files Modified/Created

### New Files:
- [lib/feature/real_time_calling/service/webrtc_service.dart](lib/feature/real_time_calling/service/webrtc_service.dart)
- [lib/feature/real_time_calling/screen/video_call_screen.dart](lib/feature/real_time_calling/screen/video_call_screen.dart)

### Modified Files:
- [lib/feature/real_time_calling/controller/call_controller.dart](lib/feature/real_time_calling/controller/call_controller.dart)
- [lib/main.dart](lib/main.dart)

### Unchanged (Existing):
- [lib/feature/real_time_calling/service/call_service.dart](lib/feature/real_time_calling/service/call_service.dart)
- [lib/feature/real_time_calling/screen/incoming_call_screen.dart](lib/feature/real_time_calling/screen/incoming_call_screen.dart)
- [lib/feature/real_time_calling/screen/outgoing_call_screen.dart](lib/feature/real_time_calling/screen/outgoing_call_screen.dart)

---

## Next Steps

1. **Test the Implementation**
   - Test with two devices/emulators
   - Verify video/audio transmission
   - Test call decline/end scenarios

2. **Add Features**
   - Screen sharing
   - Recording functionality
   - Call history
   - Video quality settings
   - Switch between front/back camera

3. **Optimization**
   - Implement video quality adaptation
   - Add bandwidth monitoring
   - Cache ICE candidates
   - Implement reconnection logic

4. **Security**
   - Implement end-to-end encryption (SRTP)
   - Add call authentication tokens
   - Implement rate limiting for calls
   - Add call logs for audit

5. **Production Deployment**
   - Set up production TURN servers
   - Implement monitoring/analytics
   - Add proper error handling UI
   - Implement battery optimization

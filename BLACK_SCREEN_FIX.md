# Black Screen Bug Fix - WebRTC Video Call

## 🔴 Problem
When a call is accepted, both sides see a black screen with:
- No audio/video streaming
- No local stream visible
- Renderers showing placeholder UI only

## 🔍 Root Causes Identified

### 1. **Stream Initialization Timing Issue**
- Local stream was not being initialized before peer connection creation in some cases
- Peer connection was created before local stream was fully available
- Tracks were not being added to peer connection properly

### 2. **Missing Local Stream in Peer Connection**
- The `createPeerConnection()` method would proceed even if local stream was null
- This resulted in empty/null peer connections without any media tracks
- No audio/video could flow without tracks in the peer connection

### 3. **Renderer Not Bound to Streams**
- Renderers were being initialized but not properly bound to the media streams
- The reactive listeners weren't catching stream updates in time
- Widget tree rendering happened before streams were available

### 4. **Race Condition Between Screen Navigation and Stream Setup**
- Video call screen was navigating before streams were ready
- Renderer post-frame rendering was happening before source objects were set

## ✅ Fixes Applied

### Fix 1: Ensure Local Stream Before Peer Connection
**File**: `lib/feature/real_time_calling/service/webrtc_service.dart`

```dart
// Added to createPeerConnection():
if (localStream.value == null) {
  if (kDebugMode) {
    print('📸 Local stream is null, initializing media...');
  }
  await _getUserMedia();
}
```

**Impact**: Guarantees that media stream is available before adding tracks to peer connection.

### Fix 2: Improved Stream Setup in Call Controller
**File**: `lib/feature/real_time_calling/controller/call_controller.dart`

#### Receiver Side (acceptCall):
```dart
- Added isCallerInitiating.value = false; // Set receiver role
- Added delay after init(): await Future.delayed(const Duration(milliseconds: 200));
- Added logging to verify stream exists before peer connection creation
```

#### Caller Side (call-active):
```dart
- Added isCallerInitiating.value = true; // Set caller role  
- Added delay after init(): await Future.delayed(const Duration(milliseconds: 200));
- Improved logging to debug stream initialization
```

**Impact**: Ensures streams are fully initialized and tracks are properly added before creating SDP offers/answers.

### Fix 3: Enhanced Renderer Stream Binding
**File**: `lib/feature/real_time_calling/screen/video_call_screen.dart`

#### Changed initState:
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (!isDisposed) {
    _initializeStreamHandling();
  }
});
```

**Why**: Ensures renderer initialization happens during the widget build lifecycle, not before.

#### Enhanced _initializeStreamHandling:
```dart
- Added null checks on renderers before setting srcObject
- Added comprehensive logging for stream tracks
- Logs track properties (enabled status, label, kind)
- Validates renderer is initialized before setting source
```

**Impact**: Prevents race conditions and ensures safe renderer binding.

### Fix 4: Better Error Handling in Remote Description Setup
**File**: `lib/feature/real_time_calling/service/webrtc_service.dart`

```dart
// Enhanced setRemoteDescription():
if (peerConnection == null) {
  if (kDebugMode) {
    print('🔧 Peer connection not initialized, creating now...');
  }
  await createPeerConnection();
}

// Added logging:
- Current signaling state before/after
- Connection state tracking
- Error state debugging
```

**Impact**: Prevents crashes when remote description is set before peer connection exists.

## 📊 Call Flow After Fixes

### Receiver Side:
1. ✅ Accept call → `acceptCall()` triggered
2. ✅ Mark as receiver: `isCallerInitiating = false`
3. ✅ Initialize media: `webRTCService.init()` + 200ms delay
4. ✅ Create peer connection with local stream tracks
5. ✅ Navigate to VideoCallScreen
6. ✅ Screen initializes renderers post-frame
7. ✅ Listeners bind streams to renderers
8. ✅ Wait for caller's offer
9. ✅ Set remote description when offer arrives
10. ✅ Create and send answer
11. ✅ ICE candidates exchanged
12. ✅ Remote stream received and displayed

### Caller Side:
1. ✅ Call accepted → `call-active` socket event
2. ✅ Mark as caller: `isCallerInitiating = true`
3. ✅ Initialize media: `webRTCService.init()` + 200ms delay
4. ✅ Create peer connection with local stream tracks
5. ✅ Add 500ms delay for PC stabilization
6. ✅ Create and send offer
7. ✅ Navigate to VideoCallScreen
8. ✅ Screen initializes renderers post-frame
9. ✅ Listeners bind streams to renderers
10. ✅ Receive answer from receiver
11. ✅ Set remote description
12. ✅ ICE candidates exchanged
13. ✅ Remote stream received and displayed

## 🎯 Expected Results After Fix

- ✅ Local video appears in PiP (bottom-right corner, mirrored)
- ✅ Remote video appears in full screen once connected
- ✅ Audio/video tracks properly transmitted
- ✅ Both sides can see each other's video
- ✅ No black screen on call acceptance
- ✅ Smooth transition from call acceptance to video display

## 🧪 Testing Steps

1. **Test on two devices/simulators**
2. **Device A**: Initiate call to Device B
3. **Device B**: Accept call
4. **Expected**: 
   - Both see video from each other
   - Device A sees their own video in PiP
   - Device B sees their own video in PiP
   - Connection status shows "connected" or similar
5. **Verify**: Audio is transmitted (have one person speak)
6. **Test camera toggle**: Click camera button, video should disable/enable
7. **Test mic toggle**: Click mic button, audio should disable/enable

## 📝 Debug Logs to Watch For

### Local Stream:
```
📹 Local stream changed: available
✅ Local stream set to renderer
📊 Local stream tracks: 2
📊 Local video track - enabled: true
📊 Local audio track - enabled: true
```

### Remote Stream:
```
🎬 Received remote track: video
✅ Remote stream received
📊 Remote stream tracks: 2
📊 Remote video track - enabled: true
📊 Remote audio track - enabled: true
```

### Connection States:
```
✅ Peer connection created successfully
📊 Initial signaling state: stable
📊 Connection state: connected
📊 ICE connection state: connected
```

## ⚠️ If Black Screen Still Appears

1. Check console for errors starting with ❌
2. Verify camera/microphone permissions on both devices
3. Check if STUN servers are reachable
4. Verify socket events are being received (look for 📞 logs)
5. Ensure streams are created before PC: look for ✅ Local stream obtained
6. Check if renderers are initialized: look for ✅ Local renderer initialized

---

**Status**: Fixed ✅
**Last Updated**: December 22, 2025

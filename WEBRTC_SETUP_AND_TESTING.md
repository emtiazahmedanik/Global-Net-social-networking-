# WebRTC Real-Time Calling - Setup & Testing Guide

## 🎯 Overview
Complete WebRTC integration for real-time video calling with Socket.io signaling. Both caller and receiver can exchange video/audio streams with proper signaling through a Socket.io server.

---

## 📦 Requirements Met

### Dependencies
✅ `flutter_webrtc: ^1.2.1` - Already in pubspec.yaml
✅ `socket_io_client: ^3.1.3` - Already in pubspec.yaml
✅ `get: ^4.7.2` - Already in pubspec.yaml

### Services Initialized
✅ WebRTCService - Media & peer connection management
✅ CallService - Socket.io signaling
✅ CallController - Call flow orchestration

---

## 🔧 Setup Instructions

### Step 1: Verify Dependencies
```bash
cd /Users/bdcalling/emtiaz/jdadzok
flutter pub get
```

### Step 2: Platform-Specific Permissions

#### Android Setup
**File**: `android/app/src/main/AndroidManifest.xml`

Add permissions:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

**File**: `android/build.gradle`
Ensure minSdkVersion is at least 21:
```gradle
defaultConfig {
    minSdkVersion 21
}
```

#### iOS Setup
**File**: `ios/Runner/Info.plist`

Add:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to conduct video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to conduct video calls</string>
<key>NSLocalNetworkUsageDescription</key>
<string>This app needs local network access for WebRTC</string>
<key>NSBonjourServices</key>
<array>
  <string>_http._tcp</string>
  <string>_ws._tcp</string>
</array>
</key>
```

### Step 3: Build & Run

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run the app
flutter run
```

---

## 🧪 Testing Procedure

### Test 1: Basic Connection
**Objective**: Verify WebRTC service initializes correctly

**Steps**:
1. Run the app
2. Check console logs for initialization messages:
   ```
   ✅ Local media stream obtained
   ✅ Peer connection created
   ```
3. Verify no errors in console

**Expected Result**: ✅ App launches without errors, logs show successful initialization

---

### Test 2: Incoming Call (Receiver Side)
**Objective**: Test receiving and accepting a call

**Setup**:
- Device A: Receiving device
- Device B: Calling device

**Steps**:
1. Open app on Device A (Receiver)
2. Navigate to a user profile on Device B
3. Tap "Call" button (ensure `startCallWithUser()` is called)
4. On Device A, incoming call screen should appear with:
   - Caller name
   - "Incoming video call" text
   - Decline & Accept buttons

**Expected Result**: ✅ IncomingCallScreen displays with correct caller info

---

### Test 3: Call Acceptance (Receiver)
**Objective**: Test WebRTC initialization when receiver accepts

**Prerequisites**: Complete Test 2

**Steps**:
1. On Device A, tap "Accept" button
2. Both devices should initialize WebRTC
3. Watch for console logs:
   ```
   📞 Accepting call: {callId: ...}
   ✅ Peer connection created
   📤 Offer created: offer
   📞 Sending WebRTC Offer from Receiver
   ```
4. VideoCallScreen should appear on receiver side

**Expected Result**: ✅ WebRTC peer connection created, VideoCallScreen displayed

---

### Test 4: Call Establishment (Caller)
**Objective**: Test caller side when receiver accepts

**Prerequisites**: Complete Test 3 halfway

**Steps**:
1. On Device B (Caller), OutgoingCallScreen shows "Calling..."
2. After Device A accepts, Device B should receive `call-active` event
3. Console should show:
   ```
   📞 Call Accepted
   ✅ Peer connection created
   📤 Offer created: offer
   📞 Sending WebRTC Offer from Caller
   ```
4. VideoCallScreen appears on caller side after ~2-5 seconds

**Expected Result**: ✅ Both sides now on VideoCallScreen, WebRTC initializing

---

### Test 5: Media Stream Exchange
**Objective**: Verify video and audio transmission

**Prerequisites**: Complete Tests 2-4, both on VideoCallScreen

**Steps**:
1. On Device B (Caller), watch for console:
   ```
   ✅ Remote stream received
   📡 Connection State: connected
   ```
2. Remote video should appear in main view on both devices
3. Local video should show in PiP (bottom-right) on both devices
4. Verify video shows correctly:
   - Remote: Full screen with caller info when not connected
   - Local: Mirror image (flipped) in PiP
5. Audio should transmit (have someone speak on Device A)

**Expected Result**: ✅ Both video feeds visible, audio transmitting

---

### Test 6: Media Controls
**Objective**: Test microphone and camera toggle

**Prerequisites**: Complete Test 5, active video call

**Steps**:
1. **Test Microphone Toggle**:
   - Tap microphone icon (should toggle on/off)
   - Console shows: `🔊 Audio disabled` or `🔊 Audio enabled`
   - Watch remote side: Remote microphone indicator should reflect state

2. **Test Camera Toggle**:
   - Tap camera icon (should toggle on/off)
   - Console shows: `📹 Video disabled` or `📹 Video enabled`
   - On remote side, local video should disappear/reappear

**Expected Result**: ✅ Controls toggle media state correctly

---

### Test 7: Call End
**Objective**: Test call termination and cleanup

**Prerequisites**: Active video call from Tests 2-6

**Steps**:
1. Tap the red "End Call" button
2. Confirmation dialog appears
3. Tap "End Call" in dialog
4. Both devices return to previous screens
5. Console shows:
   ```
   📞 Declining call
   ✅ Peer connection closed
   ✅ WebRTC resources cleaned up
   ```

**Expected Result**: ✅ Call ends cleanly, resources freed, app stable

---

### Test 8: Call Decline
**Objective**: Test rejecting an incoming call

**Prerequisites**: Device A showing IncomingCallScreen

**Steps**:
1. On Device A, tap "Decline" button
2. IncomingCallScreen closes
3. On Device B, OutgoingCallScreen shows "Call declined"
4. Both return to normal state
5. Both can initiate new calls

**Expected Result**: ✅ Call properly declined, both sides recoverable

---

### Test 9: Network Interruption
**Objective**: Test connection loss recovery

**Prerequisites**: Active video call

**Steps**:
1. During active call, toggle airplane mode on one device
2. Observe connection state:
   ```
   📡 Connection State: disconnected
   ```
3. Turn off airplane mode
4. Watch for reconnection attempts
5. Connection may not recover (depends on server) - this is expected

**Expected Result**: ⚠️ Connection state updates, graceful degradation

---

### Test 10: Stress Test
**Objective**: Verify app stability during extended call

**Steps**:
1. Start a video call
2. Let it run for 5 minutes
3. Toggle mic/camera on and off multiple times
4. Monitor memory usage (should remain stable)
5. Check console for any errors
6. End call gracefully

**Expected Result**: ✅ App remains stable, no memory leaks

---

## 🔍 Debugging Tips

### Enable Verbose Logging
The app already has `debugPrint()` and conditional logging with `kDebugMode`:

```bash
# Run with verbose logging
flutter run -v
```

### Monitor Console for Events
Key events to watch:
```
📞 Incoming Call          - Call received
📞 Accepting call         - User accepts
✅ Peer connection created - WebRTC ready
🧊 ICE Candidate          - Network negotiation
📡 Connection State       - Connection changes
✅ Remote stream received - Video/audio arriving
```

### Check Connection States
Watch for state transitions:
```
new → connecting → connected → disconnected → closed
```

### Verify Stream Objects
Check stream logs:
```dart
print('Local tracks: ${localStream.getTracks().length}');
print('Remote tracks: ${remoteStream.getTracks().length}');
```

---

## ⚠️ Common Issues & Solutions

### Issue: "Permission Denied" on Camera/Mic
**Solution**:
1. Check AndroidManifest.xml has permissions
2. On device, grant permissions in Settings > Apps
3. For iOS, check Info.plist entries
4. Use `flutter run` with `-v` for permission logs

### Issue: Video Not Appearing
**Solution**:
1. Verify both `localStream` and `remoteStream` are not null
2. Check RTCVideoRenderer is initialized
3. Verify `setSrcObject()` was called successfully
4. Check for console errors about stream assignment

### Issue: "Socket Not Connected"
**Solution**:
1. Verify socket server URL in `call_service.dart`
2. Check JWT token in SharedPreferences
3. Verify network connectivity
4. Check firewall isn't blocking WebSocket

### Issue: Stuck on "Calling..."
**Solution**:
1. Check receiver's app is running
2. Verify socket server is online
3. Check console for WebRTC connection errors
4. Try call in opposite direction to isolate issue

### Issue: One-Way Audio/Video
**Solution**:
1. Check media stream has correct tracks
2. Verify `onTrack` callback is firing
3. Check ICE candidates are exchanged
4. Monitor connection state logs

### Issue: App Crashes on Call End
**Solution**:
1. Ensure `dispose()` is called properly
2. Check for null references in cleanup
3. Verify renderers are disposed before access
4. Check no listeners remain after close

---

## 📊 Performance Expectations

### Typical Performance Metrics
- **Connection Time**: 2-5 seconds (depends on ICE gathering)
- **Frame Rate**: 30 FPS (set in constraints)
- **Video Resolution**: 640x480 minimum
- **Memory Usage**: ~50-100 MB for active call
- **Battery Impact**: Moderate (camera + WebRTC)

### Optimization Tips
1. Use TURN servers for NAT traversal
2. Reduce video resolution on slow networks
3. Enable hardware acceleration
4. Close other apps during calls
5. Check battery saver isn't limiting resources

---

## 📱 Test Device Recommendations

### Minimum Requirements
- **OS**: Android 5.1+ or iOS 12.0+
- **RAM**: 2GB minimum
- **Camera**: Any working camera
- **Microphone**: Any working microphone
- **Network**: Stable WiFi recommended

### Recommended for Testing
- 2 physical devices (not emulators for real testing)
- Connected to same WiFi network (for local STUN)
- Recent devices for best performance

### Emulator Notes
- Android emulator supports WebRTC (camera emulation)
- iOS simulator has limited camera support
- Expect 2-3x slower performance vs physical device

---

## ✅ Sign-Off Checklist

Before considering implementation complete:

- [ ] No compilation errors
- [ ] No runtime errors on app startup
- [ ] Two-device test: Call can be initiated
- [ ] Two-device test: Call can be accepted
- [ ] Two-device test: Video streams visible both ways
- [ ] Two-device test: Audio transmits both ways
- [ ] Single-device test: Mic toggle works
- [ ] Single-device test: Camera toggle works
- [ ] Single-device test: End call works
- [ ] Single-device test: Decline call works
- [ ] Extended call test: 5 minutes stable
- [ ] Memory test: No leaks detected
- [ ] Console: No warnings or errors

---

## 📞 Support & Troubleshooting

### Getting Help
1. Check console logs with `flutter run -v`
2. Review [WEBRTC_IMPLEMENTATION.md](WEBRTC_IMPLEMENTATION.md) for architecture
3. Check [WEBRTC_QUICK_REFERENCE.md](WEBRTC_QUICK_REFERENCE.md) for code examples
4. Review this testing guide for specific test procedures

### Reporting Issues
Include:
1. Console logs (full output)
2. Device info (OS version, device model)
3. Steps to reproduce
4. Expected vs actual behavior
5. Screenshots/videos if applicable

---

**Setup Date**: December 22, 2025
**Last Updated**: December 22, 2025
**Status**: ✅ Ready for Testing

For implementation details, see [WEBRTC_IMPLEMENTATION.md](WEBRTC_IMPLEMENTATION.md)
For quick reference, see [WEBRTC_QUICK_REFERENCE.md](WEBRTC_QUICK_REFERENCE.md)

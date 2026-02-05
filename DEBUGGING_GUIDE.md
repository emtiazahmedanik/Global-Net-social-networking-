# WebRTC State Machine Debugging Guide

## Issue
Receiver is entering "have-local-offer" state when it should only be in "stable" state initially, then "have-local-answer" after receiving and handling the caller's offer.

## Root Cause (To Be Determined)
The receiver is somehow creating a local offer when it shouldn't. This might be caused by:
1. `createPeerConnection()` being called twice
2. An automatic offer creation in flutter_webrtc 
3. Race condition between acceptCall() and another handler
4. The receiver's 'call-active' event being triggered (socket routing issue)

## Expected State Machine

### Caller Flow
```
[stable] → create local tracks → create offer → [have-local-offer] 
→ set local description → send offer → receive answer 
→ set remote description → [stable]
```

### Receiver Flow
```
[stable] → create local tracks → [stable] (wait for offer)
→ receive offer → set remote description → [have-remote-offer]
→ create answer → set local description → [stable]
```

## Enhanced Logging Checkpoints

The code now logs signaling state at these points:

1. **After `createPeerConnection()` in receiver**
   - Should be: `stable`
   - Log: `📊 Signaling state after createPeerConnection: stable`

2. **In webrtc-offer handler (receiver)**
   - Should be: `stable` or at worst `have-remote-offer`
   - Log: `📊 Current peer connection signaling state: <state>`

3. **After calling `createAndSendAnswer()`**
   - Should be: still shows stable (answer is local, not offer)
   - Next state after setting: `stable`

## Test Steps

### Setup
- Device A: Caller (initiates call)
- Device B: Receiver (accepts call)

### Test Case 1: Basic State Verification
1. Device A calls Device B
2. Device B accepts call  
3. **Check logs for Device B:**
   - ✓ "🔍 [RECEIVER] About to create peer connection..."
   - ✓ "📊 Signaling state after createPeerConnection: stable"
   - ✗ If you see "have-local-offer" here, the issue is in createPeerConnection()
4. Device A receives 'call-active' event
5. **Check logs for Device A:**
   - ✓ "📞 Call Accepted: ..."
   - ✓ Offer is created and sent
6. Device B receives webrtc-offer event
7. **Check logs for Device B:**
   - ✓ "📞 Received WebRTC Offer: ..."
   - ? Check: "📊 Current peer connection signaling state: <what is it here?>"
   - If it's "have-local-offer", the issue happened between steps 2-7
   - If it's "stable", the issue might be in answer creation

## Key Log Messages to Watch

### Receiver Logs (Device B)
```
🔍 [RECEIVER] About to create peer connection...
📊 Signaling state after createPeerConnection: stable     ← CRITICAL
🔍 About to create peer connection... (should not repeat)
📞 Received WebRTC Offer: ...
📊 Current peer connection signaling state: ???           ← CHECK THIS
❌ Error handling WebRTC offer: ...
📊 Peer connection signaling state at error: have-local-offer
```

### Caller Logs (Device A)
```
📞 Call Accepted: ...
📊 Local media stream obtained
✅ Local media stream obtained
📤 Adding local stream tracks to peer connection...
✅ Peer connection created successfully
📊 Initial signaling state: stable
📤 Answer created: answer
🎬 Received remote track: video
✅ Remote stream received
```

## Potential Issues & Fixes

### Issue 1: createPeerConnection() called twice
- **Symptom**: "🔍 About to create peer connection..." appears twice in receiver logs
- **Fix**: Guard already added - will now log "⚠️ Peer connection already exists, skipping creation"
- **What to do**: If this appears, check who's calling createPeerConnection() twice

### Issue 2: flutter_webrtc auto-creates offer
- **Symptom**: Signaling state is "have-local-offer" immediately after createPeerConnection()
- **Fix**: Might need to configure peer connection differently (check flutter_webrtc docs)
- **What to do**: If this happens, add configuration to prevent auto-offer creation

### Issue 3: Race condition with handlers
- **Symptom**: Logs show WebRTC events arriving in wrong order
- **Fix**: Add proper state validation in handlers (offer handler should only work in stable state)
- **What to do**: Add state checks before operations

### Issue 4: Socket routing issue
- **Symptom**: Receiver logs show "📞 Call Accepted: ..." (should be caller only)
- **Fix**: Check socket server routing - receiver shouldn't get 'call-active' event
- **What to do**: Verify socket.io server configuration

## Quick Debug Commands

Run these in terminal while app is running:

```dart
// Check if multiple peer connections exist
webRTCService.peerConnection
webRTCService.peerConnection?.signalingState
webRTCService.peerConnection?.connectionState

// Check stream state
webRTCService.localStream.value
webRTCService.remoteStream.value
```

## Next Steps

1. **Run test case 1** and collect logs
2. **Identify which checkpoint** first shows wrong state
3. **Narrow down** which code section caused the issue
4. **Apply targeted fix** based on findings

## Related Files
- `lib/feature/real_time_calling/service/webrtc_service.dart` - Core WebRTC logic
- `lib/feature/real_time_calling/controller/call_controller.dart` - Call orchestration
- `lib/feature/real_time_calling/screen/video_call_screen.dart` - Video UI

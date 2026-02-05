# Quick Test Guide - Black Screen Fix

## 🚀 How to Test the Fix

### Prerequisites
- Two devices (physical or emulator)
- App running on both devices
- Connected to same network/Firebase

### Test Procedure

#### Step 1: Caller Initiates Call
```
Device A: Click "Call" button
Expected: OutgoingCallScreen appears with loading state
Logs: Look for 📞 Call Initiated: ...
```

#### Step 2: Receiver Accepts Call
```
Device B: Click "Accept" button on IncomingCallScreen
Expected: Acceptance animation, then VideoCallScreen appears
Logs: Look for:
  - 📞 Accepting call: ...
  - 📸 Initializing media stream for receiver...
  - 🔍 [RECEIVER] Peer connection created
  - ✅ Local stream set to renderer
```

#### Step 3: Verify Local Video
```
Expected on Device B:
  - Small video in bottom-right corner (PiP)
  - Mirror image of self (flipped)
  - Should NOT be black
  - Should show camera feed immediately or within 2 seconds

Logs: Look for:
  - ✅ Local stream set to renderer
  - 📊 Local stream tracks: 2
  - 📊 Local video track - enabled: true
```

#### Step 4: Verify Caller Sees Everything
```
Device A should transition to VideoCallScreen
Expected:
  - Own video in PiP (bottom-right)
  - Remote video in full screen OR placeholder with caller name
  - Once connection established: remote video appears
  
Logs: Look for:
  - 📞 Sending WebRTC Offer from Caller
  - 🎬 Received remote track: video
  - ✅ Remote stream received
```

#### Step 5: Verify Video Transmission
```
Device A: Speak or make faces
Device B: Should see your face move in real-time

Device B: Speak or make faces  
Device A: Should see their face move in real-time
```

#### Step 6: Test Audio
```
Device A: Speak loudly
Device B: Should hear audio (adjust device volume)

Device B: Speak loudly
Device A: Should hear audio
```

#### Step 7: Test Media Controls

**Camera Toggle:**
```
Device A: Click camera button (🎥)
Expected: 
  - Button changes to 🎥 ❌ (crossed out)
  - Local PiP shows black/placeholder
  - Remote side can't see Device A
  - Click again: video resumes

Logs: Look for: 📹 Video disabled/enabled
```

**Microphone Toggle:**
```
Device A: Click mic button (🎤)
Expected:
  - Button changes to 🔇 (muted)
  - Device B can't hear Device A
  - Click again: audio resumes

Logs: Look for: 🔊 Audio disabled/enabled
```

#### Step 8: End Call
```
Device A: Click red "End Call" button
Expected:
  - Confirmation dialog appears
  - Click "End Call" to confirm
  - Both screens return to previous state
  - Renderers disposed cleanly

Logs: Look for:
  - ✅ WebRTC resources cleaned up
  - No ❌ errors about disposed renderers
```

## ⚠️ Troubleshooting

### Symptom: Still Black Screen
```
Possible Causes:
1. Camera permissions not granted
   Fix: Grant camera & microphone permissions in OS settings

2. Local stream not initializing
   Look for: ❌ Error getting user media
   Fix: Check camera/mic are not in use by other app

3. Renderers not binding
   Look for: ❌ Error setting local stream
   Fix: Check RTCVideoRenderer initialization logs

4. Peer connection creation failed
   Look for: ❌ Error creating peer connection
   Fix: Check STUN server connectivity
```

### Symptom: No Audio
```
Possible Causes:
1. Microphone permissions not granted
2. Audio disabled at OS level
3. Audio tracks not enabled
   Check: 📊 Audio track - enabled: false

Fix:
- Grant microphone permission
- Check system audio settings
- Check audio tracks in logs
```

### Symptom: Can See Self But Not Remote
```
Possible Causes:
1. Remote stream not received
   Look for: Missing ✅ Remote stream received
   
2. Remote tracks not enabled
   Check: 📊 Remote track enabled: false
   
3. Signaling error
   Look for: ❌ Error handling WebRTC offer/answer

Fix:
- Check socket connection (look for 📡 ICE Connection State)
- Verify both sides completed SDP exchange
- Check ICE candidates are being sent/received
```

### Symptom: Crashes on Call End
```
Look for: ❌ Error disposing renderers

Possible Causes:
1. Renderer disposal before renderer null check
2. Multiple disposal attempts

The fix should handle this, but if still occurs:
- Check isDisposed flag is working
- Verify _disposeRenderers() is not called twice
```

## 📊 Key Log Markers

### ✅ Good Signs
```
✅ Local media stream obtained
✅ Local renderer initialized
✅ Remote renderer initialized
✅ Peer connection created successfully
✅ Local stream set to renderer
✅ Remote stream received
✅ Remote stream set to renderer
📡 Connection State: connected
```

### ❌ Bad Signs
```
❌ Error getting user media
❌ Error creating peer connection
❌ Error initializing renderers
❌ Error setting local stream
❌ Error handling WebRTC offer
❌ Error setting remote description
⚠️ Local stream is null
⚠️ Peer connection already exists (shouldn't repeat)
```

## 🎯 Final Verification Checklist

- [ ] Local video shows in PiP (not black)
- [ ] Remote video appears when connected
- [ ] Both can see each other clearly
- [ ] Audio is transmitted both ways
- [ ] Camera toggle works
- [ ] Microphone toggle works
- [ ] Can end call without crashes
- [ ] No ❌ errors in console

If all checks pass: ✅ **Fix is working!**

---

**Remember**: Check the console logs while testing - they tell you exactly what's happening at each step!

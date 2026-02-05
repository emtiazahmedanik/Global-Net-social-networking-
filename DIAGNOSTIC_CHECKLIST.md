# Quick Diagnostic Checklist - ICE Connection Failure

## 🔍 Step-by-Step Diagnosis

### Step 1: Check Internet Connectivity
```
✓ Both devices have internet connection
✓ Both can access websites normally
✓ Both are on network with reasonable speed (> 1 Mbps)
```

### Step 2: Monitor Logs During Call Setup

**Receiver (Device B):**
```
Watch for these logs when accepting call:

1. 📸 Initializing media stream for receiver...
2. ✅ Local media stream obtained
3. 🔍 [RECEIVER] Peer connection created
4. 📤 Adding local stream tracks to peer connection...
5. ✅ Successfully added track: video
6. ✅ Successfully added track: audio
7. 🔍 Gathering ICE candidates from STUN/TURN servers...
8. ✅ ICE candidate gathering complete
9. 📞 Received WebRTC Offer
10. 📤 Answer created: answer

✓ If all above appear, receiver is ready
✗ If any fails, note which one and check Step 3
```

**Caller (Device A):**
```
Watch for these logs when call is accepted:

1. 📸 Re-initializing media stream...
2. ✅ Local media stream obtained
3. 🔧 Creating peer connection...
4. ✅ Peer connection created successfully
5. 📤 Adding local stream tracks to peer connection...
6. ✅ Successfully added track: video
7. ✅ Successfully added track: audio
8. 🔍 Gathering ICE candidates from STUN/TURN servers...
9. ✅ ICE candidate gathering complete
10. 📤 Offer created: offer
11. 📞 Sending WebRTC Offer from Caller

✓ If all above appear, caller is ready
✗ If any fails, note which one and check Step 3
```

### Step 3: Check Connection Establishment

**Critical Moment - ICE Connection:**
```
Watch for:
🧊 ICE Connection State Changed: connected
✅ ICE Connection Established

OR

🧊 ICE Connection State Changed: failed
❌ ICE Connection Failed
   Possible causes:
   1. STUN server unreachable
   2. Firewall blocking WebRTC ports
   3. NAT traversal issues
   4. Both peers behind restrictive NAT without TURN
```

### Step 4: Decode the Failure

#### If "failed" appears, check which type:

**Type A: STUN Server Issue**
```
Symptoms:
- ✅ ICE candidate gathering complete appears QUICKLY (< 2 seconds)
- 🧊 ICE Connection State: failed appears immediately after
- No 🧊 ICE Connection State: connecting in between

Cause: All 9 STUN servers unreachable

Solutions:
□ Check internet connection on BOTH devices
□ Check if VPN is enabled (disable it)
□ Try on different network (switch WiFi)
□ Wait 30 seconds and retry (rate limiting?)
□ Check firewall rules
```

**Type B: Firewall/NAT Issue**
```
Symptoms:
- ✅ ICE candidate gathering complete appears
- 🧊 ICE Connection State: connecting appears
- Then 🧊 ICE Connection State: failed after 10-20 seconds

Cause: STUN succeeded but P2P connection blocked

Solutions:
□ Network firewall is blocking UDP ports
□ Restrictive NAT that STUN can't traverse
□ Port filtering on corporate/mobile network

Action: Add TURN server configuration (see ICE_CONNECTION_FAILURE_FIX.md)
```

**Type C: Signaling Issue**
```
Symptoms:
- ICE states look fine
- But no remote track appears
- Or 📊 Remote Tracks: Video=0, Audio=0

Cause: SDP offer/answer not reaching other peer

Solutions:
□ Check Socket.io connection status
□ Verify both emit and listen for WebRTC messages
□ Check 📞 Sending WebRTC Offer log
□ Check 📞 Received WebRTC Offer log appears on other side
```

### Step 5: Check Media Streams

**When connected, verify tracks:**
```
Look for:
📊 === Connection Diagnostics ===
📊 Signaling State: stable
📊 Connection State: connected
📊 ICE Connection State: connected
📊 ICE Gathering State: complete
📊 Local Tracks: Video=1, Audio=1
   📹 Video: enabled=true, label=Front Camera
   🎤 Audio: enabled=true, label=Built-in Microphone
📊 Remote Tracks: Video=1, Audio=1
   📹 Video: enabled=true
   🎤 Audio: enabled=true
📊 ================================

✓ All above = Working properly
✗ Any zeros or false = Potential issue
```

## 🎯 Quick Decision Tree

```
Start Call
│
├─ Accept Call
│  │
│  ├─ See logs 1-8 (connection setup)?
│  │  ├─ YES → Continue to ICE connection check
│  │  └─ NO → Fix that specific step first
│  │
│  └─ See 🧊 ICE Connection State: connected?
│     ├─ YES → Working! Check media streams
│     └─ NO → See "Type A/B/C" diagnosis above
│
├─ See ✅ Remote stream received?
│  ├─ YES → Video should display
│  └─ NO → Check ICE connection status
│
└─ See video on screen?
   ├─ YES → ✅ SUCCESS!
   └─ NO → See "Type C" diagnosis above
```

## 🔧 If Type B (Firewall/NAT) Detected

**Immediate Action:**
```
1. Try mobile hotspot instead of WiFi
   (Different network = Different NAT/firewall)

2. Try WiFi instead of mobile hotspot
   (Different network = Different firewall)

3. If neither works, add TURN server:
   - See ICE_CONNECTION_FAILURE_FIX.md
   - Section: "Add TURN Server Support (Optional)"
```

## 📝 Example Log Captures

### ✅ Successful Capture
```
I/flutter: 📸 Initializing media stream for receiver...
I/flutter: ✅ Local media stream obtained
I/flutter: 📊 Local stream ID: abcdef123456
I/flutter: 📊 Video tracks: 1
I/flutter: 📊 Audio tracks: 1
I/flutter: 🔍 [RECEIVER] About to create peer connection...
I/flutter: 🔍 [RECEIVER] Peer connection created
I/flutter: 📤 Adding local stream tracks to peer connection...
I/flutter: ✅ Successfully added track: video
I/flutter: ✅ Successfully added track: audio
I/flutter: 🔍 Gathering ICE candidates from STUN/TURN servers...
I/flutter: ✅ ICE candidate gathering complete
I/flutter: 📞 Received WebRTC Offer: {...}
I/flutter: 📤 Answer created: answer
I/flutter: 📞 Sending WebRTC Answer from Receiver
I/flutter: 🎬 Received remote track: video
I/flutter: ✅ Remote stream received
I/flutter: 🧊 ICE Connection State Changed: connected
I/flutter: ✅ ICE Connection Established
I/flutter: 📡 Connection State Changed: connected
```

### ❌ Type A Failure Capture
```
I/flutter: 📸 Initializing media stream for receiver...
I/flutter: ✅ Local media stream obtained
I/flutter: 🔍 [RECEIVER] Peer connection created
I/flutter: ✅ Successfully added track: video
I/flutter: ✅ Successfully added track: audio
I/flutter: 🔍 Gathering ICE candidates from STUN/TURN servers...
I/flutter: ✅ ICE candidate gathering complete
I/flutter: 🧊 ICE Connection State Changed: failed
I/flutter: ❌ ICE Connection Failed - Connection cannot be established
I/flutter:    Possible causes:
I/flutter:    1. STUN server unreachable
I/flutter:    2. Firewall blocking WebRTC ports
I/flutter:    3. NAT traversal issues
I/flutter:    4. Both peers behind restrictive NAT without TURN

DIAGNOSIS: Type A - STUN Server Issue
ACTION: Check internet, disable VPN, try different network
```

### ❌ Type B Failure Capture
```
I/flutter: ✅ Local media stream obtained
I/flutter: ✅ Successfully added track: video
I/flutter: ✅ Successfully added track: audio
I/flutter: 🔍 Gathering ICE candidates from STUN/TURN servers...
I/flutter: ✅ ICE candidate gathering complete
I/flutter: 🧊 ICE Connection State Changed: connecting
I/flutter: [... wait 15-20 seconds ...]
I/flutter: 🧊 ICE Connection State Changed: failed
I/flutter: ❌ ICE Connection Failed

DIAGNOSIS: Type B - Firewall/NAT Issue
ACTION: Try different network, add TURN server
```

## 📋 Report Template

If you need to report an issue, capture:

```
Device: [A/B]
Network: [WiFi/Mobile/Hotspot]
Devices: [Both physical, both emulator, or mixed]
OS: [Android/iOS]

Last successful log line:
[Copy last ✅ or ⚠️ log]

First failure log line:
[Copy first ❌ log]

Full logs:
[Paste all logs from call setup to failure]
```

---

**Remember**: The detailed logs now show exactly what's happening at each step!

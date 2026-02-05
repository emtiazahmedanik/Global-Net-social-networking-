# WebRTC Socket ID Fix - Backend Requirements

## Problem
The system is extracting the opponent's **User ID** (`c1d110d3-...`) but using it as the **Socket ID** for WebRTC signaling. These are different:

- **User ID**: Backend identifier (UUID format like `c1d110d3-63b3-4cec-9783-b4a718c747f4`)
- **Socket ID**: Socket.IO session ID (alphanumeric like `GApAFSfmgXfjlNQIAAB3`)

The WebRTC signaling events expect `targetSocketId`, which must be the actual **Socket.IO session ID**, not the User ID.

## Current Event Flow

### 1. Call Initiation (Caller → Backend)
```
Client emits: callUser
{
  userId: "c1d110d3-..." // Recipient's user ID
}
```

### 2. Incoming Call (Backend → Recipient)
```
Client receives: incomingCall
{
  callId: "b02c1421-...",
  caller: {
    id: "...",
    userId: "...",
    name: "...",
    avatarUrl: "..."
  }
}
```

### 3. Accept Call (Recipient → Backend) ⚠️ **NEEDS FIX**
```
Client emits: acceptCall
{
  callId: "b02c1421-...",
  recipientSocketId: "socket.io_session_id"  // ADD THIS!
}
```

**Backend should route this back to the caller**

### 4. Call Accepted (Backend → Caller) ⚠️ **NEEDS UPDATE**
```
Client receives: callAccepted
{
  callId: "b02c1421-...",
  acceptedBy: "c1d110d3-...",  // Opponent's User ID (for reference)
  recipientSocketId: "GApAFSfmgXfjlNQIAAB3"  // ADD THIS! (Opponent's actual Socket ID)
}
```

**With this, the caller has the correct Socket ID for WebRTC signaling**

### 5. WebRTC Signaling (Both → Backend)
```
Client emits: offer
{
  targetSocketId: "GApAFSfmgXfjlNQIAAB3",  // Must be Socket.IO session ID!
  signal: {
    type: "offer",
    sdp: "v=0\r\n..."
  }
}

Client emits: answer
{
  targetSocketId: "callerSocketId",  // Caller's Socket.IO session ID
  signal: {
    type: "answer",
    sdp: "v=0\r\n..."
  }
}

Client emits: iceCandidate
{
  targetSocketId: "opponentSocketId",
  candidate: {
    candidate: "candidate:...",
    sdpMid: "0",
    sdpMLineIndex: 0
  }
}
```

## Backend Changes Required

### 1. When emitting `acceptCall` from recipient to backend:
```javascript
socket.emit('acceptCall', {
  callId: callId,
  recipientSocketId: socket.id  // Include this!
});
```

### 2. When sending `callAccepted` from backend to caller:
```javascript
socket.to(callerSocketId).emit('callAccepted', {
  callId: callId,
  acceptedBy: recipientUserId,  // User ID for reference
  recipientSocketId: recipientSocketIOSessionId  // ADD THIS!
});
```

### 3. For `offer`, `answer`, `iceCandidate` events:
Ensure these are routed using the `targetSocketId` value to send to the correct Socket.IO session.

## Frontend Logging Output (After Fix)
```
═════════════════════════════════════
>>> CALL ACCEPTED EVENT
═════════════════════════════════════
Raw callAccepted data: {callId: b02c1421-..., acceptedBy: c1d110d3-..., recipientSocketId: GApAFSfmgXfjlNQIAAB3}
Data keys: [callId, acceptedBy, recipientSocketId]
Call ID: b02c1421-...
Accepted By (Opponent User ID): c1d110d3-...
Extracted Opponent User ID: c1d110d3-...
Extracted Opponent Socket ID (for WebRTC): GApAFSfmgXfjlNQIAAB3  ✓
═════════════════════════════════════
```

## Key Concepts
- **User ID** (UUID): Used for routing calls in backend logic
- **Socket ID** (Socket.IO session ID): Used for P2P WebRTC signaling via `targetSocketId`
- **callId**: Unique call identifier for matching accept/reject responses

## Testing Checklist
- [ ] Backend sends `recipientSocketId` in `callAccepted` event
- [ ] Recipient includes `recipientSocketId` when emitting `acceptCall`
- [ ] Caller receives correct Socket ID and initiates offer with it
- [ ] Debug logs show alphanumeric Socket ID (not UUID) in WebRTC signaling
- [ ] `offer`/`answer`/`iceCandidate` events use correct `targetSocketId`
- [ ] Video stream receives on both sides

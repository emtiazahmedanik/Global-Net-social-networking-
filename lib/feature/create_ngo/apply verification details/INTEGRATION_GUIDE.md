# Apply Verification Details - API Integration Guide

## Overview
এই screen টি এখন সম্পূর্ণ API integrated, যা dynamically organization data fetch করে এবং display করে।

## Key Changes

### 1. **ApplyVerificationController** (`controller/apply_verification_controller.dart`)
- **New Properties:**
  - `isLoading`: Loading state track করে
  - `error`: Error messages hold করে
  
- **New Methods:**
  - `_fetchOrgById()`: API থেকে organization data fetch করে

- **Data Getters:**
  - `name`, `avatarUrl`, `bio`, `location`, `mission`, `typeDisplay`, `foundingDateFormatted`

### 2. **ApplyVerificationDetailsHeader** Widget
- এখন **dynamic avatar** দেখায় API থেকে fetched data থেকে
- **Organization name** এবং **type** dynamically update হয়
- Network image load করে এবং fallback asset image ব্যবহার করে যদি fail হয়

### 3. **ApplyVerificationProfileDetails** Widget
- **Mission** বা **bio** dynamically display করে
- Loading state এ কিছু show করে না
- Error state handle করে gracefully

### 4. **ApplyVerificationDetailsScreen**
- Loading indicator দেখায় যখন data fetch হচ্ছে
- Error state display করে proper error message সহ
- `Obx()` দিয়ে reactive updates ensure করে

## How to Navigate to This Screen

### Option 1: With Organization Model (Fastest)
```dart
// From CreateNgoVerifyProfileScreen or any other screen
Get.to(
  () => ApplyVerificationDetailsScreen(),
  arguments: {
    'isNgo': true, // or false for community
    'org': organizationModel, // OrganizationModel instance
  },
);
```

### Option 2: With Organization ID (Fetch from API)
```dart
Get.to(
  () => ApplyVerificationDetailsScreen(),
  arguments: {
    'isNgo': true,
    'orgId': 'some-org-id', // Controller will fetch this from API
  },
);
```

### Option 3: Without Arguments (Just navigate)
```dart
Get.to(() => ApplyVerificationDetailsScreen());
```

## API Endpoints Used
- **For NGO:** `GET /ngos/{id}`
- **For Community:** `GET /communities/{id}`

## State Management Flow

```
Screen Load
    ↓
Controller Init
    ↓
Check Arguments
    ├─ org provided → Use directly
    ├─ orgId provided → Fetch from API
    └─ Neither → Show error or wait for manual setup
    ↓
Set isLoading = true
    ↓
Make API Call (if needed)
    ↓
Parse Response & Update org.value
    ↓
Set isLoading = false
    ↓
UI Updates via Obx() reactive binding
```

## Error Handling

### Types of Errors Handled:
1. **Network Errors:** Try-catch block
2. **Invalid Response:** Check `responseBody['success']`
3. **Empty Data:** Fallback text displayed
4. **No Organization:** Error message shown to user

## UI Changes
✅ **No UI changes** - সবকিছু intact থাকবে
✅ **Dynamic Content** - Real data থেকে populated হবে
✅ **Loading State** - Smooth loading indicator
✅ **Error Handling** - User-friendly error messages

## Example Response Structure

```json
{
  "success": true,
  "data": {
    "id": "org-123",
    "ownerId": "user-456",
    "foundationDate": "2023-01-15T00:00:00Z",
    "ngoType": "PUBLIC",
    "profile": {
      "name": "Help Foundation",
      "bio": "We help people",
      "avatarUrl": "https://...",
      "coverUrl": "https://...",
      "location": "Dhaka, Bangladesh"
    },
    "about": {
      "location": "Dhaka",
      "foundingDate": "2023-01-15T00:00:00Z",
      "mission": "To provide quality help"
    }
  }
}
```

## Testing Checklist

- [ ] Navigate with `org` argument - data should display immediately
- [ ] Navigate with `orgId` argument - data should fetch and display
- [ ] Navigate without arguments - should handle gracefully
- [ ] Test network error - should show error message
- [ ] Test avatar loading - should show network image or fallback
- [ ] Test loading state - should show spinner
- [ ] Check Next button - should navigate to identity verification

## File Structure

```
apply verification details/
├── controller/
│   └── apply_verification_controller.dart (✅ Updated)
├── screen/
│   └── apply_verification_details_screen.dart (✅ Updated)
├── widgets/
│   ├── apply_verification_details_header.dart (✅ Updated)
│   └── apply_verification_profile_details.dart (✅ Updated)
└── INTEGRATION_GUIDE.md (This file)
```

## Performance Optimization

- Data fetching শুধুমাত্র যদি প্রয়োজন হয় (orgId provided হলে)
- Caching handled by GetX reactive bindings
- Network calls optimized with proper error handling

## Known Limitations

1. No offline caching - data always fetched fresh if orgId provided
2. No pagination needed - single organization fetch
3. Avatar fallback to asset image - could be enhanced with placeholder

## Future Enhancements

- [ ] Add refresh button to reload data
- [ ] Add caching mechanism
- [ ] Better placeholder images
- [ ] Implement retry logic for failed requests

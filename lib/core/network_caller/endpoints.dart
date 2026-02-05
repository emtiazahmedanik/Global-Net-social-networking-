class Urls {
  static String baseUrl = 'http://13.204.75.28:5056';
  static String socketUrl = 'http://13.204.75.28:5056/chat';
  static String callSocketUrl = 'http://13.204.75.28:5056/realtime-call';

  // Auth Endpoints
  static String login = '$baseUrl/auth/login';
  static String signup = '$baseUrl/users/register';
  static String resendOTP = '$baseUrl/users/resent-otp';
  static String verifyOTP = '$baseUrl/users/verify-account';
  static String verifyToken = '$baseUrl/auth/verify-token';
  static String forgotPassword = '$baseUrl/auth/forget-password';
  static String resetPassword = '$baseUrl/auth/reset-password';
  static String changePassword = '$baseUrl/auth/change-password';
  static String logout = '$baseUrl/auth/logout';

  // Choices Endpoints
  static String postChoices = '$baseUrl/choices';
  static String getChoices = '$baseUrl/choices/user-choices';
  static String getProfileInfo = '$baseUrl/user-profile';
  static String getUserProfile = '$baseUrl/user-profile';
  static String awsFileUpload = '$baseUrl/aws-uploads';
  static String updateProfile = '$baseUrl/user-profile';
  static String createNgo = '$baseUrl/ngos';
  static String createCommunity = '$baseUrl/communities';
  static String aboutUs = '$baseUrl/about-us';
  static String privacyPolicy = '$baseUrl/privacy-policy';
  static String termConditions = '$baseUrl/terms-and-conditions';
  static String getProductCategory = '$baseUrl/product-category';
  static String postSettings = '$baseUrl/settings';
  static String marketplaceProducts = '$baseUrl/products';
  static String placeOrder = "$baseUrl/orders";

  static String getSingleProductDetail({required String id}) =>
      '$baseUrl/products/$id';
  static String getFilteredProduct({required String query}) =>
      '$baseUrl/products?search=$query';
  static String getFiltedCategoryProduct({required String cName}) =>
      '$baseUrl/products?categoryName=$cName';

  static String createPost = '$baseUrl/posts';
  static String feedPost = '$baseUrl/posts';
  static String likes = '$baseUrl/likes';
  static String getComment(String id) => '$baseUrl/comments/$id';
  static String sharePost = '$baseUrl/shares';
  static String commentOnPost = '$baseUrl/comments';
  static String userMetrics = '$baseUrl/user-metrics';
  static String allTrendings = '$baseUrl/explore/trending';
  static String allTrendingsCommunity = '$baseUrl/explore/communities';
  static String allTrendingsNgos = '$baseUrl/explore/ngos';
  
  // All Communities and NGOs (for explore screen)
  static String getAllCommunities = '$baseUrl/communities';
  static String getAllNgos = '$baseUrl/ngos';
  static String followCommunity(String communityId) => '$baseUrl/communities/$communityId/follow';
  static String unfollowCommunity(String communityId) => '$baseUrl/communities/$communityId/unFollow';
  static String followNgo(String ngoId) => '$baseUrl/ngos/$ngoId/follow';
  static String unfollowNgo(String ngoId) => '$baseUrl/ngos/$ngoId/unfollow';
  static String hideProduct(String id) => '$baseUrl/hide/$id/toggle';
  static String saveProductToFavorite(String id) =>
      '$baseUrl/favouritelists/$id';

  // Friend Request
  static String sentFriendRequest = '$baseUrl/friend-request';
  static String getPendingFriendRequests = '$baseUrl/friend-request/pending';

  /// PATCH (ACCEPT | REJECT)
  static String updateFriendRequest = '$baseUrl/friend-request';

  /// Correct Friends List Endpoint
  static String getAllFriends = '$baseUrl/friend-request/friends';

  // Community / NGO
  static String myCommunity = "$baseUrl/communities/myCommunity";
  static String myNgo = "$baseUrl/ngos/myNgo";
  static String updateCommunity = "$baseUrl/communities/{id}";
  static String updateNgo = "$baseUrl/ngos/{id}";
  static String deleteCommunity = '$baseUrl/communities/{id}';
  static String deleteNgo = '$baseUrl/ngos/{id}';

  static String follows = '$baseUrl/follows';
  static String withdrawRequestTest = '$baseUrl/withdraw/request-test';
  static String getChatWithUser(String chatId) => '$baseUrl/chat/$chatId';
  static String getMychatPaticipent = '$baseUrl/chat/my';
  static String savePost = '$baseUrl/post-featured/save';
  static String hidePost(String postId) =>
      '$baseUrl/post-featured/toggle-hide/$postId';

  static String submitReport = '$baseUrl/reports';
  static String notificationSocketUrl = '$baseUrl/js/notification';
  static String createStripeAccount = '$baseUrl/stripe/create-account';
  static String getStripeAccount = '$baseUrl/stripe/account';
  static String stripeWebhook = '$baseUrl/stripe/webhook';
  static String getChatIdWithUser(String userId) =>
      '$baseUrl/chat/chat/$userId';

  static String getAllMessageWithUser(String chatId) =>
      '$baseUrl/chat/$chatId/messages';

  // Donation
  static String donationNgo = '$baseUrl/donation/ngo';
  
  // NGO Verification
  static String applyNgoVerification(String ngoId) => '$baseUrl/ngo-verifications/$ngoId/apply';
}

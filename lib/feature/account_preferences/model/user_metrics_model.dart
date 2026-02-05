class UserMetricsModel {
  String? id;
  String? userId;
  int? totalPosts;
  int? totalComments;
  int? totalLikes;
  int? totalShares;
  int? totalFollowers;
  int? totalFollowing;
  int? totalEarnings;
  int? currentMonthEarnings;
  int? volunteerHours;
  int? completedProjects;
  int? activityScore;
  String? lastUpdated;
  String? createdAt;
  String? updatedAt;

  UserMetricsModel(
      {this.id,
      this.userId,
      this.totalPosts,
      this.totalComments,
      this.totalLikes,
      this.totalShares,
      this.totalFollowers,
      this.totalFollowing,
      this.totalEarnings,
      this.currentMonthEarnings,
      this.volunteerHours,
      this.completedProjects,
      this.activityScore,
      this.lastUpdated,
      this.createdAt,
      this.updatedAt});

  UserMetricsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    totalPosts = json['totalPosts'];
    totalComments = json['totalComments'];
    totalLikes = json['totalLikes'];
    totalShares = json['totalShares'];
    totalFollowers = json['totalFollowers'];
    totalFollowing = json['totalFollowing'];
    totalEarnings = json['totalEarnings'];
    currentMonthEarnings = json['currentMonthEarnings'];
    volunteerHours = json['volunteerHours'];
    completedProjects = json['completedProjects'];
    activityScore = json['activityScore'];
    lastUpdated = json['lastUpdated'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }


}
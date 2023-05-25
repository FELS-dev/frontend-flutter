class UserTreasureHuntProgress {
  final int progressId;
  final int? visitorId;
  final int? huntId;
  final int? choiceId;
  final bool? isCompleted;

  UserTreasureHuntProgress({required this.progressId, this.visitorId, this.huntId, this.choiceId, this.isCompleted});

  factory UserTreasureHuntProgress.fromJson(Map<String, dynamic> json) {
    return UserTreasureHuntProgress(
      progressId: json['progress_id'],
      visitorId: json['visitor_id'],
      huntId: json['hunt_id'],
      choiceId: json['choice_id'],
      isCompleted: json['is_completed'],
    );
  }
}
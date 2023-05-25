class Choice {
  int id;
  int huntId;
  String choice;
  bool isCorrect;

  Choice({required this.id, required this.huntId, required this.choice, required this.isCorrect});

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'],
      huntId: json['hunt_id'],
      choice: json['choice'],
      isCorrect: json['is_correct'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hunt_id': huntId,
      'choice': choice,
      'is_correct': isCorrect ? 1 : 0,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hunt_id': huntId,
      'choice': choice,
      'is_correct': isCorrect,
    };
  }
}
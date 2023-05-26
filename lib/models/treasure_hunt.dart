import 'dart:convert';
import './choice.dart';

class TreasureHunt {
  int id;
  int standId;
  String question;

  TreasureHunt({required this.id, required this.standId, required this.question});

  factory TreasureHunt.fromJson(Map<String, dynamic> json) {
    return TreasureHunt(
      id: json['id'],
      standId: json['stand_id'],
      question: json['question'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stand_id': standId,
      'question': question,
    };
  }

}
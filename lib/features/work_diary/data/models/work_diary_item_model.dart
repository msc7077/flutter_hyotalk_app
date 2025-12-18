import 'package:equatable/equatable.dart';

class WorkDiaryItemModel extends Equatable {
  final String id;
  final String title;
  final String summary;
  final DateTime date;
  final String authorName;

  const WorkDiaryItemModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.date,
    required this.authorName,
  });

  factory WorkDiaryItemModel.fromJson(Map<String, dynamic> json) {
    return WorkDiaryItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      date: DateTime.parse(json['date'] as String),
      authorName: json['author_name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
        'date': date.toIso8601String(),
        'author_name': authorName,
      };

  @override
  List<Object?> get props => [id, title, summary, date, authorName];
}



class Flashcard {
  String id;
  String question;
  String answer;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'question': question,
        'answer': answer,
      };

  factory Flashcard.fromMap(Map<String, dynamic> map) => Flashcard(
        id: map['id'],
        question: map['question'],
        answer: map['answer'],
      );
}

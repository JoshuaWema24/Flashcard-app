import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard.dart';

class FlashcardService {
  static const _key = 'flashcards';

  Future<List<Flashcard>> loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key);
    if (raw == null) return _defaults();
    return raw
        .map((e) => Flashcard.fromMap(jsonDecode(e)))
        .toList();
  }

  Future<void> saveCards(List<Flashcard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      cards.map((c) => jsonEncode(c.toMap())).toList(),
    );
  }

  List<Flashcard> _defaults() => [
        Flashcard(
          id: '1',
          question: 'What is the powerhouse of the cell?',
          answer: 'The mitochondria',
        ),
        Flashcard(
          id: '2',
          question: 'What is the chemical symbol for water?',
          answer: 'H₂O',
        ),
        Flashcard(
          id: '3',
          question: 'What planet is closest to the Sun?',
          answer: 'Mercury',
        ),
        Flashcard(
          id: '4',
          question: 'Who wrote Romeo and Juliet?',
          answer: 'William Shakespeare',
        ),
        Flashcard(
          id: '5',
          question: 'What is 12 × 12?',
          answer: '144',
        ),
      ];
}

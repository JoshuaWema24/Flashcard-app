import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../services/flashcard_service.dart';
import '../widgets/flashcard_widget.dart';
import 'manage_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlashcardService _service = FlashcardService();
  List<Flashcard> _cards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await _service.loadCards();
    setState(() {
      _cards = cards;
      _currentIndex = 0;
      _showAnswer = false;
    });
  }

  void _next() {
    if (_cards.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _cards.length;
      _showAnswer = false;
    });
  }

  void _prev() {
    if (_cards.isEmpty) return;
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _cards.length) % _cards.length;
      _showAnswer = false;
    });
  }

  void _toggleAnswer() {
    setState(() => _showAnswer = !_showAnswer);
  }

  Future<void> _goToManage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ManageScreen()),
    );
    _loadCards();
  }

  @override
  Widget build(BuildContext context) {
    final hasCards = _cards.isNotEmpty;
    final card = hasCards ? _cards[_currentIndex] : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD600),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '⚡ Flashcard Quiz',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: 0.4,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded),
            tooltip: 'Manage Cards',
            onPressed: _goToManage,
          ),
        ],
      ),
      body: hasCards
          ? Column(
              children: [
                _buildProgressBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: FlashcardWidget(
                      card: card!,
                      showAnswer: _showAnswer,
                      onToggle: _toggleAnswer,
                    ),
                  ),
                ),
                _buildNavButtons(),
                const SizedBox(height: 28),
              ],
            )
          : _buildEmptyState(),
    );
  }

  Widget _buildProgressBar() {
    final progress =
        _cards.isEmpty ? 0.0 : (_currentIndex + 1) / _cards.length;
    return Container(
      color: const Color(0xFFFFD600),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card ${_currentIndex + 1} of ${_cards.length}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.black12,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF00C853)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _prev,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Color(0xFFBDBDBD)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _next,
              icon: const Text('Next'),
              label: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.layers_outlined,
                size: 72, color: Color(0xFFBDBDBD)),
            const SizedBox(height: 16),
            const Text(
              'No flashcards yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add some cards to start studying',
              style: TextStyle(fontSize: 14, color: Colors.black38),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _goToManage,
              icon: const Icon(Icons.add),
              label: const Text('Add Cards'),
            ),
          ],
        ),
      ),
    );
  }
}

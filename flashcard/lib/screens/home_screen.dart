// screens/home_screen.dart
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
  List<Flashcard> _cards = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  final FlashcardService _service = FlashcardService();
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    try {
      final cards = await _service.loadCards();
      if (!mounted) return;
      setState(() {
        _cards = cards;
        _currentIndex = 0;
        _showAnswer = false;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load flashcards.')),
      );
    }
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
      _currentIndex = (_currentIndex - 1 + _cards.length) % _cards.length;
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
    if (mounted) {
      _loadCards();
    }
  }

  Widget _buildProgressBar() {
    final progress = _cards.isEmpty ? 0.0 : (_currentIndex + 1) / _cards.length;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFD600),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress Overview',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              Text(
                '${_currentIndex + 1} / ${_cards.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.black.withOpacity(0.08),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF00C853)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _prev,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _next,
              icon: const Text('Next'),
              label: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: const Color(0xFF00C853).withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15),
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD600).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.layers_clear_rounded,
                  size: 48,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No Flashcards Yet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add cards to your collection to begin the study session.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black45, height: 1.4),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _goToManage,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create Cards'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasCards = _cards.isNotEmpty;
    final card = hasCards ? _cards[_currentIndex] : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.edit_note_rounded, size: 26),
              tooltip: 'Manage Cards',
              onPressed: _goToManage,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasCards
              ? Stack(
                  children: [
                    // Glassmorphic background visual decor elements
                    Positioned(
                      top: 40,
                      left: -20,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD600).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 120,
                      right: -30,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C853).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Main Body Structure
                    Column(
                      children: [
                        _buildProgressBar(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            child: FlashcardWidget(
                              card: card!,
                              showAnswer: _showAnswer,
                              onToggle: _toggleAnswer,
                            ),
                          ),
                        ),
                        _buildNavButtons(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ],
                )
              : _buildEmptyState(),
    );
  }
}
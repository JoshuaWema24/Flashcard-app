import 'dart:math';
import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard card;
  final bool showAnswer;
  final VoidCallback onToggle;

  const FlashcardWidget({
    super.key,
    required this.card,
    required this.showAnswer,
    required this.onToggle,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset flip on card change
    if (oldWidget.card.id != widget.card.id) {
      _controller.reset();
      _isFront = true;
    }

    if (widget.showAnswer != oldWidget.showAnswer) {
      if (widget.showAnswer) {
        _controller.forward();
        Future.delayed(const Duration(milliseconds: 210),
            () => setState(() => _isFront = false));
      } else {
        _controller.reverse();
        Future.delayed(const Duration(milliseconds: 210),
            () => setState(() => _isFront = true));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: widget.onToggle,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (_, __) {
                final angle = _animation.value;
                final isShowingFront = angle < pi / 2;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  child: isShowingFront
                      ? _buildFace(isFront: true)
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(pi),
                          child: _buildFace(isFront: false),
                        ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildToggleButton(),
      ],
    );
  }

  Widget _buildFace({required bool isFront}) {
    final isQuestion = isFront;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isQuestion
            ? const Color(0xFFFFD600)
            : const Color(0xFF00C853),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isQuestion
                    ? const Color(0xFFFFD600)
                    : const Color(0xFF00C853))
                .withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isQuestion ? 'QUESTION' : 'ANSWER',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.6,
                color: isQuestion ? Colors.black54 : Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            isQuestion ? widget.card.question : widget.card.answer,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.45,
              color: isQuestion ? Colors.black87 : Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Icon(
            isQuestion
                ? Icons.touch_app_outlined
                : Icons.check_circle_outline_rounded,
            size: 28,
            color: isQuestion
                ? Colors.black26
                : Colors.white.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton() {
    final showing = widget.showAnswer;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.onToggle,
        icon: Icon(showing
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined),
        label: Text(showing ? 'Hide Answer' : 'Show Answer'),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              showing ? Colors.black87 : const Color(0xFF00C853),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
    );
  }
}

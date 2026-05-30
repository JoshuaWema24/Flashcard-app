import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class CardFormScreen extends StatefulWidget {
  final Flashcard? card;
  const CardFormScreen({super.key, this.card});

  @override
  State<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends State<CardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionCtrl;
  late TextEditingController _answerCtrl;

  bool get _isEditing => widget.card != null;

  @override
  void initState() {
    super.initState();
    _questionCtrl =
        TextEditingController(text: widget.card?.question ?? '');
    _answerCtrl =
        TextEditingController(text: widget.card?.answer ?? '');
  }

  @override
  void dispose() {
    _questionCtrl.dispose();
    _answerCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final result = Flashcard(
      id: widget.card?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      question: _questionCtrl.text.trim(),
      answer: _answerCtrl.text.trim(),
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD600),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _isEditing ? 'Edit Card' : 'New Card',
          style: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('Question', Icons.help_outline_rounded),
              const SizedBox(height: 8),
              TextFormField(
                controller: _questionCtrl,
                maxLines: 4,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Type your question here...',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Question cannot be empty'
                    : null,
              ),
              const SizedBox(height: 24),
              _buildSectionLabel('Answer', Icons.lightbulb_outline_rounded),
              const SizedBox(height: 8),
              TextFormField(
                controller: _answerCtrl,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Type the answer here...',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Answer cannot be empty'
                    : null,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: Icon(
                      _isEditing ? Icons.check_rounded : Icons.add_rounded),
                  label:
                      Text(_isEditing ? 'Save Changes' : 'Add Card'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF00C853)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

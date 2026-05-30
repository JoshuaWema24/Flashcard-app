// screens/card_form_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class CardFormScreen extends StatefulWidget {
  const CardFormScreen({super.key, this.card});

  final Flashcard? card;

  @override
  State<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends State<CardFormScreen> {
  late TextEditingController _answerCtrl;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionCtrl;

  @override
  void dispose() {
    _questionCtrl.dispose();
    _answerCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _questionCtrl = TextEditingController(text: widget.card?.question ?? '');
    _answerCtrl = TextEditingController(text: widget.card?.answer ?? '');
  }

  bool get _isEditing => widget.card != null;

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

  Widget _buildSectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF00C853).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF00C853)),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required TextInputAction inputAction,
    required String validatorMessage,
    void Function(String)? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        textInputAction: inputAction,
        onFieldSubmitted: onSubmitted,
        style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
          contentPadding: const EdgeInsets.all(18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFFFD600), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (v) => (v == null || v.trim().isEmpty) ? validatorMessage : null,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF00C853).withOpacity(0.3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C853).withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _save,
        icon: Icon(_isEditing ? Icons.check_rounded : Icons.add_rounded, size: 22),
        label: Text(_isEditing ? 'Save Changes' : 'Create Card'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00C853),
          foregroundColor: Colors.white,
          elevation: 0, // Elevation is handled beautifully via physical container boxshadow above
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Slightly cleaner white-grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD600),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _isEditing ? 'Edit Flashcard' : 'Create New Card',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background soft blur ambient circles (Consistent with Home/Manage style)
          Positioned(
            top: -40,
            right: -20,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD600).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF00C853).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Form Body
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on background tap
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('The Question', Icons.help_outline_rounded),
                    const SizedBox(height: 10),
                    _buildInputField(
                      controller: _questionCtrl,
                      hintText: 'What knowledge or question goes on the front side?',
                      inputAction: TextInputAction.next,
                      validatorMessage: 'Question cannot be empty',
                    ),
                    const SizedBox(height: 28),
                    _buildSectionLabel('The Hidden Answer', Icons.lightbulb_outline_rounded),
                    const SizedBox(height: 10),
                    _buildInputField(
                      controller: _answerCtrl,
                      hintText: 'What is the answer hidden on the back side?',
                      inputAction: TextInputAction.done,
                      validatorMessage: 'Answer cannot be empty',
                      onSubmitted: (_) => _save(),
                    ),
                    const SizedBox(height: 48),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
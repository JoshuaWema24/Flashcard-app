import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../services/flashcard_service.dart';
import 'card_form_screen.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  final FlashcardService _service = FlashcardService();
  List<Flashcard> _cards = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cards = await _service.loadCards();
    setState(() => _cards = cards);
  }

  Future<void> _delete(int index) async {
    final card = _cards[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete card?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text(
          '"${card.question}"',
          style: const TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _cards.removeAt(index));
      await _service.saveCards(_cards);
    }
  }

  Future<void> _openForm({Flashcard? card, int? index}) async {
    final result = await Navigator.push<Flashcard>(
      context,
      MaterialPageRoute(
        builder: (_) => CardFormScreen(card: card),
      ),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          _cards[index] = result;
        } else {
          _cards.add(result);
        }
      });
      await _service.saveCards(_cards);
    }
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
        title: const Text(
          'Manage Cards',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: const Color(0xFF00C853),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Card',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: _cards.isEmpty
          ? const Center(
              child: Text('No cards. Tap + to add one.',
                  style: TextStyle(color: Colors.black38, fontSize: 15)),
            )
          : ListView.separated(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _cards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _buildCardTile(_cards[i], i),
            ),
    );
  }

  Widget _buildCardTile(Flashcard card, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD600).withOpacity(0.25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        title: Text(
          card.question,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 14),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            card.answer,
            style: const TextStyle(
                color: Colors.black45, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  color: Color(0xFF00C853), size: 22),
              tooltip: 'Edit',
              onPressed: () => _openForm(card: card, index: index),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: Color(0xFFE53935), size: 22),
              tooltip: 'Delete',
              onPressed: () => _delete(index),
            ),
          ],
        ),
      ),
    );
  }
}

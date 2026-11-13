import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  /// Membuat tampilan kosong dengan [message] dan [icon].
  const EmptyState({
    super.key,
    this.message = 'Belum ada catatan.\nTekan tombol + untuk menambah.',
    this.icon = Icons.note_alt_outlined,
  });

  /// Pesan yang ditampilkan.
  final String message;

  /// Ikon ilustrasi.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: scheme.outline),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: scheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}

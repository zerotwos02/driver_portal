import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/app_card.dart';
import '../../state/app_state.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(tripHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: items.isEmpty
            ? Center(
                child: AppCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.history_rounded, size: 28),
                      const SizedBox(height: 10),
                      const Text('No trips yet',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(
                        'Finish a trip to see it here.',
                        style: TextStyle(color: Colors.black.withValues(alpha: 0.55)),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final item = items[i];
                  final trip = item.trip;

                  return AppCard(
                    child: Row(
                      children: [
                        _IconTile(),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${trip.pickup} → ${trip.destination}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(item.time),
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.55),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${trip.price.toStringAsFixed(0)} MAD',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.70),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: Colors.black.withValues(alpha: 0.06),
                                    ),
                                  ),
                                  child: Text(
                                    'Completed',
                                    style: TextStyle(
                                      color: Colors.black.withValues(alpha: 0.70),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _formatTime(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.day)}/${two(t.month)}/${t.year}  ${two(t.hour)}:${two(t.minute)}';
  }
}

class _IconTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child: Icon(
            Icons.receipt_long_rounded,
            color: Colors.black.withValues(alpha: 0.70),
          ),
        ),
      ),
    );
  }
}

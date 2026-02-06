import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../state/app_state.dart';

class OnlineToggle extends ConsumerWidget {
  const OnlineToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.80),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
            boxShadow: const [BoxShadow(blurRadius: 18, color: Colors.black12)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline ? AppTheme.mint : Colors.black26,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                isOnline ? 'Online' : 'Offline',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 12),
              _MiniSwitch(
                value: isOnline,
                onChanged: (v) => ref.read(isOnlineProvider.notifier).state = v,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _MiniSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 44,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: value ? AppTheme.mint.withValues(alpha: 0.25) : Colors.black12,
          border: Border.all(
            color: value ? AppTheme.mint.withValues(alpha: 0.35) : Colors.black12,
          ),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? AppTheme.mint : Colors.white,
              boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
            ),
            child: Icon(
              value ? Icons.check_rounded : Icons.close_rounded,
              size: 14,
              color: value ? Colors.white : Colors.black38,
            ),
          ),
        ),
      ),
    );
  }
}

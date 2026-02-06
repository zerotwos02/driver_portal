import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../shared/widgets/app_card.dart';
import '../../state/app_state.dart';
import '../../state/theme_state.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _baseCtrl;
  late final TextEditingController _perKmCtrl;
  late final TextEditingController _feeCtrl;

  @override
  void initState() {
    super.initState();
    final p = ref.read(pricingProvider);
    _baseCtrl = TextEditingController(text: p.baseFare.toString());
    _perKmCtrl = TextEditingController(text: p.perKm.toString());
    _feeCtrl = TextEditingController(text: p.serviceFee.toString());
  }

  @override
  void dispose() {
    _baseCtrl.dispose();
    _perKmCtrl.dispose();
    _feeCtrl.dispose();
    super.dispose();
  }

  double _parse(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.')) ?? 0;

  void _apply() {
    final next = PricingConfig(
      baseFare: _parse(_baseCtrl),
      perKm: _parse(_perKmCtrl),
      serviceFee: _parse(_feeCtrl),
    );
    ref.read(pricingProvider.notifier).state = next;
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final pricing = ref.watch(pricingProvider);
    final example = pricing.examplePrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Dark mode'),
              value: ref.watch(themeModeProvider) == ThemeMode.dark,
              onChanged: (v) => ref.read(themeModeProvider.notifier).state =
                  v ? ThemeMode.dark : ThemeMode.light,
            ),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pricing',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text('Mock config • updates offer price instantly',
                      style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.55), fontSize: 12)),
                  const SizedBox(height: 14),
                  _FieldRow(label: 'Base fare', controller: _baseCtrl, suffix: 'MAD'),
                  const SizedBox(height: 10),
                  _FieldRow(label: 'Per km', controller: _perKmCtrl, suffix: 'MAD'),
                  const SizedBox(height: 10),
                  _FieldRow(label: 'Service fee', controller: _feeCtrl, suffix: 'MAD'),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.mint.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.mint.withValues(alpha: 0.18)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long_rounded, size: 18),
                        const SizedBox(width: 10),
                        const Text('Example total',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Text('${example.toStringAsFixed(0)} MAD',
                            style: const TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _apply,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String suffix;

  const _FieldRow({
    required this.label,
    required this.controller,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(label,
              style: TextStyle(color: Colors.black.withValues(alpha: 0.55))),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w800),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.70),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppTheme.mint.withValues(alpha: 0.55)),
                  ),
                  suffixText: suffix,
                  suffixStyle:
                      TextStyle(color: Colors.black.withValues(alpha: 0.45)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

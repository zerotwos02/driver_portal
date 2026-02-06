import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_card.dart';
import '../../../state/app_state.dart';

class RideOfferCard extends ConsumerWidget {
  final RideOffer offer;
  const RideOfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pricing = ref.watch(pricingProvider);
    final displayPrice = pricing.examplePrice();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ride offer', style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 10),

          Row(
            children: [
              _Avatar(name: offer.riderName),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.riderName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const _StarsRow(rating: 4.8, reviews: 128),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${displayPrice.toStringAsFixed(0)} MAD',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '2.3 km',
                    style: TextStyle(color: Colors.black.withValues(alpha: 0.55), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          _LocationRow(icon: Icons.my_location_rounded, text: offer.pickup),
          const SizedBox(height: 8),
          _LocationRow(icon: Icons.flag_rounded, text: offer.destination),

          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Offer declined (mock)')),
                    );
                  },
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    ref.read(activeTripProvider.notifier).state = RideOffer(
                      riderName: offer.riderName,
                      pickup: offer.pickup,
                      destination: offer.destination,
                      price: displayPrice,
                    );
                    context.push('/route');
                  },
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(RegExp(r'\s+')).take(2).map((e) => e[0]).join();

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [Color(0xFF19C37D), Color(0xFF2DD4BF)]),
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _StarsRow extends StatelessWidget {
  final double rating;
  final int reviews;
  const _StarsRow({required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (i) {
          final filled = i < 4;
          return Icon(
            filled ? Icons.star_rounded : Icons.star_border_rounded,
            size: 16,
            color: filled ? const Color(0xFF19C37D) : Colors.black26,
          );
        }),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
        const SizedBox(width: 6),
        Text(
          '($reviews)',
          style: TextStyle(color: Colors.black.withValues(alpha: 0.55), fontSize: 12),
        ),
      ],
    );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _LocationRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

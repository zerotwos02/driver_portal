import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../state/app_state.dart';
import 'widgets/online_toggle.dart';
import 'widgets/ride_offer_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offer = ref.watch(currentOfferProvider);

    return Stack(
      children: [
        const _HomeMap(),

        Positioned(
          right: 16,
          top: 86,
          child: Column(
            children: const [
              _MapFab(icon: Icons.my_location_rounded),
              SizedBox(height: 10),
              _MapFab(icon: Icons.layers_rounded),
            ],
          ),
        ),

        const Positioned(
          left: 16,
          bottom: 84,
          child: OnlineToggle(),
        ),

        if (offer != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 150,
            child: RideOfferCard(offer: offer),
          ),
      ],
    );
  }
}

class _HomeMap extends StatelessWidget {
  const _HomeMap();

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: const ValueKey('homeMap'),
      cameraOptions: CameraOptions(
        center: Point(coordinates: Position(-6.8498, 33.9716)),
        zoom: 12.5,
      ),
      styleUri: MapboxStyles.MAPBOX_STREETS,
    );
  }
}

class _MapFab extends StatelessWidget {
  final IconData icon;
  const _MapFab({required this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
            boxShadow: const [BoxShadow(blurRadius: 18, color: Colors.black12)],
          ),
          child: Icon(icon, color: Colors.black87),
        ),
      ),
    );
  }
}

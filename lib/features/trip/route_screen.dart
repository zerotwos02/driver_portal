import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../shared/widgets/app_card.dart';
import '../../state/app_state.dart';

const _mapboxToken =
    'pk.eyJ1IjoiemFocmFlamEiLCJhIjoiY21sYXUyeGp1MGgzazNlcnpzeW1meGlzbyJ9.ewwTnf-usHpFkAmnVoZtNA';

class RouteScreen extends ConsumerStatefulWidget {
  const RouteScreen({super.key});

  @override
  ConsumerState<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends ConsumerState<RouteScreen> {
  MapboxMap? _map;
  PointAnnotationManager? _points;
  PolylineAnnotationManager? _lines;

  final Point _pickup = Point(coordinates: Position(-6.8370, 33.9920));
  final Point _dest = Point(coordinates: Position(-6.8790, 33.9690));

  @override
  void dispose() {
    _points?.deleteAll();
    _lines?.deleteAll();
    super.dispose();
  }

  Future<List<Position>> _fetchRoute(Point a, Point b) async {
    final aPos = a.coordinates;
    final bPos = b.coordinates;

    final url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/'
        '${aPos.lng},${aPos.lat};${bPos.lng},${bPos.lat}'
        '?geometries=geojson&overview=full&access_token=$_mapboxToken';

    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body) as Map<String, dynamic>;

    final coords = (data['routes'][0]['geometry']['coordinates'] as List)
        .cast<List>()
        .map((c) => Position(c[0] as num, c[1] as num))
        .toList();

    return coords;
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _map = mapboxMap;

    _points = await mapboxMap.annotations.createPointAnnotationManager();
    _lines = await mapboxMap.annotations.createPolylineAnnotationManager();

    await _points!.create(PointAnnotationOptions(
      geometry: _pickup,
      iconImage: "marker-15",
      iconSize: 1.2,
    ));

    await _points!.create(PointAnnotationOptions(
      geometry: _dest,
      iconImage: "marker-15",
      iconSize: 1.2,
    ));

    final routeCoords = await _fetchRoute(_pickup, _dest);

    await _lines!.create(PolylineAnnotationOptions(
      geometry: LineString(coordinates: routeCoords),
      lineWidth: 6.0,
      lineOpacity: 0.9,
    ));

    await _map!.setCamera(CameraOptions(
      center: _pickup,
      zoom: 12.8,
      pitch: 35,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(activeTripProvider);
    final pricing = ref.watch(pricingProvider);
    final displayPrice = (trip?.price ?? pricing.examplePrice());

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MapWidget(
              key: const ValueKey('routeMap'),
              styleUri: MapboxStyles.MAPBOX_STREETS,
              cameraOptions: CameraOptions(center: _pickup, zoom: 12.5),
              onMapCreated: _onMapCreated,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 44,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.78),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: Colors.black.withValues(alpha: 0.06)),
                            boxShadow: const [
                              BoxShadow(blurRadius: 18, color: Colors.black12)
                            ],
                          ),
                          child: const Icon(Icons.arrow_back_rounded,
                              color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trip info',
                    style:
                        TextStyle(fontWeight: FontWeight.w900, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(label: 'Rider', value: trip?.riderName ?? '—'),
                  _InfoRow(label: 'Pickup', value: trip?.pickup ?? '—'),
                  _InfoRow(
                      label: 'Destination', value: trip?.destination ?? '—'),
                    _InfoRow(
                      label: 'Price',
                      value: '${displayPrice.toStringAsFixed(0)} MAD'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            final t = ref.read(activeTripProvider);
                            if (t != null) {
                              final list = ref.read(tripHistoryProvider);
                              ref.read(tripHistoryProvider.notifier).state = [
                                TripHistoryItem(time: DateTime.now(), trip: t),
                                ...list,
                              ];
                            }
                            ref.read(activeTripProvider.notifier).state = null;
                            Navigator.of(context).pop();
                          },
                          child: const Text('End (mock)'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {},
                          child: const Text('Start'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.55),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

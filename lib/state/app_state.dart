import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final isOnlineProvider = StateProvider<bool>((ref) => false);

class RideOffer {
  final String riderName;
  final String pickup;
  final String destination;
  final double price;
  const RideOffer({
    required this.riderName,
    required this.pickup,
    required this.destination,
    required this.price,
  });
}

class TripHistoryItem {
  final DateTime time;
  final RideOffer trip;
  const TripHistoryItem({required this.time, required this.trip});
}

final currentOfferProvider = Provider<RideOffer?>((ref) {
  final online = ref.watch(isOnlineProvider);
  if (!online) return null;

  final pricing = ref.watch(pricingProvider);
  final price = pricing.examplePrice();

  return RideOffer(
    riderName: "Zahrae A.",
    pickup: "Avenue Mohammed V",
    destination: "Technopark",
    price: price,
  );
});

final activeTripProvider = StateProvider<RideOffer?>((ref) => null);

final tripHistoryProvider =
  StateProvider<List<TripHistoryItem>>((ref) => []);

class PricingConfig {
  final double baseFare;
  final double perKm;
  final double serviceFee;
  const PricingConfig({
    required this.baseFare,
    required this.perKm,
    required this.serviceFee,
  });

  double examplePrice() => baseFare + (7 * perKm) + serviceFee;
}

final pricingProvider = StateProvider<PricingConfig>((ref) {
  return const PricingConfig(baseFare: 20, perKm: 3, serviceFee: 1.5);
});

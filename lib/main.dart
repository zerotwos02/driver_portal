import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'app/app.dart';
import 'state/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken('pk.eyJ1IjoiemFocmFlamEiLCJhIjoiY21sYXUyeGp1MGgzazNlcnpzeW1meGlzbyJ9.ewwTnf-usHpFkAmnVoZtNA');
  runApp(const ProviderScope(child: _Root()));
}

class _Root extends ConsumerWidget {
  const _Root({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return DriverPortalApp(themeMode: mode);
  }
}

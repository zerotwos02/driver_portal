import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/theme.dart';

class ShellScaffold extends StatefulWidget {
  final Widget child;
  const ShellScaffold({super.key, required this.child});

  @override
  State<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<ShellScaffold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _indexFromLocation(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/history')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      key: _scaffoldKey,
      drawer: _AppDrawer(),
      body: SafeArea(bottom: false, child: widget.child),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                  boxShadow: const [BoxShadow(blurRadius: 18, color: Colors.black12)],
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: currentIndex,
                  onTap: (i) {
                    if (i == 0) context.go('/home');
                    if (i == 3) _scaffoldKey.currentState?.openDrawer();

                    if (i == 2) context.go('/history');

                    // Wallet: UI only (no route)
                    if (i == 1) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Wallet (UI only)'),
                          duration: Duration(milliseconds: 900),
                        ),
                      );
                    }
                  },
                  selectedItemColor: AppTheme.mint,
                  unselectedItemColor: Colors.black54,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
                  items: const [
                    BottomNavigationBarItem(
                      icon: _NavIcon(icon: Icons.home_outlined),
                      activeIcon: _NavIcon(icon: Icons.home_rounded, active: true),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: _NavIcon(icon: Icons.account_balance_wallet_outlined),
                      activeIcon: _NavIcon(
                          icon: Icons.account_balance_wallet_rounded, active: true),
                      label: 'Wallet',
                    ),
                    BottomNavigationBarItem(
                      icon: _NavIcon(icon: Icons.history_outlined),
                      activeIcon: _NavIcon(icon: Icons.history_rounded, active: true),
                      label: 'History',
                    ),
                    BottomNavigationBarItem(
                      icon: _NavIcon(icon: Icons.menu_rounded),
                      activeIcon: _NavIcon(icon: Icons.menu_rounded, active: true),
                      label: 'Menu',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF4F6F8),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.80),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                          boxShadow: const [BoxShadow(blurRadius: 18, color: Colors.black12)],
                        ),
                        child: const Icon(Icons.local_taxi_rounded, color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Driver Portal',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.mint,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('Online', style: TextStyle(fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Text(
                          'v1.0',
                          style: TextStyle(color: Colors.black.withValues(alpha: 0.55)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            _DrawerTile(
              icon: Icons.settings_rounded,
              title: 'Settings',
              onTap: () => context.go('/settings'),
            ),
            _DrawerTile(
              icon: Icons.history_rounded,
              title: 'History',
              onTap: () => context.go('/history'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Polished UI • Mocked data • Fast navigation',
                style: TextStyle(color: Colors.black.withValues(alpha: 0.45), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Material(
            color: Colors.white.withValues(alpha: 0.70),
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.black87),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: Colors.black.withValues(alpha: 0.35)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  const _NavIcon({required this.icon, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppTheme.mint.withValues(alpha: 0.14) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: active ? Border.all(color: AppTheme.mint.withValues(alpha: 0.22)) : null,
      ),
      child: Icon(icon),
    );
  }
}

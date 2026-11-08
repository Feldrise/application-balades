// PROTOTYPE — throwaway. Three visual directions for the espace de gestion, on the existing
// /admin/balade/:id route (and /admin list), switchable via ?variant=A|B|C.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'prototype_variant_a.dart';
import 'prototype_variant_b.dart';
import 'prototype_variant_c.dart';
import 'prototype_variant_d.dart';

/// The prototype only shows in debug, or in a build made with --dart-define=PROTOTYPE=true.
const bool kPrototypeEnabled = !kReleaseMode || bool.fromEnvironment('PROTOTYPE');

/// Variants in the switcher cycle. A ("Carnet de terrain") was rejected: still reachable by URL only.
const protoVariants = ['B', 'C', 'D'];
const protoAllVariants = ['A', 'B', 'C', 'D'];
const protoVariantNames = {'A': 'Carnet de terrain', 'B': 'Tableau de bord clair', 'C': 'Immersif vert', 'D': 'Clair & vert'};

/// The variant asked in the URL, or null when the page should render as usual.
String? protoVariantOf(GoRouterState state) {
  if (!kPrototypeEnabled) return null;
  final v = state.uri.queryParameters['variant']?.toUpperCase();
  return protoAllVariants.contains(v) ? v : null;
}

/// Hosts the variants of the "feuille de balade".
class PrototypeRambleSheetHost extends StatelessWidget {
  const PrototypeRambleSheetHost({super.key, required this.rambleId, required this.variant});

  final int rambleId;
  final String variant;

  @override
  Widget build(BuildContext context) {
    final child = switch (variant) {
      'B' => VariantBSheet(rambleId: rambleId),
      'C' => VariantCSheet(rambleId: rambleId),
      'D' => VariantDSheet(rambleId: rambleId),
      _ => VariantASheet(rambleId: rambleId),
    };
    return PrototypeSwitcherFrame(variant: variant, child: child);
  }
}

/// Hosts the variants of the admin balades list.
class PrototypeRamblesListHost extends StatelessWidget {
  const PrototypeRamblesListHost({super.key, required this.variant});

  final String variant;

  @override
  Widget build(BuildContext context) {
    final child = switch (variant) {
      'B' => const VariantBList(),
      'C' => const VariantCList(),
      'D' => const VariantDList(),
      _ => const VariantAList(),
    };
    return PrototypeSwitcherFrame(variant: variant, child: child);
  }
}

/// Hosts the variants of the admin reservations screen.
class PrototypeReservationsHost extends StatelessWidget {
  const PrototypeReservationsHost({super.key, required this.variant});

  final String variant;

  @override
  Widget build(BuildContext context) {
    final child = switch (variant) {
      'B' => const VariantBReservations(),
      'C' => const VariantCReservations(),
      'D' => const VariantDReservations(),
      _ => const VariantAReservations(),
    };
    return PrototypeSwitcherFrame(variant: variant, child: child);
  }
}

/// Overlays the floating switcher and handles the ←/→ keys.
class PrototypeSwitcherFrame extends StatefulWidget {
  const PrototypeSwitcherFrame({super.key, required this.variant, required this.child});

  final String variant;
  final Widget child;

  @override
  State<PrototypeSwitcherFrame> createState() => _PrototypeSwitcherFrameState();
}

class _PrototypeSwitcherFrameState extends State<PrototypeSwitcherFrame> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final focused = FocusManager.instance.primaryFocus?.context?.widget;
    if (focused is EditableText) return false;
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _go(-1);
      return true;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _go(1);
      return true;
    }
    return false;
  }

  void _go(int delta) {
    if (!mounted) return;
    final i = protoVariants.indexOf(widget.variant).clamp(0, protoVariants.length - 1);
    final next = protoVariants[(i + delta + protoVariants.length) % protoVariants.length];
    final uri = GoRouterState.of(context).uri;
    context.go(uri.replace(queryParameters: {...uri.queryParameters, 'variant': next}).toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        Positioned(
          left: 0,
          right: 0,
          bottom: isMobile ? 92 : 20,
          child: Center(
            child: Material(
              color: const Color(0xff111111),
              elevation: 10,
              shape: const StadiumBorder(side: BorderSide(color: Color(0xffffd400), width: 2)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () => _go(-1), icon: const Icon(Icons.chevron_left, color: Colors.white), tooltip: 'Variante précédente'),
                    Text(
                      '${widget.variant} (${protoVariantNames[widget.variant]})',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'monospace'),
                    ),
                    IconButton(onPressed: () => _go(1), icon: const Icon(Icons.chevron_right, color: Colors.white), tooltip: 'Variante suivante'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

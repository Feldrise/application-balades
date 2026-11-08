// PROTOTYPE — throwaway. Three visual directions for the espace de gestion, on the existing
// /admin/balade/:id route (and /admin list), switchable via ?variant=A|B|C.
//
// Variant C — "Immersif vert": a compact photo header under a green gradient, a deep green
// navigation, colored status accents, a chip-based summary and a floating "Pointer" mode where
// participants become big toggles.

import 'package:balade/core/widgets/app_logo.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'prototype_data.dart';

const _deep = Color(0xff00341d);
const _green = Color(0xff006d41);
const _mint = Color(0xffd8f1e2);
const _bg = Color(0xffeef4f0);
const _text = Color(0xff142019);
const _muted = Color(0xff5d6b62);

TextStyle _t(double size, {FontWeight weight = FontWeight.w400, Color color = _text}) => GoogleFonts.lato(fontSize: size, fontWeight: weight, color: color, height: 1.3);
TextStyle _h(double size, {Color color = _text}) => GoogleFonts.lora(fontSize: size, fontWeight: FontWeight.w700, color: color, height: 1.2);

Color _accent(String s) => switch (s) {
  'confirmed' => const Color(0xff1f9d5c),
  'pending' => const Color(0xffe39b1b),
  'waiting_list' => const Color(0xff4f7cb3),
  _ => const Color(0xffd0493a),
};

// ————————————————————————————————— Shell —————————————————————————————————

class _ShellC extends StatelessWidget {
  const _ShellC({required this.index, required this.child, this.fab});

  final int index;
  final Widget child;
  final Widget? fab;

  static const _items = [
    (Icons.landscape_outlined, Icons.landscape, 'Balades', '/admin?variant=C'),
    (Icons.confirmation_number_outlined, Icons.confirmation_number, 'Réservations', '/admin/reservations?variant=C'),
    (Icons.account_circle_outlined, Icons.account_circle, 'Profil', '/admin/mon-profil?variant=C'),
  ];

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1024;
    if (desktop) {
      return Scaffold(
        backgroundColor: _bg,
        floatingActionButton: fab,
        body: Row(
          children: [
            Container(
              width: 88,
              color: _deep,
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: const AppLogo(height: 30)),
                  const SizedBox(height: 26),
                  for (var i = 0; i < _items.length; i++)
                    InkWell(
                      onTap: () => context.go(_items[i].$4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(color: i == index ? Colors.white.withValues(alpha: 0.16) : null, borderRadius: BorderRadius.circular(16)),
                              child: Icon(i == index ? _items[i].$2 : _items[i].$1, color: i == index ? Colors.white : Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(_items[i].$3, style: _t(11, color: i == index ? Colors.white : Colors.white70, weight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  const Spacer(),
                  IconButton(tooltip: 'Voir le site public', onPressed: () => context.go('/balades'), icon: const Icon(Icons.public, color: Colors.white70)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: _bg,
      body: child,
      floatingActionButton: fab == null ? null : Padding(padding: const EdgeInsets.only(bottom: 56), child: fab),
      bottomNavigationBar: NavigationBar(
        backgroundColor: _deep,
        indicatorColor: Colors.white.withValues(alpha: 0.16),
        selectedIndex: index,
        height: 66,
        onDestinationSelected: (i) => context.go(_items[i].$4),
        labelTextStyle: WidgetStatePropertyAll(_t(12, color: Colors.white, weight: FontWeight.w700)),
        destinations: [for (final it in _items) NavigationDestination(icon: Icon(it.$1, color: Colors.white70), selectedIcon: Icon(it.$2, color: Colors.white), label: it.$3)],
      ),
    );
  }
}

// ————————————————————————————————— Feuille de balade —————————————————————————————————

class VariantCSheet extends ConsumerStatefulWidget {
  const VariantCSheet({super.key, required this.rambleId});

  final int rambleId;

  @override
  ConsumerState<VariantCSheet> createState() => _VariantCSheetState();
}

class _VariantCSheetState extends ConsumerState<VariantCSheet> {
  final presence = PresenceController();
  bool rollCall = false;
  int tab = 0;

  @override
  void dispose() {
    presence.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(protoSheetProvider(widget.rambleId));
    return _ShellC(
      index: 0,
      fab: async.hasValue
          ? FloatingActionButton.extended(
              backgroundColor: rollCall ? Colors.white : _green,
              foregroundColor: rollCall ? _green : Colors.white,
              onPressed: () => setState(() {
                rollCall = !rollCall;
                tab = 0;
              }),
              icon: Icon(rollCall ? Icons.check : Icons.how_to_reg),
              label: Text(rollCall ? 'Terminer l\'appel' : 'Pointer'),
            )
          : null,
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: _green)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (sheet) => ListenableBuilder(listenable: presence, builder: (context, _) => _body(context, sheet)),
      ),
    );
  }

  Widget _body(BuildContext context, ProtoSheet sheet) {
    final desktop = MediaQuery.sizeOf(context).width >= 1024;
    final participants = _ParticipantsC(sheet: sheet, presence: presence, rollCall: rollCall);
    if (desktop) {
      return ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          _Hero(sheet: sheet, presence: presence, height: 210),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: participants),
                const SizedBox(width: 20),
                Expanded(child: _InfoC(sheet: sheet)),
              ],
            ),
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 170),
      children: [
        _Hero(sheet: sheet, presence: presence, height: 230),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(
            children: [
              for (final (i, label) in [(0, 'Participants'), (1, 'Balade')])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: tab == i,
                    showCheckmark: false,
                    selectedColor: _deep,
                    labelStyle: _t(13.5, weight: FontWeight.w700, color: tab == i ? Colors.white : _text),
                    backgroundColor: Colors.white,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    onSelected: (_) => setState(() => tab = i),
                  ),
                ),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.all(12), child: tab == 0 ? participants : _InfoC(sheet: sheet)),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.sheet, required this.presence, required this.height});

  final ProtoSheet sheet;
  final PresenceController presence;
  final double height;

  @override
  Widget build(BuildContext context) {
    final r = sheet.ramble;
    final coming = sheet.comingParticipants;
    final present = coming.where((p) => presence.isPresent(p.id)).length;
    Widget chip(IconData icon, String text, {VoidCallback? onTap}) => InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: Colors.white),
            const SizedBox(width: 5),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 230), child: Text(text, style: _t(12.5, color: Colors.white, weight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (coverUrl(r).isNotEmpty) Image.network(coverUrl(r), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: _green)) else Container(color: _green),
          const DecoratedBox(
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x6600341d), Color(0xee00341d)])),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(onPressed: () => context.go('/admin?variant=C'), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.title, style: _h(22, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            chip(Icons.event, '${frLongDate(r.date)} · ${frTime(r.date)}'),
                            chip(Icons.place, r.meetingPoint ?? r.location ?? 'RDV à préciser', onTap: () => openMaps(context, r)),
                            chip(Icons.group, '${sheet.placesTaken}/${r.maxParticipants ?? '∞'} places'),
                            chip(Icons.how_to_reg, '$present/${coming.length} présents'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantsC extends StatelessWidget {
  const _ParticipantsC({required this.sheet, required this.presence, required this.rollCall});

  final ProtoSheet sheet;
  final PresenceController presence;
  final bool rollCall;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: presence.offline ? const Color(0xfffff3dc) : _mint, borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: presence.toggleNetwork,
            child: Row(
              children: [
                Icon(presence.offline ? Icons.signal_cellular_connected_no_internet_4_bar : Icons.cloud_done, size: 18, color: presence.offline ? const Color(0xff9a6400) : _green),
                const SizedBox(width: 8),
                Expanded(child: Text(presence.syncLabel, style: _t(12.5, weight: FontWeight.w700, color: presence.offline ? const Color(0xff7a5000) : _deep))),
              ],
            ),
          ),
        ),
        if (rollCall)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('Mode appel : touchez chaque participant présent.', style: _t(13, weight: FontWeight.w700, color: _green)),
          ),
        const SizedBox(height: 10),
        for (final r in sheet.ordered) _ReservationCardC(reservation: r, presence: presence, rollCall: rollCall),
      ],
    );
  }
}

class _ReservationCardC extends StatelessWidget {
  const _ReservationCardC({required this.reservation, required this.presence, required this.rollCall});

  final Reservation reservation;
  final PresenceController presence;
  final bool rollCall;

  @override
  Widget build(BuildContext context) {
    final r = reservation;
    final active = r.status == 'confirmed' || r.status == 'pending';
    final paid = r.amountPaid > 0 && r.amountDue <= 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: _accent(r.status), width: 5)),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 6, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bookerName(r), style: _t(15.5, weight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        StatusTap(reservation: r, child: Text(statusLabel(r.status), style: _t(12, weight: FontWeight.w800, color: _accent(r.status)))),
                        Text('  ·  ', style: _t(12, color: _muted)),
                        Flexible(child: Text(paid ? 'Payé ${formatCents(r.amountPaid)}' : formatReservationAmount(r), style: _t(12, color: paid ? _green : _muted, weight: paid ? FontWeight.w800 : FontWeight.w400), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(style: IconButton.styleFrom(backgroundColor: _mint), tooltip: 'Appeler', onPressed: () => callBooker(context, r), icon: const Icon(Icons.call, size: 18, color: _deep)),
              IconButton.filledTonal(style: IconButton.styleFrom(backgroundColor: _mint), tooltip: 'Écrire', onPressed: () => emailBooker(r), icon: const Icon(Icons.mail, size: 18, color: _deep)),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final p in r.participants)
                _ParticipantChip(
                  label: '${p.firstName} ${p.lastName}',
                  sub: p.priceMissing ? 'tarif ?' : p.priceLabel,
                  present: presence.isPresent(p.id),
                  enabled: active && rollCall,
                  onTap: () => presence.toggle(p.id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParticipantChip extends StatelessWidget {
  const _ParticipantChip({required this.label, required this.sub, required this.present, required this.enabled, required this.onTap});

  final String label;
  final String sub;
  final bool present;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: present ? _green : (enabled ? Colors.white : _bg),
      shape: StadiumBorder(side: BorderSide(color: present ? _green : (enabled ? _green : Colors.transparent), width: 1.5)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: enabled ? 10 : 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (present) ...[const Icon(Icons.check, size: 16, color: Colors.white), const SizedBox(width: 4)],
              Text(label, style: _t(13, weight: FontWeight.w700, color: present ? Colors.white : _text)),
              const SizedBox(width: 6),
              Text(sub, style: _t(11.5, color: present ? Colors.white70 : _muted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoC extends StatelessWidget {
  const _InfoC({required this.sheet});

  final ProtoSheet sheet;

  @override
  Widget build(BuildContext context) {
    final r = sheet.ramble;
    Widget card(String title, IconData icon, Widget child) => Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 18, color: _green), const SizedBox(width: 8), Text(title, style: _t(14, weight: FontWeight.w800))]),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: _deep), onPressed: () => protoSnack(context, 'modifier'), icon: const Icon(Icons.edit, size: 18), label: const Text('Modifier'))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton.icon(onPressed: () => protoSnack(context, 'dupliquer'), icon: const Icon(Icons.copy, size: 18), label: const Text('Dupliquer'))),
            PopupMenuButton<String>(
              tooltip: 'Plus d\'actions',
              onSelected: (v) => v == 'cancel' ? confirmCancelRamble(context) : protoSnack(context, 'export'),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'export', child: Text('Exporter les participants')),
                PopupMenuItem(value: 'cancel', child: Text('Annuler la balade…', style: TextStyle(color: Color(0xffd0493a)))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        card(
          'En bref',
          Icons.info_outline,
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final s in [
                if (r.estimatedDuration != null) durationLabel(r.estimatedDuration),
                rambleDifficultyLabels[r.difficulty] ?? r.difficulty,
                'Guide : ${guideNames(r)}',
                publicationState(r).$1,
              ])
                Chip(label: Text(s, style: _t(12.5, weight: FontWeight.w700)), backgroundColor: _mint, side: BorderSide.none, visualDensity: VisualDensity.compact),
            ],
          ),
        ),
        card(
          'Tarifs',
          Icons.euro,
          Column(children: [for (final p in r.prices) Row(children: [Expanded(child: Text(p.label, style: _t(13.5))), Text(formatEuros(p.amount), style: _t(13.5, weight: FontWeight.w800))])]),
        ),
        if ((r.equipmentNeeded ?? '').isNotEmpty) card('Équipement', Icons.backpack_outlined, Text(r.equipmentNeeded!, style: _t(13.5, color: _muted))),
        if ((r.description ?? '').isNotEmpty) card('Description', Icons.notes, Text(r.description!, style: _t(13.5, color: _muted))),
      ],
    );
  }
}

// ————————————————————————————————— Liste des balades —————————————————————————————————

class VariantCList extends ConsumerWidget {
  const VariantCList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(protoRamblesProvider);
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= 1024;
    return _ShellC(
      index: 0,
      fab: FloatingActionButton.extended(backgroundColor: _green, foregroundColor: Colors.white, onPressed: () => protoSnack(context, 'nouvelle balade'), icon: const Icon(Icons.add), label: const Text('Nouvelle balade')),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: _green)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (rambles) {
          final groups = groupByPeriod(rambles);
          final cols = desktop ? 3 : (width >= 600 ? 2 : 1);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: _deep,
                  padding: EdgeInsets.fromLTRB(desktop ? 28 : 16, MediaQuery.paddingOf(context).top + 18, desktop ? 28 : 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Balades à venir', style: _h(24, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('${rambles.length} balades · ${rambles.fold<int>(0, (s, r) => s + takenOf(r))} participants inscrits', style: _t(13, color: Colors.white70)),
                      const SizedBox(height: 14),
                      TextField(
                        style: _t(14, color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Rechercher une balade, un lieu, un guide',
                          hintStyle: _t(14, color: Colors.white60),
                          prefixIcon: const Icon(Icons.search, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.12),
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              for (final period in Period.values)
                if (groups[period] != null) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(desktop ? 28 : 16, 20, 16, 10),
                      child: Text(periodLabel(period), style: _h(18)),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 12),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, mainAxisSpacing: 12, crossAxisSpacing: 12, mainAxisExtent: 150),
                      delegate: SliverChildBuilderDelegate((context, i) => _RambleTileC(ramble: groups[period]![i]), childCount: groups[period]!.length),
                    ),
                  ),
                ],
              const SliverToBoxAdapter(child: SizedBox(height: 170)),
            ],
          );
        },
      ),
    );
  }
}

class _RambleTileC extends StatelessWidget {
  const _RambleTileC({required this.ramble});

  final Ramble ramble;

  @override
  Widget build(BuildContext context) {
    final r = ramble;
    final state = publicationState(r);
    final max = r.maxParticipants;
    final taken = takenOf(r);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: _green,
        child: InkWell(
          onTap: () => context.go('/admin/balade/${r.id}?variant=C'),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (coverUrl(r).isNotEmpty) Image.network(coverUrl(r), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox()),
              const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x2200341d), Color(0xf000341d)]))),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: Text('${frDayName(r.date)} ${frShortDate(r.date)} · ${frTime(r.date)}', style: _t(12, weight: FontWeight.w800, color: _deep)),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: state.$2, borderRadius: BorderRadius.circular(8)),
                          child: Text(state.$1, style: _t(11.5, weight: FontWeight.w800, color: Colors.white)),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(r.title, style: _h(17, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(child: Text('${r.location ?? ''} · ${guideNames(r)}', style: _t(12.5, color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        if (max != null) Text('$taken/$max', style: _t(13, weight: FontWeight.w800, color: Colors.white)),
                      ],
                    ),
                    if (max != null) ...[
                      const SizedBox(height: 6),
                      ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: max == 0 ? 0 : taken / max, minHeight: 4, color: const Color(0xff7adaa1), backgroundColor: Colors.white24)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ————————————————————————————————— Réservations —————————————————————————————————

class VariantCReservations extends ConsumerStatefulWidget {
  const VariantCReservations({super.key});

  @override
  ConsumerState<VariantCReservations> createState() => _VariantCReservationsState();
}

class _VariantCReservationsState extends ConsumerState<VariantCReservations> {
  String? status;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(protoReservationsProvider);
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= 1024;
    return _ShellC(
      index: 1,
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: _green)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (all) {
          final list = status == null ? all : all.where((r) => r.status == status).toList();
          final pad = desktop ? 28.0 : 16.0;
          Widget statChip(String label, int n, String? s) {
            final sel = status == s;
            return InkWell(
              onTap: () => setState(() => status = s),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: desktop ? 170 : null,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: sel ? Colors.white : Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (s != null) ...[Container(width: 8, height: 8, decoration: BoxDecoration(color: _accent(s), shape: BoxShape.circle)), const SizedBox(width: 8)],
                    Text('$n', style: _t(desktop ? 20 : 15, weight: FontWeight.w800, color: sel ? _deep : Colors.white)),
                    const SizedBox(width: 6),
                    Flexible(child: Text(label, style: _t(12.5, color: sel ? _deep : Colors.white70, weight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: _deep,
                  padding: EdgeInsets.fromLTRB(pad, MediaQuery.paddingOf(context).top + 18, pad, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('Réservations', style: _h(24, color: Colors.white))),
                          IconButton(tooltip: 'Exporter', onPressed: () => protoSnack(context, 'export'), icon: const Icon(Icons.download, color: Colors.white)),
                          if (!desktop) IconButton(tooltip: 'Filtres', onPressed: () => _filtersC(context), icon: const Icon(Icons.tune, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        style: _t(14, color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Personne, email, balade',
                          hintStyle: _t(14, color: Colors.white60),
                          prefixIcon: const Icon(Icons.search, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.12),
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final (label, s) in [('Toutes', null), ('Confirmées', 'confirmed'), ('À confirmer', 'pending'), ('Attente', 'waiting_list'), ('Annulées', 'cancelled')])
                              Padding(padding: const EdgeInsets.only(right: 8), child: statChip(label, s == null ? all.length : all.where((r) => r.status == s).length, s)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(desktop ? pad : 12, 14, desktop ? pad : 12, 170),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: desktop ? 2 : 1, mainAxisSpacing: 10, crossAxisSpacing: 12, mainAxisExtent: 104),
                  delegate: SliverChildBuilderDelegate((context, i) => _ResTileC(reservation: list[i]), childCount: list.length.clamp(0, 80)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _filtersC(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filtres', style: _h(20)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in [null, ...reservationStatuses])
                  ChoiceChip(
                    label: Text(s == null ? 'Toutes' : statusLabel(s)),
                    selected: status == s,
                    selectedColor: _mint,
                    onSelected: (_) {
                      setState(() => status = s);
                      Navigator.pop(ctx);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 14),
            FilledButton.tonalIcon(onPressed: () => protoSnack(context, 'choisir une balade'), icon: const Icon(Icons.landscape_outlined), label: const Text('Toutes les balades')),
          ],
        ),
      ),
    );
  }
}

class _ResTileC extends StatelessWidget {
  const _ResTileC({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final r = reservation;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      shadowColor: const Color(0x22000000),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _detailC(context, r),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border(left: BorderSide(color: _accent(r.status), width: 5))),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(bookerOf(r), style: _t(15.5, weight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  StatusTap(
                    reservation: r,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: _accent(r.status).withValues(alpha: 0.14), borderRadius: BorderRadius.circular(10)),
                      child: Text(statusLabel(r.status), style: _t(11.5, weight: FontWeight.w800, color: _accent(r.status))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(rambleOf(r), style: _t(13, color: _muted), maxLines: 1, overflow: TextOverflow.ellipsis),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.event, size: 14, color: _muted),
                  const SizedBox(width: 4),
                  Text(rambleDateOf(r), style: _t(12.5, color: _muted)),
                  const SizedBox(width: 12),
                  const Icon(Icons.group, size: 14, color: _muted),
                  const SizedBox(width: 4),
                  Text('${r.participants.length}', style: _t(12.5, color: _muted)),
                  const Spacer(),
                  Text(reservationPayLabel(r), style: _t(13, weight: FontWeight.w800, color: isPaid(r) ? _green : _text)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _detailC(BuildContext context, Reservation r) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    showDragHandle: true,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(bookerOf(r), style: _h(22)),
          const SizedBox(height: 4),
          Text('${statusLabel(r.status)} · ${r.contactEmail}', style: _t(13, color: _accent(r.status), weight: FontWeight.w700)),
          ChangeStatusButton(reservation: r, color: _green),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rambleOf(r), style: _t(14.5, weight: FontWeight.w800)),
                Text(rambleDateOf(r), style: _t(13, color: _muted)),
                const SizedBox(height: 10),
                Wrap(spacing: 6, runSpacing: 6, children: [for (final p in r.participants) _ParticipantChip(label: '${p.firstName} ${p.lastName}', sub: p.priceMissing ? 'tarif ?' : p.priceLabel, present: false, enabled: false, onTap: () {})]),
                const SizedBox(height: 10),
                Text(reservationPayLabel(r), style: _t(15, weight: FontWeight.w800, color: isPaid(r) ? _green : _text)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton.filledTonal(style: IconButton.styleFrom(backgroundColor: _mint), onPressed: () => callBooker(context, r), icon: const Icon(Icons.call, color: _deep)),
              const SizedBox(width: 8),
              IconButton.filledTonal(style: IconButton.styleFrom(backgroundColor: _mint), onPressed: () => emailBooker(r), icon: const Icon(Icons.mail, color: _deep)),
              const SizedBox(width: 8),
              Expanded(child: FilledButton(style: FilledButton.styleFrom(backgroundColor: _deep), onPressed: () => context.go('/admin/balade/${r.rambleId}?variant=C'), child: const Text('Voir la balade'))),
            ],
          ),
        ],
      ),
    ),
  );
}

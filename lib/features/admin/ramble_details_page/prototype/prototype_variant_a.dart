// PROTOTYPE — throwaway. Three visual directions for the espace de gestion, on the existing
// /admin/balade/:id route (and /admin list), switchable via ?variant=A|B|C.
//
// Variant A — "Carnet de terrain": warm paper surfaces, Lora headings, a roll-call list with big
// touch targets, bottom navigation on mobile and a paper sidebar on desktop.

import 'package:balade/core/widgets/app_logo.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'prototype_data.dart';

const _paper = Color(0xfff7f2e7);
const _paperDark = Color(0xffede4d1);
const _ink = Color(0xff2b2a26);
const _inkSoft = Color(0xff6f6a5e);
const _green = Color(0xff006d41);
const _line = Color(0xffdcd2bd);

TextStyle _serif(double size, {FontWeight weight = FontWeight.w600, Color color = _ink}) => GoogleFonts.lora(fontSize: size, fontWeight: weight, color: color, height: 1.25);
TextStyle _sans(double size, {FontWeight weight = FontWeight.w400, Color color = _ink}) => GoogleFonts.lato(fontSize: size, fontWeight: weight, color: color, height: 1.35);

Color _statusColor(String s) => switch (s) {
  'confirmed' => _green,
  'pending' => const Color(0xffb26a00),
  'waiting_list' => const Color(0xff4a6a8a),
  _ => const Color(0xffa33a2b),
};

// ————————————————————————————————— Shell —————————————————————————————————

class _ShellA extends StatelessWidget {
  const _ShellA({required this.index, required this.child});

  final int index;
  final Widget child;

  static const _items = [
    (Icons.forest_outlined, Icons.forest, 'Balades', '/admin?variant=A'),
    (Icons.event_note_outlined, Icons.event_note, 'Réservations', '/admin/reservations?variant=A'),
    (Icons.badge_outlined, Icons.badge, 'Profil', '/admin/mon-profil?variant=A'),
  ];

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1024;
    if (desktop) {
      return Scaffold(
        backgroundColor: _paper,
        body: Row(
          children: [
            Container(
              width: 232,
              decoration: const BoxDecoration(color: _paperDark, border: Border(right: BorderSide(color: _line))),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                      child: Row(
                        children: [
                          const AppLogo(height: 36),
                          const SizedBox(width: 10),
                          Expanded(child: Text('Espace guide', style: _serif(17))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (var i = 0; i < _items.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        child: Material(
                          color: i == index ? _paper : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => context.go(_items[i].$4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(i == index ? _items[i].$2 : _items[i].$1, color: i == index ? _green : _inkSoft, size: 22),
                                  const SizedBox(width: 12),
                                  Text(_items[i].$3, style: _sans(15, weight: i == index ? FontWeight.w700 : FontWeight.w400, color: i == index ? _green : _ink)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextButton.icon(onPressed: () => context.go('/balades'), icon: const Icon(Icons.public, size: 18), label: const Text('Voir le site public')),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: _paper,
      body: SafeArea(bottom: false, child: child),
      bottomNavigationBar: NavigationBar(
        backgroundColor: _paperDark,
        indicatorColor: _paper,
        selectedIndex: index,
        height: 68,
        onDestinationSelected: (i) => context.go(_items[i].$4),
        destinations: [for (final it in _items) NavigationDestination(icon: Icon(it.$1), selectedIcon: Icon(it.$2, color: _green), label: it.$3)],
      ),
    );
  }
}

// ————————————————————————————————— Feuille de balade —————————————————————————————————

class VariantASheet extends ConsumerStatefulWidget {
  const VariantASheet({super.key, required this.rambleId});

  final int rambleId;

  @override
  ConsumerState<VariantASheet> createState() => _VariantASheetState();
}

class _VariantASheetState extends ConsumerState<VariantASheet> {
  final presence = PresenceController();

  @override
  void dispose() {
    presence.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(protoSheetProvider(widget.rambleId));
    return _ShellA(
      index: 0,
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: _green)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (sheet) => ListenableBuilder(listenable: presence, builder: (context, _) => _body(context, sheet)),
      ),
    );
  }

  Widget _body(BuildContext context, ProtoSheet sheet) {
    final desktop = MediaQuery.sizeOf(context).width >= 1024;
    if (desktop) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(40, 28, 40, 96),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(sheet: sheet),
                const SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _Participants(sheet: sheet, presence: presence)),
                    const SizedBox(width: 32),
                    SizedBox(width: 360, child: _BaladePanel(sheet: sheet)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 12), child: _Header(sheet: sheet))),
          SliverAppBar(
            pinned: true,
            primary: false,
            automaticallyImplyLeading: false,
            toolbarHeight: 0,
            backgroundColor: _paper,
            surfaceTintColor: Colors.transparent,
            bottom: TabBar(
              labelStyle: _serif(15),
              unselectedLabelStyle: _serif(15, weight: FontWeight.w400),
              labelColor: _green,
              unselectedLabelColor: _inkSoft,
              indicatorColor: _green,
              dividerColor: _line,
              tabs: [Tab(text: 'Participants · ${sheet.placesTaken}'), const Tab(text: 'La balade')],
            ),
          ),
        ],
        body: TabBarView(
          children: [
            ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 150), children: [_Participants(sheet: sheet, presence: presence)]),
            ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 150), children: [_BaladePanel(sheet: sheet)]),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.sheet});

  final ProtoSheet sheet;

  @override
  Widget build(BuildContext context) {
    final r = sheet.ramble;
    final max = r.maxParticipants;
    final taken = sheet.placesTaken;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: _inkSoft, padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
          onPressed: () => context.go('/admin?variant=A'),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: Text('Mes balades', style: _sans(13, color: _inkSoft)),
        ),
        const SizedBox(height: 4),
        Text('${frLongDate(r.date)} · ${frTime(r.date)}'.toUpperCase(), style: _sans(12, weight: FontWeight.w700, color: _green).copyWith(letterSpacing: 1.1)),
        const SizedBox(height: 6),
        Text(r.title, style: _serif(24)),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => openMaps(context, r),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.place_outlined, size: 18, color: _inkSoft),
                const SizedBox(width: 6),
                Expanded(child: Text(r.meetingPoint ?? r.location ?? 'Point de rendez-vous à préciser', style: _sans(14), maxLines: 2, overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 6),
                Text('Itinéraire', style: _sans(13, weight: FontWeight.w700, color: _green)),
                const Icon(Icons.north_east, size: 14, color: _green),
              ],
            ),
          ),
        ),
        if (max != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: max == 0 ? 0 : taken / max, minHeight: 8, color: _green, backgroundColor: _line),
                ),
              ),
              const SizedBox(width: 12),
              Text('$taken/$max places', style: _sans(14, weight: FontWeight.w700)),
            ],
          ),
        ],
      ],
    );
  }
}

class _Participants extends StatelessWidget {
  const _Participants({required this.sheet, required this.presence});

  final ProtoSheet sheet;
  final PresenceController presence;

  @override
  Widget build(BuildContext context) {
    final coming = sheet.comingParticipants;
    final presentCount = coming.where((p) => presence.isPresent(p.id)).length;
    final others = sheet.ordered.where((r) => r.status != 'confirmed' && r.status != 'pending').toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(14), border: Border.all(color: _line)),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appel', style: _sans(12, weight: FontWeight.w700, color: _inkSoft)),
                  Text('$presentCount / ${coming.length} présents', style: _serif(20)),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: presence.toggleNetwork,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(presence.offline ? Icons.cloud_off : Icons.cloud_done_outlined, size: 18, color: presence.offline ? const Color(0xffb26a00) : _green),
                    const SizedBox(width: 6),
                    ConstrainedBox(constraints: const BoxConstraints(maxWidth: 150), child: Text(presence.syncLabel, style: _sans(12, color: _inkSoft), maxLines: 2)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        for (final r in sheet.coming) _ReservationBlock(reservation: r, presence: presence),
        if (others.isNotEmpty) ...[
          const SizedBox(height: 8),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text('Liste d\'attente et annulées (${others.length})', style: _sans(14, weight: FontWeight.w700, color: _inkSoft)),
              children: [for (final r in others) _ReservationBlock(reservation: r, presence: presence, muted: true)],
            ),
          ),
        ],
      ],
    );
  }
}

class _ReservationBlock extends StatelessWidget {
  const _ReservationBlock({required this.reservation, required this.presence, this.muted = false});

  final Reservation reservation;
  final PresenceController presence;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final r = reservation;
    final paid = r.amountPaid > 0 && r.amountDue <= 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: _statusColor(r.status), shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bookerName(r), style: _serif(16), maxLines: 1, overflow: TextOverflow.ellipsis),
                    StatusTap(
                      reservation: r,
                      child: Text(
                      '${statusLabel(r.status)} · ${paid ? 'Payé ${formatCents(r.amountPaid)}' : formatReservationAmount(r)}',
                      style: _sans(12.5, color: paid ? _green : _inkSoft, weight: paid ? FontWeight.w700 : FontWeight.w400),
                    ),
                    ),
                  ],
                ),
              ),
              IconButton(tooltip: 'Appeler', onPressed: () => callBooker(context, r), icon: const Icon(Icons.call_outlined, color: _green)),
              IconButton(tooltip: 'Écrire', onPressed: () => emailBooker(r), icon: const Icon(Icons.mail_outline, color: _green)),
            ],
          ),
          const SizedBox(height: 4),
          for (final p in r.participants)
            InkWell(
              onTap: muted ? null : () => presence.toggle(p.id),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.only(left: 12, top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _line, style: BorderStyle.solid))),
                child: Row(
                  children: [
                    if (!muted)
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Checkbox(
                          value: presence.isPresent(p.id),
                          activeColor: _green,
                          side: const BorderSide(color: _inkSoft, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          onChanged: (_) => presence.toggle(p.id),
                        ),
                      ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${p.firstName} ${p.lastName}${p.isBooker ? '  ★' : ''}',
                        style: _sans(15, color: muted ? _inkSoft : _ink).copyWith(decoration: presence.isPresent(p.id) ? TextDecoration.none : null),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(p.priceMissing ? 'Tarif ?' : p.priceLabel, style: _sans(12.5, color: p.priceMissing ? const Color(0xffb26a00) : _inkSoft)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BaladePanel extends StatelessWidget {
  const _BaladePanel({required this.sheet});

  final ProtoSheet sheet;

  @override
  Widget build(BuildContext context) {
    final r = sheet.ramble;
    Widget section(String title, Widget child) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: _serif(16)), const SizedBox(height: 6), child]),
    );
    Widget fact(IconData icon, String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 17, color: _inkSoft), const SizedBox(width: 8), Expanded(child: Text(text, style: _sans(14)))]),
    );
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(14), border: Border.all(color: _line)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (coverUrl(r).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(aspectRatio: 16 / 7, child: Image.network(coverUrl(r), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: _paperDark))),
              ),
            ),
          Row(
            children: [
              FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: _green), onPressed: () => protoSnack(context, 'modifier'), icon: const Icon(Icons.edit_outlined, size: 18), label: const Text('Modifier')),
              const SizedBox(width: 8),
              OutlinedButton.icon(onPressed: () => protoSnack(context, 'dupliquer'), icon: const Icon(Icons.copy, size: 18), label: const Text('Dupliquer')),
              const Spacer(),
              PopupMenuButton<String>(
                tooltip: 'Plus d\'actions',
                icon: const Icon(Icons.more_horiz, color: _ink),
                onSelected: (v) => v == 'cancel' ? confirmCancelRamble(context) : protoSnack(context, 'export'),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'export', child: ListTile(leading: Icon(Icons.download), title: Text('Exporter les participants'))),
                  PopupMenuItem(value: 'cancel', child: ListTile(leading: Icon(Icons.event_busy, color: Color(0xffa33a2b)), title: Text('Annuler la balade', style: TextStyle(color: Color(0xffa33a2b))))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          section(
            'Infos pratiques',
            Column(
              children: [
                if (r.estimatedDuration != null) fact(Icons.schedule, 'Durée ${durationLabel(r.estimatedDuration)}'),
                fact(Icons.group_outlined, r.maxParticipants == null ? 'Sans limite de places' : '${r.maxParticipants} places'),
                fact(Icons.person_outline, 'Guide : ${guideNames(r)}'),
                if ((r.equipmentNeeded ?? '').isNotEmpty) fact(Icons.backpack_outlined, r.equipmentNeeded!),
              ],
            ),
          ),
          section(
            'Tarifs',
            Column(
              children: [
                for (final p in r.prices)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(children: [Expanded(child: Text(p.label, style: _sans(14))), Text(formatEuros(p.amount), style: _sans(14, weight: FontWeight.w700))]),
                  ),
              ],
            ),
          ),
          if ((r.description ?? '').isNotEmpty) section('Description', Text(r.description!, style: _sans(14, color: _inkSoft))),
          if ((r.prerequisites ?? '').isNotEmpty) section('Conditions particulières', Text(r.prerequisites!, style: _sans(14, color: _inkSoft))),
        ],
      ),
    );
  }
}

// ————————————————————————————————— Liste des balades —————————————————————————————————

class VariantAList extends ConsumerWidget {
  const VariantAList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(protoRamblesProvider);
    final desktop = MediaQuery.sizeOf(context).width >= 1024;
    return _ShellA(
      index: 0,
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: _green)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (rambles) {
          final groups = groupByPeriod(rambles);
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: ListView(
                padding: EdgeInsets.fromLTRB(desktop ? 32 : 16, desktop ? 32 : 16, desktop ? 32 : 16, 150),
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Mes balades', style: _serif(desktop ? 28 : 24))),
                      FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: _green), onPressed: () => protoSnack(context, 'nouvelle balade'), icon: const Icon(Icons.add, size: 18), label: const Text('Nouvelle')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher une balade',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.6),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _line)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _line)),
                      isDense: true,
                    ),
                  ),
                  for (final period in Period.values)
                    if (groups[period] != null) ...[
                      Padding(padding: const EdgeInsets.fromLTRB(4, 24, 4, 8), child: Text(periodLabel(period), style: _serif(17, color: _inkSoft))),
                      for (final r in groups[period]!) _RambleRowA(ramble: r),
                    ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RambleRowA extends StatelessWidget {
  const _RambleRowA({required this.ramble});

  final Ramble ramble;

  @override
  Widget build(BuildContext context) {
    final r = ramble;
    final state = publicationState(r);
    final max = r.maxParticipants;
    final taken = takenOf(r);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white.withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: _line)),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.go('/admin/balade/${r.id}?variant=A'),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 54,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(color: _paperDark, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(frDayName(r.date).toUpperCase(), style: _sans(11, weight: FontWeight.w700, color: _green)),
                      Text('${r.date?.day ?? '–'}', style: _serif(20)),
                      Text(frShortDate(r.date).split(' ').last, style: _sans(11, color: _inkSoft)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.title, style: _serif(15.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text('${frTime(r.date)} · ${r.location ?? ''} · ${guideNames(r)}', style: _sans(12.5, color: _inkSoft), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (max != null) ...[
                            SizedBox(
                              width: 80,
                              child: ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: max == 0 ? 0 : taken / max, minHeight: 5, color: _green, backgroundColor: _line)),
                            ),
                            const SizedBox(width: 8),
                            Text('$taken/$max', style: _sans(12, weight: FontWeight.w700)),
                            const SizedBox(width: 10),
                          ],
                          Text(state.$1, style: _sans(12, weight: FontWeight.w700, color: state.$2)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (coverUrl(r).isNotEmpty) ...[
                  const SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(coverUrl(r), width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox(width: 64, height: 64)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ————————————————————————————————— Réservations —————————————————————————————————

class VariantAReservations extends ConsumerStatefulWidget {
  const VariantAReservations({super.key});

  @override
  ConsumerState<VariantAReservations> createState() => _VariantAReservationsState();
}

class _VariantAReservationsState extends ConsumerState<VariantAReservations> {
  String? status;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(protoReservationsProvider);
    final desktop = MediaQuery.sizeOf(context).width >= 1024;
    return _ShellA(
      index: 1,
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: _green)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (all) {
          final list = status == null ? all : all.where((r) => r.status == status).toList();
          final header = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Réservations', style: _serif(desktop ? 28 : 24))),
                  if (desktop) OutlinedButton.icon(onPressed: () => protoSnack(context, 'export'), icon: const Icon(Icons.download, size: 18), label: const Text('Exporter')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Personne, email, balade…',
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _line)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _line)),
                      ),
                    ),
                  ),
                  if (!desktop) ...[
                    const SizedBox(width: 8),
                    IconButton.outlined(onPressed: () => _filters(context), icon: Badge(isLabelVisible: status != null, child: const Icon(Icons.tune))),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              if (desktop)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _statA('Toutes', all.length, null),
                    for (final s in reservationStatuses) _statA(statusLabel(s), all.where((r) => r.status == s).length, s),
                  ],
                )
              else
                Text('${list.length} réservation${list.length > 1 ? 's' : ''}${status == null ? '' : ' · ${statusLabel(status!)}'}', style: _sans(13, color: _inkSoft)),
              const SizedBox(height: 16),
            ],
          );
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: desktop ? 1100 : 700),
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(desktop ? 32 : 16, desktop ? 32 : 16, desktop ? 32 : 16, 150),
                itemCount: list.length + 1,
                itemBuilder: (context, i) => i == 0 ? header : _ResCardA(reservation: list[i - 1], wide: desktop),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statA(String label, int n, String? s) {
    final selected = status == s;
    return InkWell(
      onTap: () => setState(() => status = s),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? _paperDark : Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? _green : _line, width: selected ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$n', style: _serif(24, color: s == null ? _ink : _statusColor(s))),
            Text(label, style: _sans(13, color: _inkSoft), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  void _filters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _paper,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filtrer', style: _serif(20)),
            const SizedBox(height: 12),
            Text('Statut', style: _sans(13, weight: FontWeight.w700, color: _inkSoft)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in [null, ...reservationStatuses])
                  ChoiceChip(
                    label: Text(s == null ? 'Toutes' : statusLabel(s)),
                    selected: status == s,
                    selectedColor: _paperDark,
                    onSelected: (_) {
                      setState(() => status = s);
                      Navigator.pop(ctx);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Balade', style: _sans(13, weight: FontWeight.w700, color: _inkSoft)),
            const SizedBox(height: 6),
            OutlinedButton.icon(onPressed: () => protoSnack(context, 'choisir une balade'), icon: const Icon(Icons.forest_outlined), label: const Text('Toutes les balades')),
          ],
        ),
      ),
    );
  }
}

class _ResCardA extends StatelessWidget {
  const _ResCardA({required this.reservation, required this.wide});

  final Reservation reservation;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final r = reservation;
    final paid = isPaid(r);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white.withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: _line)),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _detailA(context, r),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(width: 4, height: 44, decoration: BoxDecoration(color: _statusColor(r.status), borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bookerOf(r), style: _serif(16), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text('${rambleOf(r)} · ${rambleDateOf(r)}', style: _sans(13, color: _inkSoft), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    StatusTap(reservation: r, child: Text(statusLabel(r.status), style: _sans(12.5, weight: FontWeight.w700, color: _statusColor(r.status)))),
                    const SizedBox(height: 2),
                    Text('${r.participants.length} pers. · ${reservationPayLabel(r)}', style: _sans(12.5, color: paid ? _green : _inkSoft, weight: paid ? FontWeight.w700 : FontWeight.w400)),
                  ],
                ),
                if (wide) ...[
                  const SizedBox(width: 8),
                  IconButton(tooltip: 'Écrire', onPressed: () => emailBooker(r), icon: const Icon(Icons.mail_outline, color: _green)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _detailA(BuildContext context, Reservation r) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: _paper,
    showDragHandle: true,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(statusLabel(r.status).toUpperCase(), style: _sans(12, weight: FontWeight.w700, color: _statusColor(r.status)).copyWith(letterSpacing: 1)),
          Text(bookerOf(r), style: _serif(22)),
          Text(r.contactEmail, style: _sans(13, color: _inkSoft)),
          const SizedBox(height: 12),
          Text('${rambleOf(r)} · ${rambleDateOf(r)}', style: _sans(14, weight: FontWeight.w700)),
          const SizedBox(height: 12),
          for (final p in r.participants)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [const Icon(Icons.person_outline, size: 18, color: _inkSoft), const SizedBox(width: 8), Expanded(child: Text('${p.firstName} ${p.lastName}', style: _sans(15))), Text(p.priceMissing ? 'Tarif ?' : p.priceLabel, style: _sans(13, color: _inkSoft))]),
            ),
          const Divider(color: _line, height: 24),
          Row(children: [Expanded(child: Text('Montant', style: _sans(14, color: _inkSoft))), Text(reservationPayLabel(r), style: _serif(16, color: isPaid(r) ? _green : _ink))]),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: OutlinedButton.icon(onPressed: () => callBooker(context, r), icon: const Icon(Icons.call_outlined), label: const Text('Appeler'))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(onPressed: () => emailBooker(r), icon: const Icon(Icons.mail_outline), label: const Text('Écrire'))),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(style: FilledButton.styleFrom(backgroundColor: _green), onPressed: () => context.go('/admin/balade/${r.rambleId}?variant=A'), child: const Text('Ouvrir la feuille de balade')),
          ),
          ChangeStatusButton(reservation: r, color: _green),
        ],
      ),
    ),
  );
}

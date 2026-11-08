// PROTOTYPE — throwaway. Three visual directions for the espace de gestion, on the existing
// /admin/balade/:id route (and /admin list), switchable via ?variant=A|B|C.
//
// Variant B — "Tableau de bord clair": neutral light surfaces, dense information, rows separated by
// dividers instead of nested cards, segmented tabs, crisp status badges, a slim navigation rail.

import 'package:balade/core/widgets/app_logo.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'prototype_data.dart';

const _bg = Color(0xfff6f7f6);
const _surface = Colors.white;
const _border = Color(0xffe3e6e4);
const _text = Color(0xff1c1f1d);
const _muted = Color(0xff667069);
const _green = Color(0xff006d41);

TextStyle _t(double size, {FontWeight weight = FontWeight.w400, Color color = _text}) => GoogleFonts.lato(fontSize: size, fontWeight: weight, color: color, height: 1.3);

class _Badge extends StatelessWidget {
  const _Badge(this.status);

  final String status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      'confirmed' => (const Color(0xffe3f4ea), const Color(0xff0b6b3a)),
      'pending' => (const Color(0xfffff1d6), const Color(0xff8a5a00)),
      'waiting_list' => (const Color(0xffe4ecf5), const Color(0xff34557a)),
      _ => (const Color(0xfffbe4e1), const Color(0xff9d2b1d)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(statusLabel(status), style: _t(11.5, weight: FontWeight.w700, color: fg)),
    );
  }
}

// ————————————————————————————————— Shell —————————————————————————————————

class _ShellB extends StatelessWidget {
  const _ShellB({required this.index, required this.child, required this.title, this.leading});

  final int index;
  final Widget child;
  final String title;
  final Widget? leading;

  static const _items = [
    (Icons.calendar_month_outlined, Icons.calendar_month, 'Balades', '/admin?variant=B'),
    (Icons.receipt_long_outlined, Icons.receipt_long, 'Réservations', '/admin/reservations?variant=B'),
    (Icons.groups_outlined, Icons.groups, 'Guides', '/admin/guides'),
  ];

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 1024;
    final topBar = Container(
      height: 56,
      decoration: const BoxDecoration(color: _surface, border: Border(bottom: BorderSide(color: _border))),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          ?leading,
          if (!desktop && leading == null) ...[const AppLogo(height: 28), const SizedBox(width: 10)],
          Expanded(child: Text(title, style: _t(16, weight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis)),
          IconButton(tooltip: 'Voir le site public', onPressed: () => context.go('/balades'), icon: const Icon(Icons.open_in_new, size: 20, color: _muted)),
        ],
      ),
    );
    if (desktop) {
      return Scaffold(
        backgroundColor: _bg,
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: _surface,
              selectedIndex: index,
              labelType: NavigationRailLabelType.all,
              indicatorColor: const Color(0xffe3f4ea),
              leading: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: AppLogo(height: 34)),
              onDestinationSelected: (i) => context.go(_items[i].$4),
              destinations: [for (final it in _items) NavigationRailDestination(icon: Icon(it.$1), selectedIcon: Icon(it.$2, color: _green), label: Text(it.$3, style: _t(12)))],
            ),
            const VerticalDivider(width: 1, color: _border),
            Expanded(child: Column(children: [topBar, Expanded(child: child)])),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(bottom: false, child: Column(children: [topBar, Expanded(child: child)])),
      bottomNavigationBar: NavigationBar(
        backgroundColor: _surface,
        height: 64,
        indicatorColor: const Color(0xffe3f4ea),
        selectedIndex: index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (i) => context.go(_items[i].$4),
        destinations: [for (final it in _items) NavigationDestination(icon: Icon(it.$1), selectedIcon: Icon(it.$2, color: _green), label: it.$3)],
      ),
    );
  }
}

// ————————————————————————————————— Feuille de balade —————————————————————————————————

class VariantBSheet extends ConsumerStatefulWidget {
  const VariantBSheet({super.key, required this.rambleId});

  final int rambleId;

  @override
  ConsumerState<VariantBSheet> createState() => _VariantBSheetState();
}

class _VariantBSheetState extends ConsumerState<VariantBSheet> {
  final presence = PresenceController();
  int tab = 0;

  @override
  void dispose() {
    presence.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(protoSheetProvider(widget.rambleId));
    return _ShellB(
      index: 0,
      title: async.valueOrNull?.ramble.title ?? 'Balade',
      leading: IconButton(onPressed: () => context.go('/admin?variant=B'), icon: const Icon(Icons.arrow_back, size: 20)),
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
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SummaryStrip(sheet: sheet, presence: presence),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _Panel(child: _ReservationTable(sheet: sheet, presence: presence, wide: true))),
                const SizedBox(width: 16),
                Expanded(child: _Panel(child: _Facts(sheet: sheet))),
              ],
            ),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 150),
      children: [
        _SummaryStrip(sheet: sheet, presence: presence),
        const SizedBox(height: 12),
        SegmentedButton<int>(
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(selectedBackgroundColor: _text, selectedForegroundColor: Colors.white, backgroundColor: _surface, side: const BorderSide(color: _border)),
          segments: [
            ButtonSegment(value: 0, label: Text('Participants (${sheet.placesTaken})')),
            const ButtonSegment(value: 1, label: Text('Balade')),
          ],
          selected: {tab},
          onSelectionChanged: (s) => setState(() => tab = s.first),
        ),
        const SizedBox(height: 12),
        _Panel(child: tab == 0 ? _ReservationTable(sheet: sheet, presence: presence, wide: false) : _Facts(sheet: sheet)),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
    child: child,
  );
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.sheet, required this.presence});

  final ProtoSheet sheet;
  final PresenceController presence;

  @override
  Widget build(BuildContext context) {
    final r = sheet.ramble;
    final coming = sheet.comingParticipants;
    final present = coming.where((p) => presence.isPresent(p.id)).length;
    Widget stat(String value, String label, {Color color = _text}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: _t(20, weight: FontWeight.w800, color: color)), Text(label, style: _t(11.5, color: _muted))]),
    );
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Wrap(
              spacing: 14,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('${frLongDate(r.date)} · ${frTime(r.date)}', style: _t(13.5, weight: FontWeight.w700)),
                InkWell(
                  onTap: () => openMaps(context, r),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.place_outlined, size: 15, color: _green),
                      const SizedBox(width: 3),
                      ConstrainedBox(constraints: const BoxConstraints(maxWidth: 260), child: Text(r.meetingPoint ?? r.location ?? 'RDV à préciser', style: _t(13, color: _green).copyWith(decoration: TextDecoration.underline), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                stat('${sheet.placesTaken}/${r.maxParticipants ?? '∞'}', 'places prises'),
                stat('${sheet.count('confirmed')}', 'confirmées', color: const Color(0xff0b6b3a)),
                stat('${sheet.count('pending')}', 'à confirmer', color: const Color(0xff8a5a00)),
                stat('${sheet.count('cancelled')}', 'annulées', color: const Color(0xff9d2b1d)),
                stat('$present/${coming.length}', 'présents', color: _green),
              ],
            ),
          ),
          const Divider(height: 1, color: _border),
          InkWell(
            onTap: presence.toggleNetwork,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  Icon(presence.offline ? Icons.wifi_off : Icons.wifi, size: 15, color: presence.offline ? const Color(0xff8a5a00) : _green),
                  const SizedBox(width: 6),
                  Expanded(child: Text(presence.syncLabel, style: _t(12, color: _muted))),
                  Text('simuler réseau', style: _t(11, color: _muted)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationTable extends StatelessWidget {
  const _ReservationTable({required this.sheet, required this.presence, required this.wide});

  final ProtoSheet sheet;
  final PresenceController presence;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final rows = sheet.ordered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 8),
          child: Row(
            children: [
              Expanded(child: Text('Réservations', style: _t(14, weight: FontWeight.w800))),
              TextButton.icon(onPressed: () => protoSnack(context, 'export'), icon: const Icon(Icons.download, size: 16), label: const Text('Exporter')),
            ],
          ),
        ),
        if (wide)
          Container(
            color: _bg,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Expanded(flex: 4, child: Text('PERSONNE QUI RÉSERVE', style: _t(10.5, weight: FontWeight.w800, color: _muted))),
                SizedBox(width: 140, child: Text('STATUT', style: _t(10.5, weight: FontWeight.w800, color: _muted))),
                SizedBox(width: 120, child: Text('PAIEMENT', style: _t(10.5, weight: FontWeight.w800, color: _muted))),
                const SizedBox(width: 80),
              ],
            ),
          ),
        for (final r in rows) ...[
          const Divider(height: 1, color: _border),
          _ReservationRow(reservation: r, presence: presence, wide: wide),
        ],
      ],
    );
  }
}

class _ReservationRow extends StatelessWidget {
  const _ReservationRow({required this.reservation, required this.presence, required this.wide});

  final Reservation reservation;
  final PresenceController presence;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final r = reservation;
    final paid = r.amountPaid > 0 && r.amountDue <= 0;
    final active = r.status == 'confirmed' || r.status == 'pending';
    final pay = Text(paid ? '✓ Payé ${formatCents(r.amountPaid)}' : formatReservationAmount(r), style: _t(12.5, weight: FontWeight.w700, color: paid ? _green : _muted));
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(visualDensity: VisualDensity.compact, tooltip: 'Appeler', onPressed: () => callBooker(context, r), icon: const Icon(Icons.call_outlined, size: 19, color: _muted)),
        IconButton(visualDensity: VisualDensity.compact, tooltip: 'Écrire', onPressed: () => emailBooker(r), icon: const Icon(Icons.mail_outline, size: 19, color: _muted)),
      ],
    );
    final who = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(bookerName(r), style: _t(14, weight: FontWeight.w700, color: active ? _text : _muted), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(r.contactEmail, style: _t(12, color: _muted), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
    return Opacity(
      opacity: active ? 1 : 0.6,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (wide)
              Row(
                children: [
                  Expanded(flex: 4, child: who),
                  SizedBox(width: 140, child: Align(alignment: Alignment.centerLeft, child: StatusTap(reservation: r, child: _Badge(r.status)))),
                  SizedBox(width: 120, child: pay),
                  SizedBox(width: 80, child: actions),
                ],
              )
            else ...[
              Row(children: [Expanded(child: who), actions]),
              const SizedBox(height: 4),
              Row(children: [StatusTap(reservation: r, child: _Badge(r.status)), const SizedBox(width: 10), Expanded(child: pay)]),
            ],
            const SizedBox(height: 6),
            for (final p in r.participants)
              InkWell(
                onTap: active ? () => presence.toggle(p.id) : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 36,
                        height: 34,
                        child: active
                            ? Checkbox(value: presence.isPresent(p.id), activeColor: _green, visualDensity: VisualDensity.compact, onChanged: (_) => presence.toggle(p.id))
                            : const Icon(Icons.remove, size: 14, color: _muted),
                      ),
                      Expanded(child: Text('${p.firstName} ${p.lastName}', style: _t(13.5), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(p.priceMissing ? 'tarif à préciser' : '${p.priceLabel} · ${formatEuros(p.priceAmount)}', style: _t(12, color: p.priceMissing ? const Color(0xff8a5a00) : _muted)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.sheet});

  final ProtoSheet sheet;

  @override
  Widget build(BuildContext context) {
    final r = sheet.ramble;
    Widget row(String k, String v) => Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 110, child: Text(k, style: _t(12.5, color: _muted))),
              Expanded(child: Text(v, style: _t(13.5))),
            ],
          ),
        ),
        const Divider(height: 1, color: _border),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 8),
          child: Row(
            children: [
              Expanded(child: Text('La balade', style: _t(14, weight: FontWeight.w800))),
              OutlinedButton(onPressed: () => protoSnack(context, 'modifier'), style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact), child: const Text('Modifier')),
              PopupMenuButton<String>(
                tooltip: 'Plus d\'actions',
                icon: const Icon(Icons.more_vert, size: 20),
                onSelected: (v) => switch (v) {
                  'cancel' => confirmCancelRamble(context),
                  _ => protoSnack(context, v),
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'dupliquer', child: Text('Dupliquer')),
                  PopupMenuItem(value: 'export', child: Text('Exporter les participants')),
                  PopupMenuDivider(),
                  PopupMenuItem(value: 'cancel', child: Text('Annuler la balade…', style: TextStyle(color: Color(0xff9d2b1d)))),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: _border),
        row('Statut', publicationState(r).$1),
        row('Guide', guideNames(r)),
        row('Durée', durationLabel(r.estimatedDuration).isEmpty ? '—' : durationLabel(r.estimatedDuration)),
        row('Capacité', r.maxParticipants == null ? 'Illimitée' : '${r.maxParticipants} places'),
        row('Tarifs', r.prices.map((p) => '${p.label} ${formatEuros(p.amount)}').join('\n')),
        if ((r.equipmentNeeded ?? '').isNotEmpty) row('Équipement', r.equipmentNeeded!),
        if ((r.prerequisites ?? '').isNotEmpty) row('Conditions', r.prerequisites!),
        if ((r.description ?? '').isNotEmpty) Padding(padding: const EdgeInsets.all(14), child: Text(r.description!, style: _t(13, color: _muted))),
      ],
    );
  }
}

// ————————————————————————————————— Liste des balades —————————————————————————————————

class VariantBList extends ConsumerWidget {
  const VariantBList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(protoRamblesProvider);
    final desktop = MediaQuery.sizeOf(context).width >= 1024;
    return _ShellB(
      index: 0,
      title: 'Balades',
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: _green)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (rambles) {
          final groups = groupByPeriod(rambles);
          return ListView(
            padding: EdgeInsets.fromLTRB(desktop ? 28 : 12, 16, desktop ? 28 : 12, 150),
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Rechercher',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        isDense: true,
                        filled: true,
                        fillColor: _surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _border)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _border)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: _green), onPressed: () => protoSnack(context, 'nouvelle balade'), icon: const Icon(Icons.add, size: 18), label: Text(desktop ? 'Nouvelle balade' : 'Nouvelle')),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final f in ['À venir', 'Publiées', 'Brouillons', 'Annulées', 'Tous les guides ▾', 'Tous les types ▾'])
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(f, style: _t(12.5)),
                          selected: f == 'À venir',
                          showCheckmark: false,
                          selectedColor: const Color(0xffe3f4ea),
                          backgroundColor: _surface,
                          side: const BorderSide(color: _border),
                          onSelected: (_) => protoSnack(context, 'filtre'),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (desktop)
                      Container(
                        color: _bg,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        child: Row(
                          children: [
                            SizedBox(width: 130, child: Text('DATE', style: _t(10.5, weight: FontWeight.w800, color: _muted))),
                            Expanded(child: Text('BALADE', style: _t(10.5, weight: FontWeight.w800, color: _muted))),
                            SizedBox(width: 140, child: Text('GUIDE', style: _t(10.5, weight: FontWeight.w800, color: _muted))),
                            SizedBox(width: 150, child: Text('PLACES', style: _t(10.5, weight: FontWeight.w800, color: _muted))),
                            SizedBox(width: 100, child: Text('STATUT', style: _t(10.5, weight: FontWeight.w800, color: _muted))),
                          ],
                        ),
                      ),
                    for (final period in Period.values)
                      if (groups[period] != null) ...[
                        Container(
                          color: const Color(0xfffafbfa),
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                          child: Text('${periodLabel(period).toUpperCase()} · ${groups[period]!.length}', style: _t(11, weight: FontWeight.w800, color: _green).copyWith(letterSpacing: 0.8)),
                        ),
                        for (final r in groups[period]!) ...[const Divider(height: 1, color: _border), _RambleRowB(ramble: r, wide: desktop)],
                      ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RambleRowB extends StatelessWidget {
  const _RambleRowB({required this.ramble, required this.wide});

  final Ramble ramble;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final r = ramble;
    final state = publicationState(r);
    final max = r.maxParticipants;
    final taken = takenOf(r);
    final gauge = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 60,
          child: ClipRRect(borderRadius: BorderRadius.circular(2), child: LinearProgressIndicator(value: max == null || max == 0 ? 0 : taken / max, minHeight: 4, color: taken == max ? const Color(0xff8a5a00) : _green, backgroundColor: _border)),
        ),
        const SizedBox(width: 6),
        Text(max == null ? '—' : '$taken/$max', style: _t(12.5, weight: FontWeight.w700)),
      ],
    );
    final status = Text('● ${state.$1}', style: _t(12, weight: FontWeight.w700, color: state.$2));
    return InkWell(
      onTap: () => context.go('/admin/balade/${r.id}?variant=B'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: wide
            ? Row(
                children: [
                  SizedBox(width: 130, child: Text('${frShortDate(r.date)} · ${frTime(r.date)}', style: _t(13, weight: FontWeight.w700))),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.title, style: _t(14, weight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(r.location ?? '', style: _t(12, color: _muted), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  SizedBox(width: 140, child: Text(guideNames(r), style: _t(13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  SizedBox(width: 150, child: gauge),
                  SizedBox(width: 100, child: status),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: 46,
                    child: Column(
                      children: [
                        Text('${r.date?.day ?? '–'}', style: _t(18, weight: FontWeight.w800)),
                        Text(frShortDate(r.date).split(' ').last, style: _t(11, color: _muted)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.title, style: _t(14, weight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('${frTime(r.date)} · ${guideNames(r)}', style: _t(12, color: _muted), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(children: [gauge, const SizedBox(width: 12), status]),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: _muted),
                ],
              ),
      ),
    );
  }
}

// ————————————————————————————————— Réservations —————————————————————————————————

class VariantBReservations extends ConsumerStatefulWidget {
  const VariantBReservations({super.key});

  @override
  ConsumerState<VariantBReservations> createState() => _VariantBReservationsState();
}

class _VariantBReservationsState extends ConsumerState<VariantBReservations> {
  String? status;
  final Set<int> selected = {};

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(protoReservationsProvider);
    final desktop = MediaQuery.sizeOf(context).width >= 1024;
    return _ShellB(
      index: 1,
      title: 'Réservations',
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: _green)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (all) {
          final list = status == null ? all : all.where((r) => r.status == status).toList();
          Widget stat(String label, int n, String? s, Color color) => Expanded(
            child: InkWell(
              onTap: () => setState(() => status = s),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: status == s ? _green : Colors.transparent, width: 3))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('$n', style: _t(22, weight: FontWeight.w800, color: color)), Text(label, style: _t(12.5, color: _muted))]),
              ),
            ),
          );
          final search = TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher une personne, un email, une balade',
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              filled: true,
              fillColor: _surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _border)),
            ),
          );
          if (desktop) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 96),
              children: [
                _Panel(
                  child: Row(
                    children: [
                      stat('Toutes', all.length, null, _text),
                      stat('Confirmées', all.where((r) => r.status == 'confirmed').length, 'confirmed', const Color(0xff0b6b3a)),
                      stat('À confirmer', all.where((r) => r.status == 'pending').length, 'pending', const Color(0xff8a5a00)),
                      stat('Liste d\'attente', all.where((r) => r.status == 'waiting_list').length, 'waiting_list', const Color(0xff34557a)),
                      stat('Annulées', all.where((r) => r.status == 'cancelled').length, 'cancelled', const Color(0xff9d2b1d)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: search),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(onPressed: () => protoSnack(context, 'filtre balade'), icon: const Icon(Icons.filter_list, size: 18), label: const Text('Toutes les balades')),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(onPressed: () => protoSnack(context, 'export'), icon: const Icon(Icons.download, size: 18), label: const Text('Exporter')),
                  ],
                ),
                const SizedBox(height: 14),
                _Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (selected.isNotEmpty)
                        Container(
                          color: const Color(0xffe3f4ea),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          child: Row(
                            children: [
                              Text('${selected.length} sélectionnée${selected.length > 1 ? 's' : ''}', style: _t(13, weight: FontWeight.w700)),
                              const Spacer(),
                              TextButton(onPressed: () => protoSnack(context, 'confirmer'), child: const Text('Confirmer')),
                              TextButton(onPressed: () => protoSnack(context, 'écrire'), child: const Text('Écrire')),
                              TextButton(onPressed: () => protoSnack(context, 'annuler'), child: const Text('Annuler', style: TextStyle(color: Color(0xff9d2b1d)))),
                            ],
                          ),
                        ),
                      Container(
                        color: _bg,
                        padding: const EdgeInsets.fromLTRB(4, 6, 14, 6),
                        child: Row(
                          children: [
                            const SizedBox(width: 44),
                            Expanded(flex: 4, child: Text('PERSONNE QUI RÉSERVE', style: _t(10.5, weight: FontWeight.w800, color: _muted))),
                            Expanded(flex: 4, child: Text('BALADE', style: _t(10.5, weight: FontWeight.w800, color: _muted))),
                            Expanded(flex: 1, child: Text('PERS.', style: _t(10.5, weight: FontWeight.w800, color: _muted))),
                            Expanded(flex: 2, child: Text('STATUT', style: _t(10.5, weight: FontWeight.w800, color: _muted))),
                            Expanded(flex: 2, child: Text('PAIEMENT', style: _t(10.5, weight: FontWeight.w800, color: _muted), textAlign: TextAlign.right)),
                          ],
                        ),
                      ),
                      for (final r in list.take(60)) ...[
                        const Divider(height: 1, color: _border),
                        InkWell(
                          onTap: () => _detailB(context, r),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 4, 14, 4),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 44,
                                  child: Checkbox(
                                    value: selected.contains(r.id),
                                    activeColor: _green,
                                    onChanged: (_) => setState(() => selected.contains(r.id) ? selected.remove(r.id) : selected.add(r.id)),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(bookerOf(r), style: _t(13.5, weight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      Text(r.contactEmail, style: _t(12, color: _muted), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(rambleOf(r), style: _t(13.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      Text(rambleDateOf(r), style: _t(12, color: _muted)),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 1, child: Text('${r.participants.length}', style: _t(13.5))),
                                Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: StatusTap(reservation: r, child: _Badge(r.status)))),
                                Expanded(
                                  flex: 2,
                                  child: Text(reservationPayLabel(r), textAlign: TextAlign.right, style: _t(13, weight: FontWeight.w700, color: isPaid(r) ? _green : _muted)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 150),
            children: [
              Row(
                children: [
                  Expanded(child: search),
                  const SizedBox(width: 8),
                  IconButton.outlined(onPressed: () => _filters(context), icon: Badge(isLabelVisible: status != null, child: const Icon(Icons.filter_list))),
                ],
              ),
              const SizedBox(height: 10),
              Text('${list.length} réservations${status == null ? '' : ' · ${statusLabel(status!)}'}', style: _t(12.5, color: _muted)),
              const SizedBox(height: 8),
              _Panel(
                child: Column(
                  children: [
                    for (final (i, r) in list.take(60).indexed) ...[
                      if (i > 0) const Divider(height: 1, color: _border),
                      InkWell(
                        onTap: () => _detailB(context, r),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(bookerOf(r), style: _t(14.5, weight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  StatusTap(reservation: r, child: _Badge(r.status)),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Expanded(child: Text('${rambleOf(r)} · ${rambleDateOf(r)}', style: _t(12.5, color: _muted), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  const SizedBox(width: 8),
                                  Text('${r.participants.length} pers. · ', style: _t(12.5, color: _muted)),
                                  Text(reservationPayLabel(r), style: _t(12.5, weight: FontWeight.w700, color: isPaid(r) ? _green : _muted)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _filters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: _surface,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 8), child: Text('Statut', style: _t(15, weight: FontWeight.w800))),
            for (final s in [null, ...reservationStatuses])
              RadioListTile<String?>(
                value: s,
                groupValue: status,
                activeColor: _green,
                dense: true,
                title: Text(s == null ? 'Toutes' : statusLabel(s), style: _t(14)),
                onChanged: (v) {
                  setState(() => status = v);
                  Navigator.pop(ctx);
                },
              ),
            ListTile(dense: true, leading: const Icon(Icons.calendar_month_outlined), title: Text('Balade : toutes', style: _t(14)), trailing: const Icon(Icons.chevron_right), onTap: () => protoSnack(context, 'choisir une balade')),
          ],
        ),
      ),
    );
  }
}

void _detailB(BuildContext context, Reservation r) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: _surface,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [Expanded(child: Text(bookerOf(r), style: _t(18, weight: FontWeight.w800))), StatusTap(reservation: r, child: _Badge(r.status))]),
          Text(r.contactEmail, style: _t(13, color: _muted)),
          Align(alignment: Alignment.centerLeft, child: ChangeStatusButton(reservation: r, color: _green)),
          const SizedBox(height: 12),
          const Divider(height: 1, color: _border),
          for (final (k, v) in [
            ('Balade', rambleOf(r)),
            ('Date', rambleDateOf(r)),
            ('Participants', r.participants.map((p) => '${p.firstName} ${p.lastName} (${p.priceMissing ? 'tarif ?' : p.priceLabel})').join('\n')),
            ('Paiement', reservationPayLabel(r)),
          ]) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 100, child: Text(k, style: _t(12.5, color: _muted))), Expanded(child: Text(v, style: _t(13.5)))]),
            ),
            const Divider(height: 1, color: _border),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              IconButton.outlined(tooltip: 'Appeler', onPressed: () => callBooker(context, r), icon: const Icon(Icons.call_outlined)),
              const SizedBox(width: 8),
              IconButton.outlined(tooltip: 'Écrire', onPressed: () => emailBooker(r), icon: const Icon(Icons.mail_outline)),
              const SizedBox(width: 8),
              Expanded(child: FilledButton(style: FilledButton.styleFrom(backgroundColor: _green), onPressed: () => context.go('/admin/balade/${r.rambleId}?variant=B'), child: const Text('Ouvrir la balade'))),
            ],
          ),
        ],
      ),
    ),
  );
}

// PROTOTYPE — throwaway. Visual directions for the espace de gestion, on the existing
// /admin/balade/:id route (and /admin list, /admin/reservations), switchable via ?variant=.
//
// Variant D — "Clair & vert": B's clarity (density, divider rows, numbers strip, tables, segmented
// tabs, key/value panel) with C's identity (deep green rail and bottom nav, strong green page
// headers, the balade photo in a short header), large touch targets for the roll-call, and a green
// calendar-date block in the balades list.

import 'package:balade/core/widgets/app_logo.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'prototype_data.dart';

const _bg = Color(0xfff4f7f5);
const _surface = Colors.white;
const _border = Color(0xffe0e6e2);
const _text = Color(0xff17201b);
const _muted = Color(0xff637068);
const _green = Color(0xff006d41);
const _deep = Color(0xff00341d);
const _mint = Color(0xffdff2e7);

TextStyle _t(double size, {FontWeight weight = FontWeight.w400, Color color = _text}) => GoogleFonts.lato(fontSize: size, fontWeight: weight, color: color, height: 1.3);

bool _desktop(BuildContext context) => MediaQuery.sizeOf(context).width >= 1024;

class _Badge extends StatelessWidget {
  const _Badge(this.status);

  final String status;

  @override
  Widget build(BuildContext context) {
    final fg = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: fg.withValues(alpha: 0.11), borderRadius: BorderRadius.circular(4)),
      child: Text(statusLabel(status), style: _t(11.5, weight: FontWeight.w800, color: fg)),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
    clipBehavior: Clip.antiAlias,
    child: child,
  );
}

Widget _colHead(String s, {TextAlign align = TextAlign.left}) => Text(s, textAlign: align, style: _t(10.5, weight: FontWeight.w800, color: _muted).copyWith(letterSpacing: 0.4));

// ————————————————————————————————— Shell —————————————————————————————————

class _ShellD extends ConsumerWidget {
  const _ShellD({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(permissionProvider)?.isAdmin() == true;
    final items = [
      (Icons.landscape_outlined, Icons.landscape, 'Balades', '/admin?variant=D'),
      (Icons.receipt_long_outlined, Icons.receipt_long, 'Réservations', '/admin/reservations?variant=D'),
      isAdmin ? (Icons.groups_outlined, Icons.groups, 'Guides', '/admin/guides') : (Icons.account_circle_outlined, Icons.account_circle, 'Profil', '/admin/mon-profil'),
    ];
    if (_desktop(context)) {
      return Scaffold(
        backgroundColor: _bg,
        body: Row(
          children: [
            Container(
              width: 92,
              color: _deep,
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: const AppLogo(height: 30)),
                  const SizedBox(height: 24),
                  for (var i = 0; i < items.length; i++)
                    InkWell(
                      onTap: () => context.go(items[i].$4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(color: i == index ? Colors.white.withValues(alpha: 0.16) : null, borderRadius: BorderRadius.circular(16)),
                              child: Icon(i == index ? items[i].$2 : items[i].$1, color: i == index ? Colors.white : Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(items[i].$3, style: _t(11, color: i == index ? Colors.white : Colors.white70, weight: FontWeight.w700)),
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
      bottomNavigationBar: NavigationBar(
        backgroundColor: _deep,
        indicatorColor: Colors.white.withValues(alpha: 0.16),
        selectedIndex: index,
        height: 64,
        onDestinationSelected: (i) => context.go(items[i].$4),
        labelTextStyle: WidgetStatePropertyAll(_t(12, color: Colors.white, weight: FontWeight.w700)),
        destinations: [for (final it in items) NavigationDestination(icon: Icon(it.$1, color: Colors.white70), selectedIcon: Icon(it.$2, color: Colors.white), label: it.$3)],
      ),
    );
  }
}

/// A strong green page header, with an optional row of stat chips.
class _GreenHeader extends StatelessWidget {
  const _GreenHeader({required this.title, this.subtitle, this.trailing, this.search, this.bottom});

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? search;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final pad = _desktop(context) ? 28.0 : 16.0;
    return Container(
      color: _deep,
      padding: EdgeInsets.fromLTRB(pad, MediaQuery.paddingOf(context).top + 16, pad, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: _t(22, weight: FontWeight.w800, color: Colors.white)),
                    if (subtitle != null) Text(subtitle!, style: _t(13, color: Colors.white70)),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
          if (search != null) ...[
            const SizedBox(height: 12),
            TextField(
              style: _t(14, color: Colors.white),
              decoration: InputDecoration(
                hintText: search,
                hintStyle: _t(14, color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.12),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
          ],
          if (bottom != null) ...[const SizedBox(height: 12), bottom!],
        ],
      ),
    );
  }
}

/// Large roll-call checkbox: a 48px touch target with a 28px rounded box.
class _PresenceBox extends StatelessWidget {
  const _PresenceBox({required this.present, required this.onTap});

  final bool present;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 26,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: present ? _green : _surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: present ? _green : const Color(0xffa9b5ae), width: 2),
            ),
            child: present ? const Icon(Icons.check, size: 20, color: Colors.white) : null,
          ),
        ),
      ),
    );
  }
}

// ————————————————————————————————— Feuille de balade —————————————————————————————————

class VariantDSheet extends ConsumerStatefulWidget {
  const VariantDSheet({super.key, required this.rambleId});

  final int rambleId;

  @override
  ConsumerState<VariantDSheet> createState() => _VariantDSheetState();
}

class _VariantDSheetState extends ConsumerState<VariantDSheet> {
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
    return _ShellD(
      index: 0,
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: _green)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (sheet) => ListenableBuilder(listenable: presence, builder: (context, _) => _body(context, sheet)),
      ),
    );
  }

  Widget _body(BuildContext context, ProtoSheet sheet) {
    final desktop = _desktop(context);
    if (desktop) {
      return ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          _PhotoHeader(sheet: sheet, height: 168),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 18, 28, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Numbers(sheet: sheet, presence: presence),
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
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 150),
      children: [
        _PhotoHeader(sheet: sheet, height: 150),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Numbers(sheet: sheet, presence: presence),
              const SizedBox(height: 12),
              SegmentedButton<int>(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(selectedBackgroundColor: _deep, selectedForegroundColor: Colors.white, backgroundColor: _surface, side: const BorderSide(color: _border)),
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
          ),
        ),
      ],
    );
  }
}

class _PhotoHeader extends StatelessWidget {
  const _PhotoHeader({required this.sheet, required this.height});

  final ProtoSheet sheet;
  final double height;

  @override
  Widget build(BuildContext context) {
    final r = sheet.ramble;
    final pad = _desktop(context) ? 28.0 : 16.0;
    return SizedBox(
      height: height + MediaQuery.paddingOf(context).top,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (coverUrl(r).isNotEmpty) Image.network(coverUrl(r), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: _deep)) else Container(color: _deep),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x8800341d), Color(0xf200341d)]),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(pad - 8, 4, pad, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: Colors.white, visualDensity: VisualDensity.compact),
                    onPressed: () => context.go('/admin?variant=D'),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: Text('Balades', style: _t(13, color: Colors.white, weight: FontWeight.w700)),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.title, style: _t(20, weight: FontWeight.w800, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 14,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.event, size: 15, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text('${frLongDate(r.date)} · ${frTime(r.date)}', style: _t(13, color: Colors.white, weight: FontWeight.w700)),
                              ],
                            ),
                            InkWell(
                              onTap: () => openMaps(context, r),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.place, size: 15, color: Color(0xff9fe3bd)),
                                  const SizedBox(width: 4),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 260),
                                    child: Text(
                                      r.meetingPoint ?? r.location ?? 'RDV à préciser',
                                      style: _t(13, color: const Color(0xff9fe3bd), weight: FontWeight.w700).copyWith(decoration: TextDecoration.underline, decorationColor: const Color(0xff9fe3bd)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

/// The numbers strip. It wraps on small screens instead of scrolling sideways.
class _Numbers extends StatelessWidget {
  const _Numbers({required this.sheet, required this.presence});

  final ProtoSheet sheet;
  final PresenceController presence;

  @override
  Widget build(BuildContext context) {
    final r = sheet.ramble;
    final coming = sheet.comingParticipants;
    final present = coming.where((p) => presence.isPresent(p.id)).length;
    final stats = [
      ('${sheet.placesTaken}/${r.maxParticipants ?? '∞'}', 'places prises', _text, false),
      ('$present/${coming.length}', 'présents', _green, true),
      ('${sheet.count('confirmed')}', 'confirmées', statusColor('confirmed'), false),
      ('${sheet.count('pending')}', 'à confirmer', statusColor('pending'), false),
      ('${sheet.count('cancelled')}', 'annulées', statusColor('cancelled'), false),
    ];
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, c) {
              final perRow = c.maxWidth < 600 ? 3 : 5;
              final w = c.maxWidth / perRow;
              return Wrap(
                children: [
                  for (final s in stats)
                    Container(
                      width: w,
                      color: s.$4 ? _mint : null,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.$1, style: _t(20, weight: FontWeight.w800, color: s.$3)),
                          Text(s.$2, style: _t(11.5, color: _muted)),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          const Divider(height: 1, color: _border),
          InkWell(
            onTap: presence.toggleNetwork,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  Icon(presence.offline ? Icons.wifi_off : Icons.wifi, size: 15, color: presence.offline ? statusColor('pending') : _green),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 6, 6),
          child: Row(
            children: [
              Expanded(child: Text('Réservations', style: _t(14, weight: FontWeight.w800))),
              TextButton.icon(style: TextButton.styleFrom(foregroundColor: _green), onPressed: () => protoSnack(context, 'export'), icon: const Icon(Icons.download, size: 16), label: const Text('Exporter')),
            ],
          ),
        ),
        if (wide)
          Container(
            color: _bg,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Expanded(flex: 4, child: _colHead('PERSONNE QUI RÉSERVE')),
                SizedBox(width: 150, child: _colHead('STATUT')),
                SizedBox(width: 120, child: _colHead('PAIEMENT')),
                const SizedBox(width: 84),
              ],
            ),
          ),
        for (final r in sheet.ordered) ...[
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
    final paid = isPaid(r);
    final active = r.status == 'confirmed' || r.status == 'pending';
    final pay = Text(paid ? '✓ Payé ${formatCents(r.amountPaid)}' : formatReservationAmount(r), style: _t(12.5, weight: FontWeight.w700, color: paid ? _green : _muted));
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(visualDensity: VisualDensity.compact, tooltip: 'Appeler', onPressed: () => callBooker(context, r), icon: const Icon(Icons.call_outlined, size: 20, color: _green)),
        IconButton(visualDensity: VisualDensity.compact, tooltip: 'Écrire', onPressed: () => emailBooker(r), icon: const Icon(Icons.mail_outline, size: 20, color: _green)),
      ],
    );
    final who = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(bookerName(r), style: _t(14.5, weight: FontWeight.w800, color: active ? _text : _muted), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(r.contactEmail, style: _t(12, color: _muted), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
    final badge = StatusTap(reservation: r, child: _Badge(r.status));
    return Container(
      color: active ? null : const Color(0xfffafbfa),
      padding: const EdgeInsets.fromLTRB(14, 10, 8, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (wide)
            Row(
              children: [
                Expanded(flex: 4, child: who),
                SizedBox(width: 150, child: Align(alignment: Alignment.centerLeft, child: badge)),
                SizedBox(width: 120, child: pay),
                SizedBox(width: 84, child: actions),
              ],
            )
          else ...[
            Row(children: [Expanded(child: who), actions]),
            const SizedBox(height: 4),
            Row(children: [badge, const SizedBox(width: 10), Expanded(child: pay)]),
          ],
          const SizedBox(height: 2),
          for (final p in r.participants)
            InkWell(
              onTap: active ? () => presence.toggle(p.id) : null,
              child: SizedBox(
                height: active ? 48 : 34,
                child: Row(
                  children: [
                    if (active)
                      Transform.translate(offset: const Offset(-10, 0), child: _PresenceBox(present: presence.isPresent(p.id), onTap: () => presence.toggle(p.id)))
                    else
                      const SizedBox(width: 38, child: Icon(Icons.remove, size: 14, color: _muted)),
                    Expanded(
                      child: Text(
                        '${p.firstName} ${p.lastName}',
                        style: _t(14.5, weight: presence.isPresent(p.id) ? FontWeight.w700 : FontWeight.w400, color: active ? _text : _muted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        p.priceMissing ? 'tarif à préciser' : '${p.priceLabel} · ${formatEuros(p.priceAmount)}',
                        style: _t(12, color: p.priceMissing ? statusColor('pending') : _muted),
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
              SizedBox(width: 104, child: Text(k, style: _t(12.5, color: _muted))),
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
          padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
          child: Row(
            children: [
              Expanded(child: Text('La balade', style: _t(14, weight: FontWeight.w800))),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: _deep, visualDensity: VisualDensity.compact),
                onPressed: () => protoSnack(context, 'modifier'),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Modifier'),
              ),
              PopupMenuButton<String>(
                tooltip: 'Plus d\'actions',
                icon: const Icon(Icons.more_vert, size: 20),
                onSelected: (v) => v == 'cancel' ? confirmCancelRamble(context) : protoSnack(context, v),
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

/// The calendar-date block: a green month band over the day.
class _DateBlock extends StatelessWidget {
  const _DateBlock({required this.date});

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: _green,
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(frShortDate(date).split(' ').last.toUpperCase(), textAlign: TextAlign.center, style: _t(10.5, weight: FontWeight.w800, color: Colors.white).copyWith(letterSpacing: 0.5)),
          ),
          Text('${date?.day ?? '–'}', style: _t(19, weight: FontWeight.w800, color: _deep)),
          Padding(padding: const EdgeInsets.only(bottom: 3), child: Text(frDayName(date), style: _t(10.5, color: _muted))),
        ],
      ),
    );
  }
}

class VariantDList extends ConsumerWidget {
  const VariantDList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(protoRamblesProvider);
    final desktop = _desktop(context);
    return _ShellD(
      index: 0,
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: _green)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (rambles) {
          final groups = groupByPeriod(rambles);
          final pad = desktop ? 28.0 : 12.0;
          return ListView(
            padding: const EdgeInsets.only(bottom: 150),
            children: [
              _GreenHeader(
                title: 'Balades',
                subtitle: '${rambles.length} à venir · ${rambles.fold<int>(0, (s, r) => s + takenOf(r))} participants inscrits',
                search: 'Rechercher une balade, un lieu, un guide',
                trailing: FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: _deep),
                  onPressed: () => protoSnack(context, 'nouvelle balade'),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(desktop ? 'Nouvelle balade' : 'Nouvelle'),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(pad, 12, pad, 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final f in ['À venir', 'Publiées', 'Brouillons', 'Annulées', 'Tous les guides ▾', 'Tous les types ▾'])
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilterChip(
                            label: Text(f, style: _t(12.5, weight: f == 'À venir' ? FontWeight.w800 : FontWeight.w400, color: f == 'À venir' ? _deep : _text)),
                            selected: f == 'À venir',
                            showCheckmark: false,
                            selectedColor: _mint,
                            backgroundColor: _surface,
                            side: const BorderSide(color: _border),
                            onSelected: (_) => protoSnack(context, 'filtre'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: pad),
                child: _Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (desktop)
                        Container(
                          color: _bg,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          child: Row(
                            children: [
                              SizedBox(width: 66, child: _colHead('DATE')),
                              Expanded(child: _colHead('BALADE')),
                              SizedBox(width: 140, child: _colHead('GUIDE')),
                              SizedBox(width: 150, child: _colHead('PLACES')),
                              SizedBox(width: 110, child: _colHead('STATUT')),
                            ],
                          ),
                        ),
                      for (final period in Period.values)
                        if (groups[period] != null) ...[
                          Container(
                            color: const Color(0xfff8faf9),
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                            child: Text('${periodLabel(period).toUpperCase()} · ${groups[period]!.length}', style: _t(11, weight: FontWeight.w800, color: _green).copyWith(letterSpacing: 0.8)),
                          ),
                          for (final r in groups[period]!) ...[const Divider(height: 1, color: _border), _RambleRowD(ramble: r, wide: desktop)],
                        ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RambleRowD extends StatelessWidget {
  const _RambleRowD({required this.ramble, required this.wide});

  final Ramble ramble;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final r = ramble;
    final state = publicationState(r);
    final max = r.maxParticipants;
    final taken = takenOf(r);
    final full = max != null && taken >= max;
    final gauge = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(value: max == null || max == 0 ? 0 : taken / max, minHeight: 5, color: full ? statusColor('pending') : _green, backgroundColor: _border),
          ),
        ),
        const SizedBox(width: 6),
        Text(max == null ? '—' : '$taken/$max', style: _t(12.5, weight: FontWeight.w800)),
      ],
    );
    final status = Text('● ${state.$1}', style: _t(12, weight: FontWeight.w800, color: state.$2));
    final thumb = ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: coverUrl(r).isEmpty
          ? Container(width: 40, height: 40, color: _mint)
          : Image.network(coverUrl(r), width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 40, height: 40, color: _mint)),
    );
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(r.title, style: _t(14.5, weight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(wide ? '${frTime(r.date)} · ${r.location ?? ''}' : '${frTime(r.date)} · ${r.location ?? ''} · ${guideNames(r)}', style: _t(12, color: _muted), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
    return InkWell(
      onTap: () => context.go('/admin/balade/${r.id}?variant=D'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: wide
            ? Row(
                children: [
                  SizedBox(width: 66, child: Align(alignment: Alignment.centerLeft, child: _DateBlock(date: r.date))),
                  thumb,
                  const SizedBox(width: 12),
                  Expanded(child: title),
                  SizedBox(width: 140, child: Text(guideNames(r), style: _t(13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  SizedBox(width: 150, child: gauge),
                  SizedBox(width: 110, child: status),
                ],
              )
            : Row(
                children: [
                  _DateBlock(date: r.date),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title,
                        const SizedBox(height: 6),
                        Row(children: [gauge, const SizedBox(width: 12), Flexible(child: status)]),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  thumb,
                ],
              ),
      ),
    );
  }
}

// ————————————————————————————————— Réservations —————————————————————————————————

class VariantDReservations extends ConsumerStatefulWidget {
  const VariantDReservations({super.key});

  @override
  ConsumerState<VariantDReservations> createState() => _VariantDReservationsState();
}

class _VariantDReservationsState extends ConsumerState<VariantDReservations> {
  String? status;
  final Set<int> selected = {};

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(protoReservationsProvider);
    final desktop = _desktop(context);
    return _ShellD(
      index: 1,
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(color: _green)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (all) {
          final list = status == null ? all : all.where((r) => r.status == status).toList();
          final pad = desktop ? 28.0 : 12.0;
          Widget chip(String label, String? s) {
            final n = s == null ? all.length : all.where((r) => r.status == s).length;
            final sel = status == s;
            return InkWell(
              onTap: () => setState(() => status = s),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: desktop ? 160 : null,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: sel ? Colors.white : Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$n', style: _t(desktop ? 20 : 16, weight: FontWeight.w800, color: sel ? _deep : Colors.white)),
                    const SizedBox(width: 6),
                    Flexible(child: Text(label, style: _t(12.5, weight: FontWeight.w700, color: sel ? _deep : Colors.white70), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            );
          }

          final header = _GreenHeader(
            title: 'Réservations',
            search: 'Personne qui réserve, email, balade',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (desktop)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white38)),
                    onPressed: () => protoSnack(context, 'filtre balade'),
                    icon: const Icon(Icons.filter_list, size: 18),
                    label: const Text('Toutes les balades'),
                  ),
                IconButton(tooltip: 'Exporter', onPressed: () => protoSnack(context, 'export'), icon: const Icon(Icons.download, color: Colors.white)),
              ],
            ),
            bottom: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [chip('Toutes', null), chip('Confirmées', 'confirmed'), chip('À confirmer', 'pending'), chip('Attente', 'waiting_list'), chip('Annulées', 'cancelled')],
            ),
          );

          if (desktop) {
            return ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                header,
                Padding(
                  padding: EdgeInsets.fromLTRB(pad, 16, pad, 0),
                  child: _Panel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (selected.isNotEmpty)
                          Container(
                            color: _mint,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            child: Row(
                              children: [
                                Text('${selected.length} sélectionnée${selected.length > 1 ? 's' : ''}', style: _t(13, weight: FontWeight.w800, color: _deep)),
                                const Spacer(),
                                TextButton(onPressed: () => protoSnack(context, 'changer le statut de la sélection'), child: const Text('Changer le statut')),
                                TextButton(onPressed: () => protoSnack(context, 'écrire'), child: const Text('Écrire')),
                              ],
                            ),
                          ),
                        Container(
                          color: _bg,
                          padding: const EdgeInsets.fromLTRB(4, 8, 14, 8),
                          child: Row(
                            children: [
                              const SizedBox(width: 44),
                              Expanded(flex: 4, child: _colHead('PERSONNE QUI RÉSERVE')),
                              Expanded(flex: 4, child: _colHead('BALADE')),
                              Expanded(flex: 1, child: _colHead('PERS.')),
                              Expanded(flex: 2, child: _colHead('STATUT')),
                              Expanded(flex: 2, child: _colHead('PAIEMENT', align: TextAlign.right)),
                            ],
                          ),
                        ),
                        for (final r in list.take(60)) ...[
                          const Divider(height: 1, color: _border),
                          InkWell(
                            onTap: () => _detailD(context, r),
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
                                        Text(bookerOf(r), style: _t(13.5, weight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
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
                                  Expanded(flex: 2, child: Text(reservationPayLabel(r), textAlign: TextAlign.right, style: _t(13, weight: FontWeight.w800, color: isPaid(r) ? _green : _muted))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 150),
            children: [
              header,
              Padding(
                padding: EdgeInsets.fromLTRB(pad, 10, pad, 8),
                child: Row(
                  children: [
                    Expanded(child: Text('${list.length} réservations${status == null ? '' : ' · ${statusLabel(status!)}'}', style: _t(12.5, color: _muted))),
                    TextButton.icon(style: TextButton.styleFrom(foregroundColor: _green), onPressed: () => _filters(context), icon: const Icon(Icons.tune, size: 18), label: const Text('Filtres')),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: pad),
                child: _Panel(
                  child: Column(
                    children: [
                      for (final (i, r) in list.take(60).indexed) ...[
                        if (i > 0) const Divider(height: 1, color: _border),
                        InkWell(
                          onTap: () => _detailD(context, r),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text(bookerOf(r), style: _t(14.5, weight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                    StatusTap(reservation: r, child: _Badge(r.status)),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Expanded(child: Text('${rambleOf(r)} · ${rambleDateOf(r)}', style: _t(12.5, color: _muted), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                    const SizedBox(width: 8),
                                    Text('${r.participants.length} pers. · ', style: _t(12.5, color: _muted)),
                                    Text(reservationPayLabel(r), style: _t(12.5, weight: FontWeight.w800, color: isPaid(r) ? _green : _muted)),
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
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filtres', style: _t(18, weight: FontWeight.w800)),
            const SizedBox(height: 12),
            Text('Statut', style: _t(12.5, weight: FontWeight.w800, color: _muted)),
            const SizedBox(height: 6),
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
            Text('Balade', style: _t(12.5, weight: FontWeight.w800, color: _muted)),
            const SizedBox(height: 6),
            OutlinedButton.icon(onPressed: () => protoSnack(context, 'choisir une balade'), icon: const Icon(Icons.landscape_outlined), label: const Text('Toutes les balades')),
          ],
        ),
      ),
    );
  }
}

void _detailD(BuildContext context, Reservation r) {
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
          Row(children: [Expanded(child: Text(bookerOf(r), style: _t(18, weight: FontWeight.w800))), _Badge(r.status)]),
          Text(r.contactEmail, style: _t(13, color: _muted)),
          Align(alignment: Alignment.centerLeft, child: ChangeStatusButton(reservation: r, color: _green)),
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
              IconButton.outlined(tooltip: 'Appeler', onPressed: () => callBooker(context, r), icon: const Icon(Icons.call_outlined, color: _green)),
              const SizedBox(width: 8),
              IconButton.outlined(tooltip: 'Écrire', onPressed: () => emailBooker(r), icon: const Icon(Icons.mail_outline, color: _green)),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: _deep),
                  onPressed: () => context.go('/admin/balade/${r.rambleId}?variant=D'),
                  child: const Text('Ouvrir la feuille de balade'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

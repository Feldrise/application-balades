import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/guides/providers/current_guide_provider.dart';
import 'package:balade/features/ramble/ramble_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'presence/presence_sync.dart';
import 'presence/roll_call.dart';
import 'ramble_sheet.dart';
import 'widgets/ramble_sheet_actions.dart';
import 'widgets/sheet_header.dart';
import 'widgets/sheet_ramble_panel.dart';
import 'widgets/sheet_reservations.dart';

/// The feuille de balade: who is coming first, the balade second. Tabs Participants / Balade on a phone and a tablet,
/// two columns on desktop.
class AdminRambleDetailsPage extends ConsumerStatefulWidget {
  const AdminRambleDetailsPage({super.key, required this.rambleId});

  final int rambleId;

  @override
  ConsumerState<AdminRambleDetailsPage> createState() => _AdminRambleDetailsPageState();
}

enum _Tab { participants, ramble }

class _AdminRambleDetailsPageState extends ConsumerState<AdminRambleDetailsPage> {
  _Tab _tab = _Tab.participants;

  /// The roll call is sent again when the app comes back to the foreground, often with the network.
  late final AppLifecycleListener _lifecycle;

  PresenceSync? _presence;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: () => _presence?.send());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _reload() => ref.invalidate(rambleSheetProvider(widget.rambleId));

  @override
  Widget build(BuildContext context) {
    final sheet = ref.watch(rambleSheetProvider(widget.rambleId));
    return sheet.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Column(
        children: [
          ManagementPageHeader(
            title: 'Feuille de balade',
            leading: IconButton(tooltip: 'Balades', onPressed: () => context.go('/admin'), icon: const Icon(Icons.arrow_back)),
          ),
          Expanded(
            child: Center(
              child: ManagementEmptyState(
                icon: Icons.cloud_off,
                title: 'Impossible de charger la balade',
                message: 'Vérifiez votre connexion puis réessayez.',
                action: FilledButton(onPressed: _reload, child: const Text('Réessayer')),
              ),
            ),
          ),
        ],
      ),
      data: _buildSheet,
    );
  }

  Widget _buildSheet(RambleSheet sheet) {
    final ramble = sheet.ramble;
    final permission = ref.watch(permissionProvider);
    final guideId = ref.watch(currentGuideProvider.select((s) => s.guide?.id));
    final canEdit = canManageRamble(permission, ramble, guideId);
    final canDuplicate = canEdit && canCreateBalade(permission, ref.watch(isFunctionalGuideProvider));
    final canCancel = !ramble.isCancelled && canDeleteRamble(permission, ramble, guideId);
    final presence = _presence = canMarkPresence(permission, ramble, guideId) ? ref.watch(presenceSyncProvider(widget.rambleId)) : null;
    final desktop = ManagementBreakpoints.isDesktop(context);
    final gutter = ManagementBreakpoints.gutter(context);

    final reservations = SheetReservations(sheet: sheet, wide: desktop, onChanged: _reload, presence: presence);
    final ramblePanel = SheetRamblePanel(ramble: ramble, canEdit: canEdit, canDuplicate: canDuplicate);

    return Column(
      children: [
        SheetHeader(
          ramble: ramble,
          actions: [
            PopupMenuButton<String>(
              tooltip: 'Plus d\'actions',
              icon: const Icon(Icons.more_horiz),
              onSelected: (action) async {
                switch (action) {
                  case 'export':
                    exportParticipants(context, sheet.reservations);
                  case 'emails':
                    copyBookerEmails(context, sheet.reservations);
                  case 'cancel':
                    if (await cancelRambleWithConfirmation(context, ref, ramble)) _reload();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'export',
                  child: ListTile(leading: Icon(Icons.download), title: Text('Exporter les participants')),
                ),
                const PopupMenuItem(
                  value: 'emails',
                  child: ListTile(leading: Icon(Icons.alternate_email), title: Text('Copier les emails')),
                ),
                if (canCancel) ...[
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'cancel',
                    child: ListTile(
                      leading: Icon(Icons.event_busy, color: ManagementColors.cancelled),
                      title: Text('Annuler la balade', style: TextStyle(color: ManagementColors.cancelled)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(rambleSheetProvider(widget.rambleId).future),
            child: ListView(
              padding: EdgeInsets.fromLTRB(gutter, 12, gutter, 32),
              children: [
                SheetNumbers(sheet: sheet, presence: presence),
                const SizedBox(height: 12),
                if (desktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: reservations),
                      const SizedBox(width: 16),
                      Expanded(child: ramblePanel),
                    ],
                  )
                else ...[
                  SegmentedButton<_Tab>(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: ManagementColors.deepGreen,
                      selectedForegroundColor: Colors.white,
                      backgroundColor: ManagementColors.surface,
                      side: const BorderSide(color: ManagementColors.border),
                    ),
                    segments: [
                      ButtonSegment(value: _Tab.participants, label: Text('Participants (${sheet.placesTaken})')),
                      const ButtonSegment(value: _Tab.ramble, label: Text('Balade')),
                    ],
                    selected: {_tab},
                    onSelectionChanged: (selection) => setState(() => _tab = selection.first),
                  ),
                  const SizedBox(height: 12),
                  if (_tab == _Tab.participants) reservations else ramblePanel,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

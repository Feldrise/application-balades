import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:flutter/material.dart';

class ReservationsStatsCards extends StatelessWidget {
  const ReservationsStatsCards({super.key, required this.reservations, required this.totalCount});

  final List<Reservation> reservations;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();

    return Row(
      children: [
        Expanded(child: _buildStatCard(context, 'Total réservations', totalCount.toString(), Icons.how_to_reg, Theme.of(context).colorScheme.primary)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(context, 'Confirmées', stats.confirmed.toString(), Icons.check_circle, Colors.green)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(context, 'En attente', stats.pending.toString(), Icons.schedule, Colors.orange)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(context, 'Liste d\'attente', stats.waitingList.toString(), Icons.queue, Colors.blue)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(context, 'Annulées', stats.cancelled.toString(), Icons.cancel, Colors.red)),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color),
                  ),
                  Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _ReservationStats _calculateStats() {
    int confirmed = 0;
    int pending = 0;
    int waitingList = 0;
    int cancelled = 0;

    for (final reservation in reservations) {
      switch (reservation.status) {
        case 'confirmed':
          confirmed++;
          break;
        case 'pending':
          pending++;
          break;
        case 'waiting_list':
          waitingList++;
          break;
        case 'cancelled':
          cancelled++;
          break;
      }
    }

    return _ReservationStats(confirmed: confirmed, pending: pending, waitingList: waitingList, cancelled: cancelled);
  }
}

class _ReservationStats {
  const _ReservationStats({required this.confirmed, required this.pending, required this.waitingList, required this.cancelled});

  final int confirmed;
  final int pending;
  final int waitingList;
  final int cancelled;
}

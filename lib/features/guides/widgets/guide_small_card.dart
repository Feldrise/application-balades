import 'package:balade/core/constants.dart';
import 'package:balade/features/guides/guides_service.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:flutter/material.dart';

class GuideSmallCard extends StatelessWidget {
  const GuideSmallCard({super.key, required this.guideId, this.onRemove, this.showRemoveButton = true});

  final int guideId;
  final VoidCallback? onRemove;
  final bool showRemoveButton;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder(
          future: GuidesService.instance.fetchGuide(guideId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Text('Error: ${snapshot.error}');
            }

            final Guide guide = snapshot.data!;

            return Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  backgroundImage: guide.avatar != null && guide.avatar!.isNotEmpty ? NetworkImage("$kBaseUrl/uploads/guide/$guideId/${guide.avatar!}") : null,
                  child: guide.avatar == null || guide.avatar!.isEmpty ? Icon(Icons.person, color: Theme.of(context).colorScheme.primary, size: 20) : null,
                ),

                const SizedBox(width: 12),

                // Guide info
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${guide.firstName} ${guide.lastName}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (guide.certificationLevel != null) ...[
                            Icon(kCertificationLevelIcons[guide.certificationLevel!], size: 14, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              kCertificationLevelLabels[guide.certificationLevel!] ?? '',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                          if (guide.specialties != null && guide.specialties!.isNotEmpty) ...[
                            if (guide.certificationLevel != null) const Text(' • '),
                            Expanded(
                              child: Text(guide.specialties!, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Remove button
                if (showRemoveButton && onRemove != null)
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.close),
                    iconSize: 18,
                    tooltip: 'Retirer ce guide',
                    style: IconButton.styleFrom(minimumSize: const Size(32, 32), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

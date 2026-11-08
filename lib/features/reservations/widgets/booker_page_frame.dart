import 'package:balade/features/admin/design/design.dart';
import 'package:flutter/material.dart';

/// The frame of the booker's pages in the public site: the green header of the management area over
/// the same light background, with [child] scrolling beneath it. The theme of the management area applies to the whole page.
class BookerPageFrame extends StatelessWidget {
  const BookerPageFrame({super.key, required this.title, this.subtitle, this.leading, this.actions = const [], required this.child, this.scrollable = true});

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final Widget child;

  /// Wraps [child] in a scroll view of readable width; turn off when [child] scrolls by itself.
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final gutter = ManagementBreakpoints.gutter(context);

    return Theme(
      data: managementTheme(Theme.of(context)),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: ManagementColors.background,
          body: Column(
            children: [
              ManagementPageHeader(title: title, subtitle: subtitle, leading: leading, actions: actions, linkToPublicSite: false),
              Expanded(
                child: scrollable
                    ? SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(gutter, 16, gutter, 24),
                        child: Center(
                          child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 720), child: child),
                        ),
                      )
                    : child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

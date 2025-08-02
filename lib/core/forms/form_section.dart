import 'package:flutter/material.dart';
import 'package:balade/core/forms/form_large_field.dart';
import 'package:balade/themes/screen_helper.dart';

class FormSection extends StatefulWidget {
  const FormSection({super.key, this.title, required this.children, this.actions = const [], this.isSmall = false});

  final String? title;
  final bool isSmall;

  final List<Widget> children;
  final List<Widget> actions;

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final List<Widget> _children = [];

  @override
  void initState() {
    super.initState();

    if (widget.children.length.isOdd) {
      _children.addAll([...widget.children, Container()]);
    } else {
      _children.addAll(widget.children);
    }
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if ((widget.title ?? "").isNotEmpty) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title!,
                      style: widget.isSmall ? Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold) : Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  ...widget.actions,
                ],
              ),
              SizedBox(height: widget.isSmall ? 12 : 24),
            ],

            // The form fields
            Builder(
              builder: (context) {
                final List<Widget> children = [];

                while (i < _children.length) {
                  if (i == _children.length - 1) {
                    children.add(_children[i]);
                  } else if (_children[i] is FormLargeField) {
                    i--;
                    children.add(_children[i + 1]);
                  } else if (_children[i + 1] is FormLargeField) {
                    i--;
                    children.add(
                      Flex(
                        direction: constraints.maxWidth > ScreenHelper.breakpointTablet ? Axis.horizontal : Axis.vertical,
                        crossAxisAlignment: constraints.maxWidth > ScreenHelper.breakpointTablet ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: constraints.maxWidth > ScreenHelper.breakpointTablet ? 1 : 0, child: _children[i + 1]),
                          const SizedBox(width: 20, height: 20),
                          Expanded(flex: constraints.maxWidth > ScreenHelper.breakpointTablet ? 1 : 0, child: Container()),
                        ],
                      ),
                    );
                  } else {
                    children.add(
                      Flex(
                        direction: constraints.maxWidth > ScreenHelper.breakpointTablet ? Axis.horizontal : Axis.vertical,
                        crossAxisAlignment: constraints.maxWidth > ScreenHelper.breakpointTablet ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: constraints.maxWidth > ScreenHelper.breakpointTablet ? 1 : 0, child: _children[i]),
                          const SizedBox(width: 20, height: 20),
                          Expanded(flex: constraints.maxWidth > ScreenHelper.breakpointTablet ? 1 : 0, child: _children[i + 1]),
                        ],
                      ),
                    );
                  }

                  children.add(const SizedBox(height: 20));
                  i += 2;
                }

                return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
              },
            ),
          ],
        );
      },
    );
  }
}

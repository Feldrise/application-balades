import 'dart:async';

import 'package:flutter/material.dart';

class SearchableDropdown<T extends Object> extends StatefulWidget {
  const SearchableDropdown({
    super.key,
    required this.optionsBuilder,
    required this.displayStringForOption,
    this.label,
    this.onSelected,
    this.onCreate,
    this.fakeOnCreate,
    this.isRequired = false,
    this.isEnabled = true,
    this.shouldResetOnTap = true,
    this.value,
  }); // TODO: shoud do assert here

  final String? label;
  final bool isRequired;
  final bool isEnabled;
  final bool shouldResetOnTap;

  final T? value;
  final FutureOr<Iterable<T>> Function(TextEditingValue) optionsBuilder;
  final String Function(T) displayStringForOption;
  final Function(T?)? onSelected;
  final Function(String)? onCreate;
  final T Function(String)? fakeOnCreate;

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T extends Object> extends State<SearchableDropdown<T>> {
  final TextEditingController _textEditingController = TextEditingController();

  late FocusNode _focusNode;
  List<T> _currentOptions = [];

  T? _currentValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _focusNode = FocusNode();
    if (widget.value == null) {
      _textEditingController.text = "";
    } else {
      _textEditingController.text = widget.displayStringForOption(widget.value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return RawAutocomplete<T>(
        textEditingController: _textEditingController,
        focusNode: _focusNode,
        onSelected: (option) {
          widget.onSelected?.call(option);
          _currentValue = option;
        },
        optionsBuilder: (textEditingValue) async {
          final List<T> options = (await widget.optionsBuilder(textEditingValue)).toList();

          if (widget.onCreate != null && textEditingValue.text.isNotEmpty) {
            options.add(widget.fakeOnCreate!(textEditingValue.text));
          }

          _currentOptions = options;

          return options;
        },
        displayStringForOption: widget.displayStringForOption,
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12.0),
                ),
                side: BorderSide(color: Colors.grey),
              ),
              color: Theme.of(context).colorScheme.surface,
              elevation: 6,
              child: SizedBox(
                height: 52.0 * options.length,
                width: constraints.biggest.width,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: false,
                  children: [
                    for (final option in options)
                      if (options.last == option && widget.onCreate != null && _textEditingController.text.isNotEmpty)
                        InkWell(
                          onTap: () {
                            widget.onCreate!(_textEditingController.text);
                            _focusNode.unfocus();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Créer "${_textEditingController.text}"'),
                          ),
                        )
                      else
                        InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(widget.displayStringForOption(option)),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          );
        },
        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) => TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          enabled: widget.isEnabled,
          onTap: () {
            if (widget.shouldResetOnTap) {
              setState(() {
                _textEditingController.text = "";
                widget.onSelected?.call(null);
                _currentValue = null;
              });
            }
          },
          onFieldSubmitted: (value) {
            if (_currentOptions.isNotEmpty) {
              final String optionString = widget.displayStringForOption(_currentOptions.first);
              if (_currentOptions.length == 1 && widget.onCreate != null) {
                widget.onCreate!(optionString);
              }
              widget.onSelected?.call(_currentOptions.first);
              _currentValue = _currentOptions.first;
              _textEditingController.text = optionString;
            }
          },
          decoration: InputDecoration(
              hintText: "${widget.label}...",
              labelText: widget.label,
              suffixIcon: const Icon(
                Icons.arrow_drop_down,
              )),
          validator: widget.isRequired
              ? (textValue) {
                  if (textValue == null || textValue.isEmpty) {
                    return "Ce champ est requis";
                  }

                  if (_currentValue == null) {
                    return "Aucun résultat trouvé";
                  }

                  return null;
                }
              : null,
        ),
      );
    });
  }
}

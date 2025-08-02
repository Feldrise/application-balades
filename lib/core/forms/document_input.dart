import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:balade/core/dialogs/size_limit_dialog.dart';

class DocumentFile {
  final String name;
  final Uint8List bytes;

  DocumentFile({required this.name, required this.bytes});
}

class DocumentInput extends StatefulWidget {
  const DocumentInput({super.key, this.documentFile, this.onChanged});

  final DocumentFile? documentFile;
  final Function(DocumentFile?)? onChanged;

  @override
  State<DocumentInput> createState() => _DocumentInputState();
}

class _DocumentInputState extends State<DocumentInput> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FilledButton(onPressed: _pickDocument, child: const Text("Choisir un fichier")),
        const SizedBox(width: 16),
        Text(widget.documentFile?.name ?? "Aucun fichier sélectionné"),
        if (widget.documentFile != null) ...[
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              widget.onChanged?.call(null);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ],
    );
  }

  Future<void> _pickDocument() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'], withData: true);

    if (result == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Uint8List bytes = result.files.single.bytes!;

    // We need to check the document doesn't exceed 5MB
    if (bytes.lengthInBytes > 5 * 1024 * 1024) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => const SizeLimitDialog(title: "Fichier trop volumineux", content: "Le fichier ne doit pas dépasser 5 Mo."),
        );
      }
    }

    final DocumentFile documentFile = DocumentFile(name: result.files.single.name, bytes: bytes);

    setState(() {
      _isLoading = false;
    });

    widget.onChanged?.call(documentFile);

    return;
  }
}

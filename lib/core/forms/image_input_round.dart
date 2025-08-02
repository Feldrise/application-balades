import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:balade/core/dialogs/size_limit_dialog.dart';
import 'package:balade/core/forms/image_input.dart';

class ImageInputRound extends StatefulWidget {
  const ImageInputRound({super.key, required this.networkImageUrl, this.imageFile, this.onChanged, this.size = 92});

  final String networkImageUrl;
  final ImageFile? imageFile;
  final Function(ImageFile?)? onChanged;

  final double size;

  @override
  State<ImageInputRound> createState() => _ImageInputRoundState();
}

class _ImageInputRoundState extends State<ImageInputRound> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(widget.size / 2),
                ),
                height: widget.size,
                width: widget.size,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.size / 2),
                  child: Builder(
                    builder: (context) {
                      if (_isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (widget.imageFile != null) {
                        return Image.memory(widget.imageFile!.bytes, fit: BoxFit.cover);
                      }

                      return Image.network(
                        widget.networkImageUrl,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.cloud_upload_outlined, color: Theme.of(context).colorScheme.surfaceContainer, size: widget.size * 0.7),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),

            // The button to change the image
            Positioned(
              top: 0,
              right: 0,
              child: IconButton.filled(onPressed: _pickImage, icon: const Icon(Icons.edit)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);

    if (result == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Uint8List bytes = result.files.single.bytes!;

    // We need to check the image doesn't exceed 5MB
    if (bytes.lengthInBytes > 5 * 1024 * 1024) {
      if (mounted) {
        await showDialog(context: context, builder: (context) => const SizeLimitDialog());
      }
      setState(() {
        _isLoading = false;
      });

      return;
    }

    final ImageFile imageFile = ImageFile(name: result.files.single.name, bytes: bytes);

    setState(() {
      _isLoading = false;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(imageFile);
    }
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:balade/core/dialogs/size_limit_dialog.dart';
import 'package:balade/themes/screen_helper.dart';

class ImageFile {
  final String name;
  final Uint8List bytes;

  ImageFile({required this.name, required this.bytes});
}

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.networkImageUrl, this.imageFile, this.onChanged, this.height = 217});

  final String networkImageUrl;
  final ImageFile? imageFile;
  final Function(ImageFile?)? onChanged;

  final double height;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      height: widget.height,
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
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
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.cloud_upload_outlined, color: Theme.of(context).colorScheme.surfaceContainer, size: 90),
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),

            // The button to change the image
            Positioned(
              bottom: 20,
              right: ScreenHelper.instance.horizontalPadding,
              left: ScreenHelper.instance.horizontalPadding,
              child: FilledButton(onPressed: _pickImage, child: const Text("Sélectionner une image")),
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

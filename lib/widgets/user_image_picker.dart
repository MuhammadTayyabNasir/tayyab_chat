import 'dart:typed_data'; // ADDED: This is needed for Uint8List.

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});
  final void Function(Uint8List? pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  // CHANGED: The state variable is now Uint8List?, not File?
  Uint8List? _pickedImageBytes;
  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    if (pickedImage == null) {
      return; // User canceled the picker
    }

    // CHANGED: Read the file as bytes instead of creating a File object.
    final imageBytes = await pickedImage.readAsBytes();

    setState(() {
      _pickedImageBytes = imageBytes;
    });
    widget.onPickImage(_pickedImageBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          // CHANGED: Use MemoryImage if bytes are available, otherwise use a null foregroundImage.
          foregroundImage: _pickedImageBytes != null ? MemoryImage(_pickedImageBytes!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage, // Simplified this
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
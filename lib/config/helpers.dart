import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dedaldev/config/config.dart';

Future<File?> pickImage(ImageSource imageSource) async {
  final _imagePicker = ImagePicker();

  final XFile? imageFile = await _imagePicker.pickImage(
    source: imageSource,
    maxHeight: 2340,
    maxWidth: 1080,
  );

  if (imageFile == null) return null;

  // convert XFile to File
  File tmpImageFile = File(imageFile.path);

  // get Filename of image
  final imageFileName = basename(imageFile.path);

  var appDir = await getApplicationDocumentsDirectory();

  // create a Folder contain images inside appDir
  var _imagesDir = Directory('${appDir.path}/images/');

  if (!await _imagesDir.exists()) {
    _imagesDir = await _imagesDir.create(recursive: true);
  }

  // copy image file to the images folder
  var newFile = await tmpImageFile.copy('${_imagesDir.path}/$imageFileName');

  return newFile;
}

Future refreshOrGetData(BuildContext context) async {
  await Provider.of<VehicleProvider>(context, listen: false).fetchAndSet();
}

Future deleteFile(File file) async {
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    throw 'file read error';
  }
}

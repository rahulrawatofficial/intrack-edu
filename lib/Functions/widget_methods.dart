// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';

//   ImageProvider provider;

// void getFileImage() async {
//     final img = AssetImage("img/img.jpg");
//     print("pre compress");
//     final config = new ImageConfiguration();

//     AssetBundleImageKey key = await img.obtainKey(config);
//     final ByteData data = await key.bundle.load(key.name);
//     final dir = await path_provider.getTemporaryDirectory();

//     File file = File("${dir.absolute.path}/test.png");
//     file.writeAsBytesSync(data.buffer.asUint8List());

//     final targetPath = dir.absolute.path + "/temp.jpg";
//     final imgFile = await testCompressAndGetFile(file, targetPath);

//     provider = FileImage(imgFile);
//   }

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

List<DropdownMenuItem<String>> getDropDownMenuItems(
    String title, List itemsList) {
  List<DropdownMenuItem<String>> items = new List();
  if (itemsList.length > 0) {
    for (String itemValue in itemsList) {
      items.add(new DropdownMenuItem(
          value: itemValue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              title != null
                  ? new Text(
                      title,
                      style: TextStyle(fontFamily: 'SourceSansPro'),
                    )
                  : Offstage(),
              new Text(
                itemValue,
                style: TextStyle(fontFamily: 'SourceSansPro'),
              ),
            ],
          )));
    }
    return items;
  } else {
    return [
      DropdownMenuItem(
          value: null,
          child: new Text(
            "No data available",
            style: TextStyle(fontFamily: 'SourceSansPro'),
          ))
    ];
  }
}

List<DropdownMenuItem<String>> getDropDownMenuItemsDisabled(
    String title, List itemsList) {
  List<DropdownMenuItem<String>> items = new List();
  if (itemsList.length > 0) {
    for (String itemValue in itemsList) {
      items.add(new DropdownMenuItem(
          value: itemValue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              title != null
                  ? new Text(
                      title,
                      style: TextStyle(
                          fontFamily: 'SourceSansPro', color: Colors.grey),
                    )
                  : Offstage(),
              new Text(
                itemValue,
                style:
                    TextStyle(fontFamily: 'SourceSansPro', color: Colors.grey),
              ),
            ],
          )));
    }
    return items;
  } else {
    return [
      DropdownMenuItem(
          value: null,
          child: new Text(
            "No data available",
            style: TextStyle(fontFamily: 'SourceSansPro', color: Colors.grey),
          ))
    ];
  }
}

// void changedDropDownItemGender(String selectedGender) {
//     print("Selected soil $selectedGender, we are going to refresh the UI");
//     setState(() {
//       currentGender = selectedGender;
//     });
//   }

//Show Date Picker

// void launchStartDate() async {
//     dateSelected = await selectDateFromPicker();
//   }

Future<DateTime> selectDateFromPicker(
    BuildContext context, DateTime dateSelected) async {
  DateTime cDate;
  cDate = await showDatePicker(
    context: context,
    initialDate: dateSelected,
    firstDate: DateTime.now().subtract(Duration(days: 1)),
    lastDate: DateTime(2100),
  );

  if (cDate != null) {
    return cDate;
  } else {
    return dateSelected;
  }
}

Future getImageCamera() async {
  var image = await ImagePicker.pickImage(
    source: ImageSource.camera,
    maxHeight: 1080,
    maxWidth: 720,
    imageQuality: 70,
  );
  if (image != null) {
    String imageFormat = image.path.split(".").last;
    String imageName = image.path.split("/").last;
    print(image.path);
    print(imageFormat);
    print(imageName);
    Map imageData = {
      "imageFile": image,
      "imageFormat": imageFormat,
      "imageName": imageName,
    };
    return imageData;
  } else
    return null;
}

//Upload files
Future openFileExplorer() async {
  String _extension = "";
  String path;
  try {
    path = await FilePicker.getFilePath(
        type: FileType.ANY, fileExtension: _extension);
  } on PlatformException catch (e) {
    print("Unsupported operation" + e.toString());
  }

  if (path != null) {
    print(path);
    String fileFormat = path.split(".").last;
    String fileName = path.split("/").last;
    print(fileFormat);
    print(fileName);
    Map fileData = {
      "filePath": path,
      "fileFormat": fileFormat,
      "fileName": fileName,
    };
    return fileData;
  } else {
    return null;
  }

  // setState(() {
  //   _fileName = _path != null ? _path.split('/').last : '...';
  //   // File f=File(path);
  //   File fl = _path != null ? File(_path) : null;
  //   List<int> imageBytes = _path != null ? fl.readAsBytesSync() : null;
  //   base64Image = _path != null ? base64Encode(imageBytes) : null;
  //   fileType = base64Image != null ? detectMimeType(base64Image) : null;
  // });
  // Navigator.pop(context);
}

//GET LOCATION
// Future<Map<String, double>> getLocation() async {
//   var location = new Location();
//   Map<String, double> loc;
//   LocationData currentLocation;

//   try {
//     currentLocation = (await location.getLocation());
//     loc = {
//       "latitude": currentLocation.latitude,
//       "longitude": currentLocation.longitude,
//     };
//     print(loc);
//   } catch (e) {
//     currentLocation = null;
//   }
//   return loc;
// }

//Get Location Name
// Future<Address> getLocationName(Map<String, double> loc) async {
//   final coordinates = new Coordinates(loc["latitude"], loc["longitude"]);
//   var addresses =
//       await Geocoder.local.findAddressesFromCoordinates(coordinates);
//   Address first = addresses.first;
//   // print("${first.featureName} : ${first.addressLine}");
//   return first;
// }

//Get Address Name
// Future<String> getAddressName(String latitude, String longitude) async {
//   final coordinates =
//       new Coordinates(double.parse(latitude), double.parse(longitude));
//   var addresses =
//       await Geocoder.local.findAddressesFromCoordinates(coordinates);
//   Address first = addresses.first;
//   // print("${first.featureName} : ${first.addressLine}");
//   return first.addressLine;
// }

Future getImageGallery() async {
  var image = await ImagePicker.pickImage(
    source: ImageSource.gallery,
    maxHeight: 1080,
    maxWidth: 720,
    imageQuality: 70,
  );
  if (image != null) {
    String imageFormat = image.path.split(".").last;
    String imageName = image.path.split("/").last;
    print(image.path);
    print(imageFormat);
    print(imageName);
    Map imageData = {
      "imageFile": image,
      "imageFormat": imageFormat,
      "imageName": imageName,
    };
    return imageData;
  } else
    return null;
}

// Future getVideoGallery() async {
//   PermissionHandler().requestPermissions(<PermissionGroup>[
//     PermissionGroup.storage,
//   ]);
//   // var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
//   File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
//   if (video != null) {
//     String videoFormat = video.path.split(".").last;
//     String videoName = video.path.split("/").last;
//     print(video.path);
//     print(videoFormat);
//     print(videoName);
//     Map videoData = {
//       "videoFile": video,
//       "videoFormat": videoFormat,
//       "videoName": videoName,
//     };
//     return videoData;
//   } else
//     return null;
// }

// Future<LocationData> getLocation() async {
//   Map<String, double> loc;
//   LocationData currentLocation;
//   var location = new Location();

//   try {
//     currentLocation = (await location.getLocation());
//     loc = {
//       "latitude": currentLocation.latitude,
//       "longitude": currentLocation.longitude,
//     };
//   } catch (e) {
//     currentLocation = null;
//   }
//   print(currentLocation.latitude);
//   return currentLocation;
// }

// Future<Address> getAddress() async {
//   Coordinates coordinates;
//   List<Address> address;
//   LocationData value = await getLocation();
//   coordinates = Coordinates(value.latitude, value.longitude);
//   address = await Geocoder.local.findAddressesFromCoordinates(coordinates);

//   // getLocation().then((val) async {
//   //   coordinates = Coordinates(val.latitude, val.longitude);
//   //   address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//   // });
//   return address[0];
//   // print(address[0].subLocality);
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tadbiro/data/services/yandex_map_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddEventWidget extends StatefulWidget {
  final Map<String, dynamic> event;
  const AddEventWidget({super.key, required this.event});

  @override
  State<AddEventWidget> createState() => _AddEventWidgetState();
}

class _AddEventWidgetState extends State<AddEventWidget> {
  final nameController = TextEditingController();
  final dayController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? addressName;
  File? file;
  bool isVideo = false;
  late YandexMapController mapController;
  List<MapObject>? polylines;
  final List<MapObject> mapObjects = [];

  Point myCurrentLocation = const Point(
    latitude: 41.2856806,
    longitude: 69.9034646,
  );

  Point najotTalim = const Point(
    latitude: 41.2856806,
    longitude: 69.2034646,
  );

  void onMapCreated(YandexMapController controller) async {
    mapController = controller;
    await mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: najotTalim,
          zoom: 16,
        ),
      ),
    );
    setState(() {});
  }

  void onCameraPositionChanged(
    CameraPosition position,
    CameraUpdateReason reason,
    bool finished,
  ) async {
    myCurrentLocation = position.target;

    if (finished) {
      polylines =
          await YandexMapService.getDirection(najotTalim, myCurrentLocation);
    }
    setState(() {});
  }

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
        isVideo = false;
      });
    }
  }

  void openVideoGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedFile = await imagePicker.pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
        isVideo = true;
      });
    }
  }

  Future<String> uploadFileToFirebase(File file, bool isVideo) async {
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child(
      isVideo
          ? 'event_videos/${DateTime.now().millisecondsSinceEpoch}.mp4'
          : 'event_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final uploadTask = fileRef.putFile(file);
    final snapshot = await uploadTask;
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        timeController.text = pickedTime.format(context);
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dayController.text = pickedDate.toString().split(' ')[0];
      });
    }
  }

  void _addEvent() async {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text;
      final day = dayController.text;
      final time = timeController.text;
      final description = descriptionController.text;

      final eventDateTime = DateTime.parse("$day $time");

      String fileUrl = '';
      if (file != null) {
        fileUrl = await uploadFileToFirebase(file!, isVideo);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(isVideo ? 'Video yuklandi!' : 'Rasm yuklandi!')),
        );
      }

      GeoPoint geoPoint =
          GeoPoint(myCurrentLocation.latitude, myCurrentLocation.longitude);

      await FirebaseFirestore.instance.collection('tadbiro').add({
        'name': name,
        'date': eventDateTime,
        'location': geoPoint,
        'description': description,
        'bannerUrl': fileUrl,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Tadbir Qo'shish",
          style: TextStyle(
            fontFamily: 'Extrag',
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Nomi",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "iltimos tadbir nomini kiriting";
                    }
                    return null;
                  },
                ),
                Gap(10.h),
                TextFormField(
                  controller: dayController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Kuni",
                    suffixIcon: GestureDetector(
                      onTap: _selectDate,
                      child: const Icon(Icons.date_range),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "iltimos tadbir kunini kiriting";
                    }
                    return null;
                  },
                ),
                Gap(10.h),
                TextFormField(
                  controller: timeController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Vaqti",
                    suffixIcon: GestureDetector(
                      onTap: _selectTime,
                      child: const Icon(Icons.timer),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "iltimos tadbir vaqtini kiriting";
                    }
                    return null;
                  },
                ),
                Gap(10.h),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(25),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Tadbir haqida malumot",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "iltimos tadbir malumotlarini kiriting";
                    }
                    return null;
                  },
                ),
                Gap(10.h),
                const Text("Rasm yoki video yuklash"),
                Gap(10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: openGallery,
                      child: Container(
                        width: 160.2,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.grey[700],
                              ),
                              Text(
                                "Rasm tanlash",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: openVideoGallery,
                      child: Container(
                        width: 160.2,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.video_library_outlined,
                                color: Colors.grey[700],
                              ),
                              Text(
                                "Video tanlash",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(10.h),
                file != null
                    ? isVideo
                        ? Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.file(
                                  file!,
                                  height: 200.h,
                                ),
                                const Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.amber,
                                  size: 60.0,
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Image.file(
                              file!,
                              height: 200.h,
                            ),
                          )
                    : const SizedBox.shrink(),
                Gap(20.h),
                SizedBox(
                  height: 250.h,
                  child: YandexMap(
                    gestureRecognizers: Set()
                      ..add(
                        Factory<EagerGestureRecognizer>(
                            () => EagerGestureRecognizer()),
                      ),
                    onMapCreated: onMapCreated,
                    onCameraPositionChanged: onCameraPositionChanged,
                    mapObjects: [
                      PlacemarkMapObject(
                        mapId: const MapObjectId("myCurrentLocation"),
                        point: myCurrentLocation,
                        icon: PlacemarkIcon.single(
                          PlacemarkIconStyle(
                            image: BitmapDescriptor.fromAssetImage(
                              "assets/images/place.png",
                            ),
                          ),
                        ),
                      ),
                      ...mapObjects,
                    ],
                  ),
                ),
                Gap(20.h),
                GestureDetector(
                  onTap: _addEvent,
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Tadbir qo'shish",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

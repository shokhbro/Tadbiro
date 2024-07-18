import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadbiro/bloc/tadbiro/tadbiro_bloc.dart';
import 'package:tadbiro/bloc/tadbiro/tadbiro_event.dart';
import 'package:tadbiro/bloc/tadbiro/tadbiro_state.dart';
import 'package:tadbiro/data/services/yandex_map_service.dart';
import 'package:tadbiro/ui/widgets/custom_snackbar_widget.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class EventDetails extends StatefulWidget {
  final String eventId;
  const EventDetails({super.key, required this.eventId});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late YandexMapController mapController;
  List<MapObject>? polylines;
  final List<MapObject> mapObjects = [];
  bool isFavorite = false;

  Point myCurrentLocation = const Point(
    latitude: 41.2856806,
    longitude: 69.9034646,
  );

  Point najotTalim = const Point(
    latitude: 41.2856806,
    longitude: 69.2034646,
  );

  Point eventLocation = const Point(
    latitude: 41.2856806,
    longitude: 69.2034646,
  );

  @override
  void initState() {
    super.initState();
    context.read<TadbiroBloc>().add(GetTadbiroEvent());
  }

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

  void _performSearch(String query) async {
    final placemarks = await YandexMapService.performSearch(query);

    setState(() {
      mapObjects.clear();
      mapObjects.addAll(placemarks);
    });

    if (placemarks.isNotEmpty) {
      await mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: placemarks.first.point,
            zoom: 15,
          ),
        ),
      );
    }
  }

  void showCustomSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: CustomSnackbarWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TadbiroBloc, TadbiroState>(builder: (context, state) {
        if (state is LoadingTadbiroState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is LoadedTadbiroState) {
          final event = state.tadbiros;

          return eventsListIwidget(event, context);
        }

        if (state is ErrorTadbiroState) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const Center(child: Text('No event details available'));
      }),
    );
  }

  Widget eventsListIwidget(
      List<Map<String, dynamic>> event, BuildContext context) {
    return ListView.builder(
      itemCount: event.length,
      itemBuilder: (context, index) {
        final events = event[index];
        final eventDateString = events['date'];
        DateTime? eventDate;
        if (eventDateString is String) {
          eventDate = DateTime.tryParse(eventDateString);
        }

        final GeoPoint geoPoint = events['location'];
        eventLocation = Point(
          latitude: geoPoint.latitude,
          longitude: geoPoint.longitude,
        );

        return Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 250.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(events['bannerUrl']),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Positioned(
                    top: 16.h,
                    left: 16.w,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16.h,
                    right: 16.w,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        icon: Icon(
                          isFavorite
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: isFavorite ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                events['name'],
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        const Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  SizedBox(width: 8.w),
                  Text(eventDate != null
                      ? eventDate.toLocal().toString()
                      : 'nomalum kun'),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.location_on, color: Colors.white),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    "${geoPoint.latitude.toStringAsFixed(4)}, ${geoPoint.longitude.toStringAsFixed(4)}",
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.people, color: Colors.white),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "${event.length} kishi bormoqda\nSiz ham ro'yxatdan o'ting",
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      "01:00",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        events['description'],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Joylashuv",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 300.h,
                width: double.infinity,
                child: YandexMap(
                  onMapCreated: onMapCreated,
                  onCameraPositionChanged: onCameraPositionChanged,
                  mapObjects: polylines ?? [],
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showCustomSnackBar(context);
                  },
                  child: const Text("Ro'yxatdan o'tish"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

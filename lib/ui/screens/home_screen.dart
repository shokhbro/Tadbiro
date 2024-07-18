import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tadbiro/bloc/tadbiro/tadbiro_bloc.dart';
import 'package:tadbiro/bloc/tadbiro/tadbiro_event.dart';
import 'package:tadbiro/bloc/tadbiro/tadbiro_state.dart';
import 'package:tadbiro/ui/screens/notification_screen.dart';
import 'package:tadbiro/ui/widgets/custom_drawer_widget.dart';
import 'package:tadbiro/ui/widgets/edit_event_widget.dart';
import 'package:tadbiro/ui/widgets/event_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<TadbiroBloc>().add(GetTadbiroEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Bosh Sahifa",
          style: TextStyle(
            fontFamily: 'Extrag',
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return const NotificationScreen();
              }));
            },
            icon: const Icon(
              Icons.notifications_none,
              size: 27,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: "Tadbirlarni qidirish",
                hintStyle: const TextStyle(fontFamily: 'Extrag'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.tune),
              ),
            ),
          ),
          Gap(10.h),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text(
                  "Yaqin 7 kun ichida",
                  style: TextStyle(
                    fontFamily: 'Extrag',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Gap(20.h),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: SizedBox(
              width: double.infinity,
              height: 200.h,
              child: PageView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.amber,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: 35.w,
                                height: 45.h,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "12\nMay",
                                      style: TextStyle(
                                          fontFamily: "lato",
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CupertinoIcons.heart_circle_fill,
                                size: 40.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Satellite mega festival for\ndesigners",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Gap(20.h),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text(
                  "Barcha tadbirlar",
                  style: TextStyle(
                    fontFamily: 'Extrag',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Gap(20.h),
          Expanded(
            child: BlocBuilder<TadbiroBloc, TadbiroState>(
              builder: (context, state) {
                if (state is LoadingTadbiroState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is LoadedTadbiroState) {
                  return buildEventWidget(state.tadbiros, context);
                }

                if (state is ErrorTadbiroState) {
                  return Center(
                    child: Text('Error: ${state.message}'),
                  );
                }
                return const Center(
                  child: Text("No events found!"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildEventWidget(
  List<Map<String, dynamic>> tadbiros,
  BuildContext context,
) {
  return ListView.builder(
    itemCount: tadbiros.length,
    itemBuilder: (context, index) {
      final event = tadbiros[index];
      GeoPoint location = event['location'];
      double latitude = location.latitude;
      double longitude = location.longitude;
      bool isFavorite = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return EventDetails(
                  eventId: event['id'],
                );
              }));
            },
            child: Container(
              height: 100,
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 4,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      image: DecorationImage(
                        image: NetworkImage(event['bannerUrl']),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Gap(15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['name'] ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Lato',
                          ),
                        ),
                        Text(
                          '${event['date']}',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 15.sp,
                            ),
                            Expanded(
                              child: Text(
                                "${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (ctx) {
                                return EditEventWidget(event: event);
                              }));
                            } else if (value == 'delete') {
                              _deleteEvent(event['id']);
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return const [
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Tahrirlash'),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('O\'chirish'),
                              ),
                            ];
                          },
                          icon: Icon(Icons.more_vert, size: 25.sp),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          highlightColor: Colors.transparent,
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
                          iconSize: 30.sp,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void _deleteEvent(String eventId) {
  FirebaseFirestore.instance.collection('tadbiro').doc(eventId).delete();
}

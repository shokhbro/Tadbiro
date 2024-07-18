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
import 'package:tadbiro/ui/widgets/add_event_widget.dart';
import 'package:tadbiro/ui/widgets/custom_drawer_widget.dart';
import 'package:tadbiro/ui/widgets/edit_event_widget.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    Future.delayed(Duration.zero, () {
      context.read<TadbiroBloc>().add(GetTadbiroEvent());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Mening Tadbirlarim",
          style: TextStyle(
            fontFamily: 'Extrag',
            color: Colors.white,
            fontSize: 18.sp,
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
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Tashkil Qilganlarim"),
            Tab(text: "Yaqinda"),
            Tab(text: "Ishtirok Etganlarim"),
            Tab(text: "Bekor Qilganlarim"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocBuilder<TadbiroBloc, TadbiroState>(
            builder: (context, state) {
              if (state is LoadingTadbiroState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is LoadedTadbiroState) {
                return buildEventListView(state.tadbiros, context);
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
          BlocBuilder<TadbiroBloc, TadbiroState>(
            builder: (context, state) {
              if (state is LoadingTadbiroState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is LoadedTadbiroState) {
                return buildEventListView(state.tadbiros, context);
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
          const Center(child: Text("No Events")),
          const Center(child: Text("No Events")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            return const AddEventWidget(
              event: {},
            );
          }));
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}

Widget buildEventListView(
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
          return Container(
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
          );
        },
      );
    },
  );
}

void _deleteEvent(String eventId) {
  FirebaseFirestore.instance.collection('tadbiro').doc(eventId).delete();
}

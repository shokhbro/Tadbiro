import 'package:cloud_firestore/cloud_firestore.dart';

class Tadbiro {
  String id;
  String name;
  DateTime date;
  String location;
  String description;
  String bannerUrl;

  Tadbiro({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.bannerUrl,
  });

  factory Tadbiro.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Tadbiro(
      id: data['id'],
      name: data['name'],
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'],
      description: data['description'],
      bannerUrl: data['bannerUrl'],
    );
  }
}

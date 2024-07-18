import 'package:cloud_firestore/cloud_firestore.dart';

class TadbiroService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTadbiro(
    String name,
    DateTime date,
    String location,
    String description,
    String bannerUrl,
  ) async {
    await _firestore.collection('tadbiro').add({
      'name': name,
      'date': date,
      'location': location,
      'description': description,
      'bannerUrl': bannerUrl,
    });
  }

  Future<void> deleteTadbiro(String id) async {
    await _firestore.collection('tadbiro').doc(id).delete();
  }

  Future<void> editTadbiro(
    String id,
    String name,
    DateTime date,
    String location,
    String description,
    String bannerUrl,
  ) async {
    await _firestore.collection('tadbiro').doc(id).update({
      'name': name,
      'date': date,
      'location': location,
      'description': description,
      'bannerUrl': bannerUrl,
    });
  }

  Stream<List<Map<String, dynamic>>> getTadbiro() {
    final snapshot = _firestore.collection('tadbiro').snapshots();
    return snapshot.map((snap) {
      return snap.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'date': doc['date'].toDate(),
          'location': doc['location'],
          'description': doc['description'],
          'bannerUrl': doc['bannerUrl'],
        };
      }).toList();
    });
  }
}

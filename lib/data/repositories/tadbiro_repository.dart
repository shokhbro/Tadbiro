import 'package:tadbiro/data/services/tadbiro_service.dart';

class TadbiroRepository {
  final TadbiroService _tadbiroService;
  TadbiroRepository({
    required TadbiroService tadbiroService,
  }) : _tadbiroService = tadbiroService;

  Stream<List<Map<String, dynamic>>> getTadbiro() {
    return _tadbiroService.getTadbiro();
  }

  Future<void> addTadbiro(
    String name,
    DateTime date,
    String location,
    String description,
    String bannerUrl,
  ) async {
    await _tadbiroService.addTadbiro(
      name,
      date,
      location,
      description,
      bannerUrl,
    );
  }

  Future<void> editTadbiro(
    String id,
    String name,
    DateTime date,
    String location,
    String description,
    String bannerUrl,
  ) async {
    await _tadbiroService.editTadbiro(
      id,
      name,
      date,
      location,
      description,
      bannerUrl,
    );
  }

  Future<void> deleteTadbiro(String id) async {
    await _tadbiroService.deleteTadbiro(id);
  }
}

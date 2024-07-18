sealed class TadbiroEvent {}

final class AddTadbiroEvent extends TadbiroEvent {
  String name;
  DateTime date;
  String location;
  String description;
  String bannerUrl;

  AddTadbiroEvent({
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.bannerUrl,
  });
}

final class EditTadbiroEvent extends TadbiroEvent {
  final String id;
  String name;
  DateTime date;
  String location;
  String description;
  String bannerUrl;

  EditTadbiroEvent({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.bannerUrl,
  });
}

final class GetTadbiroEvent extends TadbiroEvent {}

final class DeleteTadbiroEvent extends TadbiroEvent {
  final String id;

  DeleteTadbiroEvent({required this.id});
}

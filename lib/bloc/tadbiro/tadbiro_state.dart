sealed class TadbiroState {}

class InitialTadbiroState extends TadbiroState {}

final class LoadingTadbiroState extends TadbiroState {}

final class LoadedTadbiroState extends TadbiroState {
  final List<Map<String, dynamic>> tadbiros;

  LoadedTadbiroState({required this.tadbiros});
}

final class ErrorTadbiroState extends TadbiroState {
  final String message;

  ErrorTadbiroState(this.message);
}

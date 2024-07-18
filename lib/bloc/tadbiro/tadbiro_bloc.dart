import 'package:bloc/bloc.dart';
import 'package:tadbiro/data/repositories/tadbiro_repository.dart';
import 'package:tadbiro/bloc/tadbiro/tadbiro_event.dart';
import 'package:tadbiro/bloc/tadbiro/tadbiro_state.dart';

class TadbiroBloc extends Bloc<TadbiroEvent, TadbiroState> {
  final TadbiroRepository tadbiroRepository;

  TadbiroBloc({required this.tadbiroRepository})
      : super(InitialTadbiroState()) {
    on<AddTadbiroEvent>((event, emit) async {
      emit(LoadingTadbiroState());
      try {
        await tadbiroRepository.addTadbiro(
          event.name,
          event.date,
          event.location,
          event.description,
          event.bannerUrl,
        );
      } catch (e) {
        emit(ErrorTadbiroState(e.toString()));
      }
    });

    on<EditTadbiroEvent>((event, emit) async {
      emit(LoadingTadbiroState());
      try {
        await tadbiroRepository.editTadbiro(
          event.id,
          event.name,
          event.date,
          event.location,
          event.description,
          event.bannerUrl,
        );
      } catch (e) {
        emit(ErrorTadbiroState(e.toString()));
      }
    });

    on<DeleteTadbiroEvent>((event, emit) async {
      emit(LoadingTadbiroState());
      try {
        await tadbiroRepository.deleteTadbiro(event.id);
      } catch (e) {
        emit(ErrorTadbiroState(e.toString()));
      }
    });

    on<GetTadbiroEvent>(getTadbiro);
  }

  void getTadbiro(GetTadbiroEvent event, Emitter<TadbiroState> emit) async {
    emit(LoadingTadbiroState());

    try {
      await emit.forEach(tadbiroRepository.getTadbiro(), onData: (data) {
        return (LoadedTadbiroState(tadbiros: data));
      });
    } catch (e) {
      emit(ErrorTadbiroState(e.toString()));
    }
  }
}

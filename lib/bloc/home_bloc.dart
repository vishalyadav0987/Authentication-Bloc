import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/image_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ImageRepository imageRepository;
  HomeBloc({required this.imageRepository}) : super(HomeInitial()) {
    on<FetchImages>((event, emit) async {
      emit(HomeLoading());
      try {
        final images = await imageRepository.fetchImages();
        emit(HomeLoaded(images));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}

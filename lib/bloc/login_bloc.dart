import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc({required this.authRepository}) : super(const LoginState()) {
    on<LoginEmailChanged>((event, emit) {
      final isValid = _isValidEmail(event.email);
      emit(
        state.copyWith(
          email: event.email,
          isEmailValid: isValid,
          errorMessage: null,
        ),
      );
    });

    on<LoginPasswordChanged>((event, emit) {
      final isValid = _isValidPassword(event.password);
      emit(
        state.copyWith(
          password: event.password,
          isPasswordValid: isValid,
          errorMessage: null,
        ),
      );
    });

    on<LoginSubmitted>((event, emit) async {
      if (!state.isEmailValid || !state.isPasswordValid) {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: 'Please enter valid credentials',
          ),
        );
        return;
      }
      emit(state.copyWith(status: LoginStatus.submitting));
      try {
        await authRepository.login(state.email, state.password);
        emit(state.copyWith(status: LoginStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final length = password.length >= 8;
    final upper = RegExp(r'[A-Z]').hasMatch(password);
    final lower = RegExp(r'[a-z]').hasMatch(password);
    final digit = RegExp(r'[0-9]').hasMatch(password);
    final symbol = RegExp(
      r'[!@#\$&*~%^&()_+\-=\[\]{};:"\\|,.<>\/?]',
    ).hasMatch(password);
    return length && upper && lower && digit && symbol;
  }
}

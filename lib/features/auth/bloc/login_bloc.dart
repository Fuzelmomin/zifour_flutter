import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/login_repository.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/user_preference.dart';

// Login BLoC Events
abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String mobile;
  final String password;
  final bool rememberMe;
  LoginSubmitted({
    required this.mobile,
    required this.password,
    required this.rememberMe,
  });
}

// Login BLoC States
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  LoginSuccess({required this.message});
}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}

// Login BLoC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _repository = LoginRepository();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final response = await _repository.login(
        mobile: event.mobile,
        password: event.password,
      );

      if (response.status == ApiStatus.success && response.data != null) {
        final loginResponse = response.data!;

        // Save user data to SharedPreferences
        if (loginResponse.data != null) {
          await UserPreference.saveUserData(loginResponse.data!);
        }

        // Handle remember me functionality
        if (event.rememberMe) {
          // Save credentials
          await UserPreference.saveRememberMe(true);
          await UserPreference.saveLoginCredentials(
            mobile: event.mobile,
            password: event.password,
          );
        } else {
          // Clear saved credentials if remember me is off
          await UserPreference.saveRememberMe(false);
          await UserPreference.clearLoginCredentials();
        }

        emit(LoginSuccess(message: loginResponse.message));
      } else {
        emit(LoginError(
          response.errorMsg ?? 'Failed to login',
        ));
      }
    } catch (e) {
      emit(LoginError('Error: ${e.toString()}'));
    }
  }
}


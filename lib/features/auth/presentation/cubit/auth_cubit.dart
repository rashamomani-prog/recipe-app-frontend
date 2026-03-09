import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/auth_local_service.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource authDataSource;
  final AuthLocalService localService;

  AuthCubit(this.authDataSource, this.localService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authDataSource.login(email, password);

      await localService.saveToken(user.token ?? "");
      await localService.saveRole(user.role ?? "user");

      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError("The email or password is incorrect."));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required dynamic uroleser,
  }) async {
    emit(AuthLoading());

    try {
      final user = await authDataSource.register(name, email, password);
      await localService.saveToken(user.token ?? "");
      await localService.saveRole(uroleser?.toString() ?? "user");

      emit(AuthSuccess(user));
      print("User registered successfully: ${user.name}");

    } catch (e) {
      emit(AuthError("Failed to register. Please check your connection."));
      print("Registration error: $e");
    }
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/auth_local_service.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource authDataSource;
  final AuthLocalService localService;

  AuthCubit(this.authDataSource, this.localService) : super(AuthInitial());

  /// Current user when logged in, null otherwise.
  UserModel? get currentUser {
    final state = this.state;
    return state is AuthSuccess ? state.user : null;
  }

  /// True when the current user has admin role.
  bool get isAdmin => currentUser?.role?.toLowerCase() == 'admin';
  bool get isUser => currentUser != null && !isAdmin;
  bool get isLoggedIn => currentUser != null;

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final token = await authDataSource.login(email, password);
      await localService.saveToken(token);
      final user = await authDataSource.getMe();
      await localService.saveRole(user.role ?? 'user');
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Login failed'));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await authDataSource.register(name, email, password);
      final token = await authDataSource.login(email, password);
      await localService.saveToken(token);
      final user = await authDataSource.getMe();
      await localService.saveRole(user.role ?? 'user');
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Registration failed'));
    }
  }

  Future<void> logout() async {
    await localService.clearAuthData();
    emit(AuthInitial());
  }

  /// Call GET /auth/me to restore user; clear and emit initial if 401.
  Future<void> tryRestoreUser() async {
    final token = await localService.getToken();
    if (token == null || token.isEmpty) {
      emit(AuthInitial());
      return;
    }
    try {
      final user = await authDataSource.getMe();
      emit(AuthSuccess(user));
    } catch (_) {
      await localService.clearAuthData();
      emit(AuthInitial());
    }
  }
}

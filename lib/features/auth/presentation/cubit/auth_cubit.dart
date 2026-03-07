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

      await localService.saveToken(user.token);
      await localService.saveRole(user.role);

      if (user.role == 'admin') {
        print("أهلاً بك أيها المدير!");
      }
      emit(AuthSuccess(user));

    } catch (e) {
      emit(AuthError("الإيميل أو كلمة المرور غلط أو مشكلة في السيرفر"));
    }
  }
}
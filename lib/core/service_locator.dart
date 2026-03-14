import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/recipes/data/datasources/recipe_local_data_source.dart';
import '../features/recipes/data/datasources/recipe_remote_data_source.dart';
import '../features/recipes/data/repositories/recipe_repository_impl.dart';
import '../features/recipes/domain/repositories/recipe_repository.dart';
import '../features/recipes/domain/usecases/add_recipe_usecase.dart';
import '../features/recipes/domain/usecases/get_categories_usecase.dart';
import '../features/recipes/presentation/cubit/recipe_cubit.dart';
import '../services/ai_service.dart';
import 'auth_local_service.dart';
import 'dio_client.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => AuthLocalService());
  sl.registerLazySingleton(() => DioClient(sl<AuthLocalService>()));

  // Auth
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl<DioClient>().dio));
  sl.registerLazySingleton(() => AuthCubit(sl<AuthRemoteDataSource>(), sl<AuthLocalService>()));

  // Data Sources
  sl.registerLazySingleton<RecipeLocalDataSource>(() => RecipeLocalDataSourceImpl());
  sl.registerLazySingleton(() => RecipeRemoteDataSource(sl<DioClient>()));
  sl.registerLazySingleton(() => AIService());

  // Repositories
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(
      remoteDataSource: sl<RecipeRemoteDataSource>(),
      localDataSource: sl<RecipeLocalDataSource>(),
      aiService: sl<AIService>(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => GetCategories(sl<RecipeRepository>()));
  sl.registerLazySingleton(() => AddRecipeUseCase(sl<RecipeRepository>()));

  // Cubits
  sl.registerFactory(() => RecipeCubit(
        sl<GetCategories>(),
        sl<AddRecipeUseCase>(),
        sl<RecipeRepository>(),
      ));
}

import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/recipes/data/repositories/category_repository_impl.dart';
import '../features/recipes/domain/repositories/category_repository.dart';
import '../features/recipes/domain/usecases/add_recipe_usecase.dart';
import '../features/recipes/domain/usecases/get_categories_usecase.dart';
import 'auth_local_service.dart';
import 'dio_client.dart';
import '../features/recipes/data/datasources/recipe_remote_data_source.dart';
import '../features/recipes/data/repositories/recipe_repository_impl.dart';
import '../features/recipes/presentation/cubit/recipe_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient());

  // Data Sources
  sl.registerLazySingleton(() => RecipeRemoteDataSource(sl()));

// Repositories
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl());
  // UseCase
  sl.registerLazySingleton(() => AddRecipeUseCase(sl()));
//cubit
  sl.registerFactory(() => RecipeCubit(sl<GetCategories>(), sl<AddRecipeUseCase>()));
// Core
  sl.registerLazySingleton(() => AuthLocalService());

// Auth Feature
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl()));
}
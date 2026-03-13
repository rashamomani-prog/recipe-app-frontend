import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/recipes/data/datasources/recipe_local_data_source.dart';
import '../features/recipes/data/repositories/category_repository_impl.dart';
import '../features/recipes/domain/repositories/category_repository.dart';
import '../features/recipes/domain/repositories/recipe_repository.dart';
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
  sl.registerLazySingleton(() => AuthLocalService());

  // --- Data Sources ---
  sl.registerLazySingleton(() => RecipeRemoteDataSource(sl()));
  // أضيفي الـ Local إذا كان الـ Repository بطلبه
  // sl.registerLazySingleton(() => RecipeLocalDataSource());

  // --- Repositories ---
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl());

  // 🔥 التعديل الأهم: تسجيل الـ RecipeRepository
  sl.registerLazySingleton<RecipeRepository>(
        () => RecipeRepositoryImpl(
      remoteDataSource: sl<RecipeRemoteDataSource>(),
       localDataSource: sl<RecipeLocalDataSource>(),
    ),
  );

  // --- UseCases ---
  sl.registerLazySingleton(() => GetCategories(sl())); // تأكدي من اسم الكلاس
  sl.registerLazySingleton(() => AddRecipeUseCase(sl()));

  // --- Cubits ---
  sl.registerFactory(() => RecipeCubit(
    sl<GetCategories>(),
    sl<AddRecipeUseCase>(),
    sl<RecipeRepository>(),
    // sl<RecipeRepository>(), // إذا الـ Cubit محتاجه للـ AI
  ));

  // Auth Feature
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl()));
}
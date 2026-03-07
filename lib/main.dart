import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/auth_local_service.dart';
import 'core/service_locator.dart' as di;
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/recipes/presentation/cubit/recipe_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/recipes/presentation/pages/categories_page.dart';
import 'features/recipes/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  final authService = di.sl<AuthLocalService>();
  final token = await authService.getToken();

  runApp(RashifyApp(isLoggedIn: token != null));
}

class RashifyApp extends StatelessWidget {
  final bool isLoggedIn;
  const RashifyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthCubit>()),
        BlocProvider(create: (context) => di.sl<RecipeCubit>()..fetchRecipes()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: isLoggedIn ? const CategoriesPage() : const LoginPage(),
      ),
    );
  }
}
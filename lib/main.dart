import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/auth_local_service.dart';
import 'core/service_locator.dart' as di;
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/recipes/presentation/cubit/recipe_cubit.dart';
import 'features/recipes/presentation/pages/categories_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  final authService = di.sl<AuthLocalService>();
  final token = await authService.getToken();

  runApp(RashifyApp(isLoggedIn: token != null));
}

class RashifyApp extends StatefulWidget {
  final bool isLoggedIn;
  const RashifyApp({super.key, required this.isLoggedIn});

  @override
  State<RashifyApp> createState() => _RashifyAppState();
}

class _RashifyAppState extends State<RashifyApp> {
  // الحالة الافتراضية للثيم
  ThemeMode _themeMode = ThemeMode.light;

  // دالة لتغيير الثيم رح نمررها لصفحة اللوجن
  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthCubit>()),
        BlocProvider(create: (context) => di.sl<RecipeCubit>()..fetchRecipes()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        home: widget.isLoggedIn
            ? CategoriesPage()
            : LoginPage(onThemeChanged: _toggleTheme),
      ),
    );
  }
}
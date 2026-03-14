import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/service_locator.dart' as di;
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/recipes/presentation/cubit/recipe_cubit.dart';
import 'features/recipes/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  final authCubit = di.sl<AuthCubit>();
  await authCubit.tryRestoreUser();

  runApp(RashifyApp(authCubit: authCubit));
}

class RashifyApp extends StatefulWidget {
  final AuthCubit authCubit;

  const RashifyApp({super.key, required this.authCubit});

  @override
  State<RashifyApp> createState() => _RashifyAppState();
}

class _RashifyAppState extends State<RashifyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: widget.authCubit),
        BlocProvider(create: (context) => di.sl<RecipeCubit>()..fetchRecipes()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.light),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.dark),
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          bloc: widget.authCubit,
          builder: (context, state) {
            if (state is AuthSuccess) {
              return const HomePage();
            }
            return LoginPage(onThemeChanged: _toggleTheme);
          },
        ),
      ),
    );
  }
}

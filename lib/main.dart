import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiro/bloc/tadbiro/tadbiro_bloc.dart';
import 'package:tadbiro/data/repositories/tadbiro_repository.dart';
import 'package:tadbiro/data/services/tadbiro_service.dart';
import 'package:tadbiro/firebase_options.dart';
import 'package:tadbiro/ui/screens/home_screen.dart';
import 'package:tadbiro/ui/screens/verification/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final tadbiroService = TadbiroService();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (ctx) {
          return TadbiroRepository(tadbiroService: tadbiroService);
        }),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) {
            return TadbiroBloc(
              tadbiroRepository: ctx.read<TadbiroRepository>(),
            );
          }),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 766),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.blue,
                ),
              ),
              home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final user = snapshot.data;
                  return user == null
                      ? const SplashScreen()
                      : const HomeScreen();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';
import 'bloc/login_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/image_repository.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();
  final ImageRepository imageRepository = ImageRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: imageRepository),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Assignment',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Montserrat', // Local font set here
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => BlocProvider(
            create: (_) => LoginBloc(authRepository: authRepository),
            child: LoginScreen(),
          ),
          '/home': (context) => BlocProvider(
            create: (_) => HomeBloc(imageRepository: imageRepository),
            child: HomeScreen(),
          ),
        },
      ),
    );
  }
}

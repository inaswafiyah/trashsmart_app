import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashsmart/data/datasource/auth_remote_datasource.dart';
import 'package:trashsmart/presentation/auth/bloc/login/login_bloc.dart';
import 'package:trashsmart/presentation/auth/bloc/register/register_bloc.dart';
import 'package:trashsmart/presentation/auth/pages/splash_screen.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (_) => RegisterBloc(
            authDatasource: AuthRemoteDatasource(),
          ),
        ),
      ],
      child: MyApp()),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
        MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TrashSmart',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      );
  }
}
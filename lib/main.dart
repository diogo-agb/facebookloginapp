import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './blocs/auth_bloc.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return somethingWentWronr();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return buildProvider();
        }

        return loading();
      },
    );
  }

  Center loading() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/loading.gif',
              ),
              fit: BoxFit.fill),
        ),
      ),
    );
  }

  MaterialApp somethingWentWronr() {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Something Went Wrong'),
            ],
          ),
        ),
      ),
    );
  }

  Provider<AuthBloc> buildProvider() {
    return Provider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'A Facebook login app',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginScreen(),
        routes: {
          AppRoutes.LOGIN: (ctx) => LoginScreen(),
          AppRoutes.HOME: (ctx) => HomeScreen(),
        },
      ),
    );
  }
}

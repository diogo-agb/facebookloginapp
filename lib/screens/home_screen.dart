import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import '../blocs/auth_bloc.dart';
import '../routes/routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription<User> homeStateSubscription;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    homeStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    homeStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('A facebook login app'),
      ),
      body: Center(
        child: StreamBuilder<User>(
            stream: authBloc.currentUser,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.data.displayName,
                    style: TextStyle(fontSize: mediaQuery.width * 0.07),
                  ),
                  SizedBox(height: mediaQuery.height * 0.04),
                  CircleAvatar(
                    radius: mediaQuery.width * 0.25,
                    backgroundImage: NetworkImage(
                      snapshot.data.photoURL +
                          '?height=300&width=300&migration_overrides=%7Boctober_2012%3Atrue%7D&access_token=${authBloc.token}',
                    ),
                  ),
                  SizedBox(height: mediaQuery.height * 0.10),
                  SignInButton(
                    Buttons.Facebook,
                    text: 'Sign out of Facebook',
                    onPressed: () => authBloc.logout(),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

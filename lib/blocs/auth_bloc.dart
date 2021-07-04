import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

import '../services/auth_service.dart';

class AuthBloc {
  final AuthService authService = AuthService();
  final fb = FacebookLogin();
  String token;

  Stream<User> get currentUser => authService.currentUser;

  loginFacebook() async {
    print('Starting Facebook login');

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (res.status) {
      case FacebookLoginStatus.Success:
        print('Usuário efetuou o login com sucesso!');

        //Get Token
        final FacebookAccessToken fbToken = res.accessToken;
        this.token = fbToken.token;

        // // Get user profile image url
        // final imageUrl = await fb.getProfileImageUrl(width: 300);
        // this.imageUrl = imageUrl;
        // print('Your profile image: $imageUrl');

        // Convert to Auth Credential
        final AuthCredential credential =
            FacebookAuthProvider.credential(fbToken.token);

        //User Credential to Sign in with Firebase
        final result = await authService.signInWithCredential(credential);
        print('${result.user.displayName} is now logged in');

        break;
      case FacebookLoginStatus.Cancel:
        print('O usuário cancelou o login');
        break;
      case FacebookLoginStatus.Error:
        print('Ocorreu algum erro');
        break;
    }
  }

  logout() {
    authService.logout();
  }
}

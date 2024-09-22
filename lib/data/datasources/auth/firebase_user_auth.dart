import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
abstract class FirebaseUserAuth {
  Future<bool> login(String email, String password);
  Future<bool> signUp(String name, String email, String password);
  Future<void> signOut();
  Future<bool> loginWithGoogle();
   Future<bool>  signInWithFacebook();
}

class FirebaseUserAuthImpl implements FirebaseUserAuth {
  @override
  Future<bool> login(String email, String password) async {
    try {
      final response = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Login response = $response');
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signUp(String name, String email, String password) async {
    try {
      final response =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      print('signUp response = $response');
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> loginWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return false;
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    var response = await FirebaseAuth.instance.signInWithCredential(credential);
    print(' google login response = $response');
    return true;
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
  
  @override
  Future<bool> signInWithFacebook() async {
    // Trigger the sign-in flow
  //   final LoginResult? loginResult = await FacebookAuth.instance.login();
  // if (loginResult == null) {
  //   return false;
  // }
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken?.token);

  //   // Once signed in, return the UserCredential
  //   var response = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //   print('facebook login response = $response');
    return true;
  }
}

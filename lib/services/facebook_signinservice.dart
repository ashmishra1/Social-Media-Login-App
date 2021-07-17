import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class FBAuthentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.white, letterSpacing: 0.5),
      ),
    );
  }

  static Future<void> signOutFB() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    await FacebookAuth.instance.logOut();
    await facebookLogin.logOut();

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      FBAuthentication.customSnackBar(
        content: 'Error signing out. Try again.',
      );
    }
  }

  static Future<User?> signInWithFacebook(
      {required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    User? user;

    final fb = FacebookLogin();

// Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

// Check result status
    if (res.status == FacebookLoginStatus.success) {
      // Logged in
      // Send access token to server for validation and auth
      final FacebookAccessToken? accessToken = res.accessToken;
      final AuthCredential authCredential =
          FacebookAuthProvider.credential(accessToken!.token);

      print('Access token: ${accessToken.token}');

      // Get profile data
      final profile = await fb.getUserProfile();
      print('Hello, ${profile!.name}! You ID: ${profile.userId}');

      // Get user profile image url
      final imageUrl = await fb.getProfileImageUrl(width: 100);
      print('Your profile image: $imageUrl');

      // Get email (since we request email permission)
      final email = await fb.getUserEmail();
      // But user can decline permission
      if (email != null) print('And your email is $email');

      try {
        final result = await auth.signInWithCredential(authCredential);

        user = result.user;

        var userData = {
          'name': profile.name,
          'provider': 'Facebook',
          'photoUrl': imageUrl,
          'email': email,
        };
        await users.doc(user!.uid).get().then((doc) {
          if (doc.exists) {
            doc.reference.update(userData);
          } else {
            users.doc(user!.uid).set(userData);
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            FBAuthentication.customSnackBar(
              content:
                  'The account already exists with a different credential.',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            FBAuthentication.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          FBAuthentication.customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
    }
    return user;
  }

  static Future<int> signedWithF() async {
    return 1;
  }
}

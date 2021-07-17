import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_login/services/facebook_signinservice.dart';
import 'package:social_media_login/services/google_signin_services.dart';
import 'package:social_media_login/src/screens/userinformation.dart';
import 'package:social_media_login/utils/color.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _isSigningIn
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ThemeColor.PrimaryColor),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        side: BorderSide(
                            width: 5, color: ThemeColor.PrimaryColor),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isSigningIn = true;
                        });

                        var user = await Authentication.signInWithGoogle(
                            context: context);

                        setState(() {
                          _isSigningIn = false;
                        });

                        if (user != null) {
                          await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => UserInformation(
                                user: user,
                              ),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.google,
                                color: ThemeColor.PrimaryColor,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        side: BorderSide(
                            width: 5, color: ThemeColor.PrimaryColor),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isSigningIn = true;
                        });

                        var user = await FBAuthentication.signInWithFacebook(
                            context: context);

                        setState(() {
                          _isSigningIn = false;
                        });

                        if (user != null) {
                          await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => UserInformation(
                                user: user,
                              ),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.facebookF,
                                color: ThemeColor.PrimaryColor,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_login/services/facebook_signinservice.dart';
import 'package:social_media_login/services/google_signin_services.dart';
import 'package:social_media_login/src/screens/signin.dart';
import 'package:social_media_login/utils/color.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key, required User user}) : super(key: key);
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  bool isSigningOut = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
        body: Center(
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Homebg.png'),
                fit: BoxFit.cover)),
        child: FutureBuilder<DocumentSnapshot>(
            future: users.doc(FirebaseAuth.instance.currentUser?.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: ThemeColor.SecondaryColor,
                      maxRadius: 60,
                      backgroundImage: NetworkImage(data['photoUrl']),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      data['name'],
                      style: TextStyle(
                        color: ThemeColor.SecondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          data['email'],
                          style: TextStyle(
                              color: ThemeColor.SecondaryColor, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 200,
                    ),
                    Text('Thanks for logging in using "${data['provider']}"'),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: MaterialButton(
                        elevation: 0.0,
                        onPressed: () async {
                          if (data['provider'] == 'Google') {
                            setState(() {
                              isSigningOut = true;
                            });

                            await Authentication.signOut(context: context);

                            setState(() {
                              isSigningOut = false;
                            });

                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => SignIn()),
                            );
                          } else if (data['provider'] == 'Facebook') {
                            setState(() {
                              isSigningOut = true;
                            });

                            await FBAuthentication.signOutFB();

                            setState(() {
                              isSigningOut = false;
                            });

                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => SignIn()),
                            );
                          }
                        },
                        color: ThemeColor.PrimaryColor,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 40, right: 40.0),
                          child: Text('Logout'),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Center(
                  child: Container(
                      child: CircularProgressIndicator(
                color: ThemeColor.PrimaryColor,
              )));
            }),
      ),
    ));
  }
}

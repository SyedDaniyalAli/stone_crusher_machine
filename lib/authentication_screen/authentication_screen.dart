import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stone_crusher_machine/main_screen/main_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  static String routeName = "AuthenticationScreen";

  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  FirebaseAuth auth = FirebaseAuth.instance;

  bool _isLoading = false;

  var box;

  // void _trySubmit() {
  //   final isValid = _formKey.currentState!.validate();
  //   FocusScope.of(context).unfocus();
  //   _formKey.currentState!.save();
  //
  //   if (isValid) {
  //     _formKey.currentState!.reset();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    openHiveDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        centerTitle: true,
        // elevation: 0,
        title: const Text(
          'Stone Crushing Machine',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    'dev_assets/icon/app_logo.png',
                    filterQuality: FilterQuality.high,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.google),
                            Container(
                              child: const Text(
                                "Sign in with Google",
                                style: TextStyle(fontSize: 20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Future<UserCredential> userCredentials =
                              _signInWithGoogle();

                          userCredentials.then((value) async {
                            if (value.user != null) {
                              Navigator.pushReplacementNamed(
                                  context, MainScreen.routeName);
                            }
                          });
                        },
                        color: Theme.of(context).primaryColor,
                        // textColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> openHiveDB() async {
    box = await Hive.openBox('loginCredentials');
  }

  void showProgress() {
    EasyLoading.show(
      status: 'Loading...',
      indicator: CircularProgressIndicator(),
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.black,
    );
  }
}

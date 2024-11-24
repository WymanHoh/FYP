// login_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prototype1/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:prototype1/global/common/toast.dart';
import 'package:prototype1/presentation/pages/home_page.dart';
import 'package:prototype1/presentation/pages/sign_up_page.dart';
import 'package:prototype1/presentation/widgets/form_container_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isSigning = false;

  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              const SizedBox(height: 20),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  _signIn();
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 196, 0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigning ? const CircularProgressIndicator(color: Colors.black): const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  _signInWithGoogle();
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.google, color: Colors.white,),
                        SizedBox(width: 5,),
                        Text(
                          "Sign in with Google",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20), // Added spacing for clarity
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 196, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
    void _signIn() async {

      setState(() {
        _isSigning = true;
      });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

setState(() {
  _isSigning = false;
});

    if (user != null) {
      if (!mounted) return;
      showToast(message:"User successfully signedIn");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      showToast(message:"Error: User creation failed.");
    }
  }

    _signInWithGoogle()async{

    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if(googleSignInAccount != null ){
        final GoogleSignInAuthentication googleSignInAuthentication = await
        googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
       if (!mounted) return;
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const HomePage()),
);

      }

    }catch(e) {
      showToast(message: "some error occured $e");
    }


  }
}
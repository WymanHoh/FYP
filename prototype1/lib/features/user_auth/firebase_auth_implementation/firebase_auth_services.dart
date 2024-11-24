import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototype1/global/common/toast.dart';

class FirebaseAuthServices{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async{

    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch (e){
    
    if(e.code == 'email-already-in-use'){
      showToast(message: 'The email address is already in use.');
    } else if(e.code == 'invalid-email'){
      showToast(message: 'The email address is not valid.');
    } 
    else if(e.code == 'weak-password'){
      showToast(message: 'Password validation is at least 6 character');
    } else {
        showToast(message: 'An error occurred: ${e.code}');
      }

    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async{

    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch (e){
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }

    }
    return null;
  }

}
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../utils/exports.dart';

class AuthControllerProvider extends ChangeNotifier {
  

  //setter
  bool _isLoading = false;
  String _responseMessage = '';
  //getter
  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');   

  String _email='';
  String get email => _email;
  set email(String email){
    _email = email;
    notifyListeners();  
  }

  String _password ='';
  String get password => _password;
  set password(String password){
    _password = password;
    notifyListeners();
  }
  
  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;
  set confirmPassword(String confirmPassword){
    _confirmPassword = confirmPassword;
    notifyListeners();
  }
  

 String? nameValidate(String value) {

    if(value.isEmpty){
      return 'Please enter your full name';
    }
    else{
      return null;
    }

  }
  
  String? emailValidate(String value){
    const String format = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    return !RegExp(format).hasMatch(value) ? "Enter valid email" : null;
  }

 String? validateConfirmPassword(String value) {

    if(value.isEmpty){
      return 'Please enter confirm password';
    }
    else if(value != password){
      return 'Confirm password does not match.';
    }
    else{
      return null;
    }

  } 
 

  String? validatePassword(String value) {

    if (value.isEmpty) {
      return 'Please enter password';
    } else if(value.length< 8){
      return 'Password can not be less than 8 char.';
    }
    else{
      return null;
    }

  }


  bool _obscurePassword =true;
  bool get obscurePassword => _obscurePassword;
  set obscurePassword(bool obscureText) {
    _obscurePassword = obscureText;
    notifyListeners();
  }

  bool _obscureConfirmPassword =true;
   bool get obscureConfirmPassword => _obscureConfirmPassword;
  set obscureConfirmPassword(bool obscureConfirmText) {
    _obscureConfirmPassword = obscureConfirmText;
    notifyListeners();
  }

  Future<void>login({required String email,required String password, BuildContext? context,})async{
    
    _isLoading = true;
    notifyListeners();
    try{
     await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
        );
      _isLoading = false;
      _responseMessage = "Login successful!";
        notifyListeners();
    }on FirebaseAuthException catch(e){
      // print(e.code);
      _isLoading = false;
      notifyListeners();
      if(e.code == "wrong-password"){
        return Future.error("Wrong password! Please enter correct password");
      }else if(e.code == "user-not-found"){
        return Future.error("User not found");
      }else if(e.code == "invalid-email"){
        return Future.error("User not found");
      }
      else{
        return Future.error(e.message ?? "");
      }

      
    } catch (e){
       _isLoading = false;
       notifyListeners();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void>register({String? name,required String email,required String password})async{
    _isLoading = true;
    notifyListeners();
    try{
     await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
        );

      _isLoading = false;
      _responseMessage = "Register successful!";
        notifyListeners();   

  // Add user info to the "users" collection
   await _usersCollection.doc(user!.uid).set({
      'name': name,
      'email': email,
      'password': password,
      'uid': user!.uid,
      'createdAt': DateTime.now(),
    });

      _isLoading = false; 
      notifyListeners(); 
    }on FirebaseAuthException catch(e){
      _isLoading = false;
      notifyListeners(); 
      if(e.code == "email-already-in-use"){
        return Future.error("Email already in use! Please enter unique email");
      }else if(e.code == "weak-password"){
        return Future.error("Weak password! Please enter strong password");
      }
      else{
        return Future.error(e.message ?? "");
      }
    } catch (e){
       _isLoading = false;
       notifyListeners();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> logout() async{
   await _auth.signOut();
   await clearText();
  }

   clearText() async{
    email = '';
    password = '';
    confirmPassword = '';
  }

    void clear() {
    _responseMessage = '';
    notifyListeners();
  }



}


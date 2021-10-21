import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:familicious/services/file_upload_services.dart';

//change notifier is with the inherited widgets
//state management with flutter uses publisher and suscriber
//with
class AuthManager with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  final FileUploadService _fileUploadService = FileUploadService();
  String _message = '';
  CollectionReference userCollection =
      _firebaseFirestore.collection('users');
  bool _isLoading = false;

  String get message => _message; //get
  bool get isLoading => _isLoading;

  setMessage(String message) {
    //set
    _message = message;
    notifyListeners();
  }

  setIsLoading(bool loading) {
    //set
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> createNewUser(
      {required String name,
      required String email,
      required String password,
      required File imageFile}) async {
    setIsLoading(true);
    bool isCreated = false;
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) async {
      String? photoUrl = await _fileUploadService.uploadFile(
          file: imageFile, userUid: userCredential.user!.uid);
      if (photoUrl != null) {
        //add user info to firestore
        //saving data to firestore

        await userCollection.doc(userCredential.user!.uid).set({
          "name": name,
          "email": email,
          "picture": photoUrl,
          //picks the time from the server
          "createdAt": FieldValue.serverTimestamp(),
          "user_id": userCredential.user!.uid
        });
        isCreated = true;
      } else {
        setMessage('Image Upload failed');
        isCreated = false;
      }
      setIsLoading(false);
    }).catchError((onError) {
      setMessage('$onError');
      setIsLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      setMessage('Please check your internet connection');
      isCreated = false;
      setIsLoading(false);
    });
    return isCreated;
  }

  Future<bool> loginUser({required String email,required String password})async{
    bool isSuccessful =false;
    //login a user with firebase
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((userCredential) {
      if(userCredential.user !=null){
        isSuccessful =true;
      }else{
        isSuccessful = false;
        setMessage('Could not log you in!');
      }
    }).catchError((onError){
      setMessage('$onError');
      isSuccessful = false;
    }).timeout(const Duration(seconds: 60),onTimeout: (){
      setMessage('Please check your internet connection.');
      isSuccessful = false;
    });
    return isSuccessful;
  }

  Future<bool>sendResetLink(String email) async{
    bool isSent=false;
    await _firebaseAuth.sendPasswordResetEmail(email: email).then((_){
      isSent=true;
    }).catchError((onError){
      setMessage('$onError');
      isSent=false;

    }).timeout(const Duration(seconds: 60,),onTimeout: (){
      setMessage('Please check your internet connection');
      isSent=false;
    });
    return isSent;
  }
}

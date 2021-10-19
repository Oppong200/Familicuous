import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:familicious/services/file_upload_services.dart';

//change notifier is with the inherited widgets
//state management with flutter uses publisher and suscriber
//with
class AuthManager with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FileUploadService _fileUploadService =FileUploadService();
  String _message = '';
  bool _isLoading = false;

  String get message => _message; //get
  bool get isLoading => _isLoading;

  setMessage(String message) {
    //set
    _message = message;
    notifyListeners();
  }

  setisLoading(bool loading) {
    //set
    _isLoading = loading;
    notifyListeners();
  }

  createNewUser({required String name,required String email,required String password,required File imageFile}) async{
    
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((UserCredential) async{
      String? photoUrl = await _fileUploadService.uploadFile(file:imageFile, userUid: UserCredential.user!.uid);
      if(photoUrl!=null){

      }else{
        setMessage('Image Upload failed');
      }
    }).catchError((onError){
      setMessage('$onError');
    }).timeout(const Duration(seconds: 60), onTimeout: (){
      setMessage('Please check your internet connection');
    });
  }


}

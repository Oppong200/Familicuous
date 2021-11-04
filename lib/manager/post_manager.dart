import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familicious/services/file_upload_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostManager with ChangeNotifier{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference<Map<String,dynamic>> _postCollection=_firebaseFirestore.collection("posts");
  final CollectionReference<Map<String, dynamic>> _userCollection =
      _firebaseFirestore.collection("users");

  final FileUploadService _fileUploadService=FileUploadService();

  String _message = '';
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



  Future<bool> submitPost({String? description, required File postImage,})async{
    bool isSubmitted =false;

    String userUid = _firebaseAuth.currentUser!.uid;
    FieldValue timeStamp = FieldValue.serverTimestamp();

    String? pictureUrl = await _fileUploadService.uploadPostFile(file: postImage);

    if(pictureUrl != null){
      await _postCollection.doc().set({
        "description": description,
        "image_url":pictureUrl,
        "createdAt": timeStamp,
        "user_uid": userUid,
      }).then((_){
        isSubmitted = true;
        setMessage('Post submitted successfully');
      }).catchError((onError){
        isSubmitted =false;
        setMessage('$onError');
      }).timeout(const Duration(seconds: 60), onTimeout: (){
        isSubmitted = false;
        setMessage('Please check your internet connection');
      });
    }else{
      isSubmitted= false;
      setMessage('Image upload failed!');
    }
    return isSubmitted;
  }

  Stream<QuerySnapshot<Map<String, dynamic>?>>getAllPosts(){
    return _postCollection.orderBy('createdAt',descending: true).snapshots();
  }

  Future<Map<String, dynamic>?> getUserInfo(String userUid)async{
    Map<String, dynamic>? userData;
    await _userCollection.doc(userUid).get().then((DocumentSnapshot<Map<String,dynamic>> doc){
      if(doc.exists){
        userData = doc.data();
      }else{
        userData=null;
      }
    });
    return userData;
  }
}
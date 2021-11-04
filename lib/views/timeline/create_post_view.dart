import 'dart:io';
import 'package:familicious/manager/post_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicons/unicons.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({Key? key}) : super(key: key);

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController _postTextController = TextEditingController();

  final PostManager _postManager=PostManager();
  File? _postImageFile;
  final ImagePicker _imagePicker=ImagePicker();
  bool isLoading=false;

  selectImage(ImageSource imageSource)async{
    XFile? file = await _imagePicker.pickImage(source: imageSource);
    setState(() {
      _postImageFile = File(file!.path);
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create new post',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          isLoading ? Center(child: CircularProgressIndicator.adaptive(),) : TextButton(onPressed: ()async{
            if (_postImageFile != null) {
              setState(() {
                isLoading=true;
              });
                bool isSubmitted = await _postManager.submitPost(
                    postImage: _postImageFile!,
                    description: _postTextController.text);
                    setState(() {
                      isLoading = false;
                    });
                    if(isSubmitted){
                      Fluttertoast.showToast(
                        msg: _postManager.message,toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16

                      );
                      Navigator.pop(context);
                    }else{
                      Fluttertoast.showToast(
                        msg: _postManager.message,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16,

                      );
                    }
              }else{
                Fluttertoast.showToast(
                  msg: "Please select your picture",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
          }, child: Text('Submit'),)
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Text(
            'Select a picture',
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            child: _postImageFile ==null ? Image.asset(
              'assets/pl2.jpg',
              height: 200,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ):Image.file(_postImageFile!,
            height: 200,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height:115,
                      child: Column(
                        children: [
                          TextButton.icon(
                            onPressed: (){
                              Navigator.pop(context);
                              selectImage(ImageSource.camera);
                            },
                            icon: Icon(UniconsLine.camera),
                            label: Text(
                              'Take a shot',
                            ),
                          ),

                          Divider(),

                          TextButton.icon(
                            onPressed: (){
                              Navigator.pop(context);
                              selectImage(ImageSource.gallery);
                            },
                            icon: Icon(UniconsLine.picture),
                            label: Text(
                              'Select from gallery',
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
          TextField(
            minLines: 3,
            maxLines: 10,
            controller: _postTextController,
            decoration: InputDecoration(
                hintText: 'Post description here',
                hintStyle: TextStyle(color: Colors.grey),
                label: Text(
                  'Description',
                  style: Theme.of(context).textTheme.bodyText1,
                )),
          ),


        ],
      ),
    );
  }
}

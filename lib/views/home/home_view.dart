import 'package:familicious/views/auth/login_view.dart';
import 'package:familicious/views/chat/chat_view.dart';
import 'package:familicious/views/favorite/favorite_view.dart';
import 'package:familicious/views/profile/profile_view.dart';
import 'package:familicious/views/timeline/timeline_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int _currentIndex = 0;
  final List<Widget> _views = [
    TimelineView(),
    const ChatView(),
    const FavouriteView(),
    const ProfileView(),
  ];

  //init state

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    // _firebaseAuth.signOut();
    isUserAuth();
    super.initState();
  }

  isUserAuth(){
    _firebaseAuth.authStateChanges().listen((user) {
      if(user ==null){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const LoginView()), (route) => false);
      }
     });
  }
  @override
  Widget build(BuildContext context) {
    return _firebaseAuth.currentUser ==null?const Center(child: CircularProgressIndicator()): Scaffold(
      
      body:
          // _views[_currentIndex]
          IndexedStack(
        children: _views,
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //making the bottom tabs work when clicked on
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        //contains not more than five items
        //if more, add a drawer
        //tabs are added to the appbar

        //itemColor
        //selected icon color and unselected
        selectedItemColor: Theme.of(context).iconTheme.color,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              UniconsLine.history,
            ),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              UniconsLine.comment_dots,
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              UniconsLine.heart,
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              UniconsLine.user,
            ),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}

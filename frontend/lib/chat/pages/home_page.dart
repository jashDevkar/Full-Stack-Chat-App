import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/chat/pages/all_friends.dart';
import 'package:frontend/chat/pages/all_users.dart';
import 'package:frontend/chat/pages/notification_page.dart';
import 'package:frontend/core/widgets/show_alert.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/services/chat/chat_service.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserModel _userModel;
  late ChatService chatService;

  final PageController _pageController = PageController();

  int _currentIndex = 0;
  late final List pages;

  @override
  void initState() {
    super.initState();

    chatService = ChatService(context);
    _userModel = BlocProvider.of<AuthBloc>(context).user;

    pages = [
      {'page': AllUsers(), 'title': 'swift chat', 'leading': true},
      {
        'page': AllFriends(chatService: chatService, userModel: _userModel),
        'title': 'Friends',
        'leading': false,
      },
    ];
    // log(_userModel.token);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // void _onPageChanged(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  // }

  void _onItemTapped(int index) {
    // _pageController.animateToPage(
    //   index,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeInOut,
    // );

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pages[_currentIndex]['title'],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions:
            pages[_currentIndex]['leading']
                ? [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: NotificationPage(),
                        ),
                      );
                    },
                    icon: Icon(Icons.notifications, color: Colors.white),
                  ),
                ]
                : null,
      ),

      drawer: Drawer(
        elevation: double.infinity,

        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.all(0),
              child: Column(
                spacing: 20,
                children: [
                  ClipOval(
                    child: Image(
                      image: NetworkImage(_userModel.imageUrl),
                      height: 70,
                      width: 70,
                    ),
                  ),
                  Text(_userModel.name, style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            ListTile(
              trailing: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                showAlert(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: GNav(
          selectedIndex: _currentIndex,
          onTabChange: _onItemTapped,
          rippleColor:
              Colors.grey.shade800, // tab button ripple color when pressed
          hoverColor: Colors.grey.shade700, // tab button hover color
          haptic: true,
          tabBorderRadius: 30,
          tabActiveBorder: Border.all(color: Colors.grey, width: 1),
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 900),
          gap: 24,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          color: Colors.grey[800],
          activeColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          tabs: [
            GButton(icon: Icons.people_alt, text: 'Users'),
            GButton(icon: Icons.inbox, text: 'Chats'),
          ],
        ),
      ),

      ///check is data is present else show a 'no user found text'
      ///every time on refresh show a
      body: pages[_currentIndex]['page'],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/chat/pages/all_friends.dart';
import 'package:frontend/chat/pages/all_users.dart';
import 'package:frontend/core/widgets/show_alert.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/services/chat/chat_service.dart';

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
      AllUsers(),
      AllFriends(chatService: chatService, userModel: _userModel),
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
      drawer: Drawer(
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurpleAccent,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Chat'),
        ],
      ),

      ///check is data is present else show a 'no user found text'
      ///every time on refresh show a
      body: pages[_currentIndex],
    );
  }
}



// PageView(
//         controller: _pageController,
//         onPageChanged: _onPageChanged,
//         children: [
//           AllUsers(),
//           AllFriends(chatService: chatService, userModel: _userModel),
//         ],
//       ),
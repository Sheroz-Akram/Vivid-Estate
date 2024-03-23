import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/BuyerHome.dart';
import 'package:vivid_estate_frontend_flutter/Chat/ChatHome.dart';
import 'package:vivid_estate_frontend_flutter/Profile/ProfileHome.dart';

class BuyerMain extends StatefulWidget {
  const BuyerMain({super.key});

  @override
  State<BuyerMain> createState() => _BuyerMain();
}

class _BuyerMain extends State<BuyerMain> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    BuyerHome(),
    const ChatHome(),
    const Text('Favourite Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    const ProfileHome(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // Our Main Page
        body: SafeArea(
          child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
        // Navigation bar
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          showUnselectedLabels: true,
          selectedItemColor: const Color(0xFF146479),
          unselectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_border_outlined),
              label: 'Favourite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
            ),
          ],
        ));
  }
}

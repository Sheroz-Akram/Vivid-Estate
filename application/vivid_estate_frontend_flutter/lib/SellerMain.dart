import 'package:flutter/material.dart';
import 'package:vivid_estate_frontend_flutter/Chat/ChatHome.dart';

class SellerMain extends StatefulWidget {
  const SellerMain({super.key});

  @override
  State<SellerMain> createState() => _SellerMain();
}

class _SellerMain extends State<SellerMain> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Dashboard Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    ChatHome(),
    Text('Ads Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
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
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
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
              icon: Icon(Icons.speed_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list_outlined),
              label: 'My Ads',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
            ),
          ],
        ));
  }
}

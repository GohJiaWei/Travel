import 'package:flutter/material.dart';
import 'package:travel/chatbot/chatbot.dart';
import 'package:travel/nav_bar.dart';
import 'package:travel/pages/home.dart';
import 'package:travel/schedule/schedule.dart';
import 'package:travel/translator/translator.dart';
import 'package:travel/wishlist/wishlist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static void navigateToPage(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_HomeScreenState>();
    state?._onItemTapped(index);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      if ((index - _selectedIndex).abs() > 1) {
        _pageController.jumpToPage(index);
      } else {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const <Widget>[
          HomePage(),
          SchedulePage(),
          TranslatorPage(),
          WishlistPage(),
          ChatBotPage(),
        ],
      ),
      bottomNavigationBar: CurvedNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

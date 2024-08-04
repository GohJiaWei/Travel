import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CurvedNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CurvedNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 20,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: selectedIndex,
        items: List.generate(_navBarItems.length, (index) {
          final iconData = _navBarItems[index]['icon'];
          final label = _navBarItems[index]['label'];
          final isSelected = selectedIndex == index;
          final padding = isSelected ? 5.0 : 25.0;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: padding),
                child: Stack(
                  children: [
                    Icon(
                      iconData,
                      size: isSelected ? 35 : 28,
                      color: isSelected
                          ? Color.fromARGB(255, 33, 138, 194)
                          : Color.fromARGB(255, 127, 160, 194),
                    ),
                    if (isSelected)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.1),
                                spreadRadius: 20,
                                blurRadius: 50,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              if (!isSelected)
                Text(
                  label,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 170, 200, 200),
                      fontSize: MediaQuery.of(context).size.width * 0.025),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
            ],
          );
        }),
        onTap: onItemTapped,
      ),
    );
  }
}

const List<Map<String, dynamic>> _navBarItems = [
  {'icon': Icons.home, 'label': 'Home'},
  {'icon': Icons.timeline_outlined, 'label': 'Schedule'},
  {'icon': Icons.mic, 'label': 'Translator'},
  {'icon': Icons.favorite_border, 'label': 'Wishlist'},
  {'icon': Icons.smart_toy, 'label': 'AI Chat Bot'},
];

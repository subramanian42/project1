import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project1/models/user.dart' as model;
import '../utils/colors.dart';
import '../utils/global_variable.dart';
import '../widgets/bottombar_item.dart';


class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: getBottomBar(),

    );
  }


  Widget getBottomBar() {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25)
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black87.withOpacity(0.1),
                blurRadius: .5,
                spreadRadius: .5,
                offset: Offset(0, 1)
            )
          ]
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomBarItem(Icons.home_rounded, "", isActive: _page == 0, activeColor: Colors.black,
                  onTap: () {
                    setState(() {
                      _page = 0;
                    });
                    pageController.jumpToPage(_page);
                  },
                ),
                BottomBarItem(Icons.play_circle, "", isActive: _page == 1, activeColor: Colors.black,
                  onTap: () {
                    setState(() {
                      _page = 1;
                    });
                    pageController.jumpToPage(_page);
                    },
                ),
                BottomBarItem(Icons.add_circle_rounded, "", isActive: _page == 2, activeColor: Colors.black,
                  onTap: () {
                    setState(() {
                      _page = 2;
                    });
                    pageController.jumpToPage(_page);
                  },
                ),
                BottomBarItem(Icons.hourglass_bottom, "", isActive: _page == 3, activeColor: Colors.black,
                  onTap: () {
                    setState(() {
                      _page = 3;
                    });
                    pageController.jumpToPage(_page);
                  },
                ),
                BottomBarItem(Icons.person_rounded, "", isActive: _page == 4, activeColor: Colors.black,
                  onTap: () {
                    navigationTapped;
                    setState(() {
                      _page = 4;
                    });
                    pageController.jumpToPage(_page);
                  },
                ),
              ]
          )
      ),
    );
  }

}
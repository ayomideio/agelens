import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:readmitpredictor/ui/auth/get-started.dart';
import 'package:readmitpredictor/ui/auth/signup.dart';

import 'package:readmitpredictor/ui/welcome/onboarding.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: WelcomePageView(),
    );
  }
}

class WelcomePageView extends StatefulWidget {
  const WelcomePageView({Key? key}) : super(key: key);

  @override
  _WelcomePageViewState createState() => _WelcomePageViewState();
}

class _WelcomePageViewState extends State<WelcomePageView> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToSignUpScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => GetStarted()));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
              if (index == 2) {
                // Check if it's the last page
                _navigateToSignUpScreen();
              }
            },
            children: [
              WelcomePage(
                imageAsset: "assets/vectors/onb1.png",
                title: OnBoardingText.title1,
                subTitle: OnBoardingText.subTitle1,
                lastTitle: OnBoardingText.lastTitle1,
              ),
              WelcomePage(
                imageAsset: "assets/vectors/onb2.png",
                title: OnBoardingText.title2,
                subTitle: OnBoardingText.subTitle2,
                lastTitle: OnBoardingText.lastTitle2,
              ),
              WelcomePage(
                imageAsset: "assets/vectors/onb3.png",
                title: OnBoardingText.title3,
                subTitle: OnBoardingText.subTitle3,
                lastTitle: OnBoardingText.lastTitle3,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
          child:

              // _currentPageIndex==3?
              PageViewDotIndicator(
            currentItem: _currentPageIndex,
            count: 3,
            unselectedColor: Color(0xff7F7F7F),
            selectedColor: Color(0xff61E3A5F),
            duration: const Duration(milliseconds: 200),
            boxShape: BoxShape.circle,
            onItemClicked: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
      ],
    );
  }
}

class WelcomePage extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subTitle;
  final String lastTitle;

  const WelcomePage({
    Key? key,
    required this.imageAsset,
    required this.title,
    required this.subTitle,
    required this.lastTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Image.asset(
            imageAsset,
            height: screenSize.height / 3,
          ),
          SizedBox(height: screenSize.height / 15),
          Container(
            width: screenSize.width / 1.1,
            height: 200,
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Color(0xff61E3A5F),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    color: Color(0xff61E3A5F),
                    fontSize: 14,
                  ),
                ),
                Text(
                  lastTitle,
                  style: TextStyle(
                    color: Color(0xff61E3A5F),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

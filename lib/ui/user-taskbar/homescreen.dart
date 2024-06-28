import 'package:readmitpredictor/ui/constants/index.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'wallets.dart';
import 'track.dart';
import 'package:flutter/material.dart';
import 'orders.dart';
import 'home.dart';
import 'dart:math';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isVisible = false;
  bool isTextFieldFocused = false;
  int currentIndex = 0;
  int selectedTabIndex = 0;
  String wallBalance = "0";
  String name = '';
  String phone = '';
  String avatar = '';
  String fundAmount = '';
  bool isFundWallet = false;
  String replaceSpaceWithDotAndSpace(String input) {
    return input.replaceAll(" ", ". ");
  }

// 0852
  Future<void> _getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String _name = pref.getString('firstName').toString();

    // print("The phone number " + _phone);

    setState(() {
      name = replaceSpaceWithDotAndSpace(_name);
    });
  }

  final FocusNode _focusNode =
      FocusNode(); // The index of the currently selected menu item

  List listOfIcons = [
    'assets/vectors/home.png',
    
    'assets/vectors/profile.png',
  ];

  List<String> listOfLabels = [
    'Home',
    
    'About',
  ];

  getShipmentStatus<String>(tabSelected) {
    switch (tabSelected) {
      case 0:
        return "";
      case 1:
        return "completed";
      case 2:
        return 'in-progress';
      case 3:
        return 'pending';
      case 4:
        return 'cancelled';
    }
  }

  void onMenuItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  late AnimationController _animationController;
  late Animation<double> _animation;
  String _shippingNumber = "";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 10),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    _getName();

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // TextField is focused
      print('TextField is focused');
      setState(() {
        isTextFieldFocused = true;
      });
    } else {
      // TextField lost focus
      setState(() {
        isTextFieldFocused = false;
      });
      print('TextField lost focus');
    }
  }
  // sk_test_7ff11e45c13a47b776de911e4f9cdaf22b43c794
  // pk_test_74784e0da0389b0b4f4bea51e6a70d41574496d9

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<BottomNavigationBarItem> bottomNavBarItems = List.generate(
      listOfIcons.length,
      (index) => BottomNavigationBarItem(
        icon: Image.asset(
          listOfIcons[index],
          height: 20,
          color: currentIndex == index ? Colors.black : Colors.black38,
        )
        // Icon(
        //   listOfIcons[index],
        //
        // )
        ,
        label: listOfLabels[index],
      ),
    );

    List<Widget> overlayItems = List.generate(
      listOfIcons.length,
      (index) => Positioned(
        left:
            (index * (MediaQuery.of(context).size.width / listOfIcons.length)) +
                (MediaQuery.of(context).size.width / listOfIcons.length / 2) -
                20,
        bottom: 12,
        child: Text(
          listOfLabels[index],
          style: TextStyle(
            color: currentIndex == index ? Colors.yellow : Colors.black,
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: _getAppBarWidget(size),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: _getBodyWidget(),
      ),
      bottomNavigationBar:
          //  currentIndex == 2 || currentIndex == 1
          //     ? SizedBox()
          //     :

          Stack(
        children: [
          BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: currentIndex,
            onTap: onMenuItemTapped,
            items: bottomNavBarItems,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.black38,
            selectedItemColor: Colors.black,
            selectedLabelStyle: TextStyle(
                color: Color(
                  0xff553A9D,
                ),
                fontSize: 10,
                fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
              color: Color(
                0xff553A9D,
              ),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Positioned(
            left: (currentIndex *
                (MediaQuery.of(context).size.width / listOfIcons.length)),
            top: 1,
            child: Container(
              height: 3,
              width: MediaQuery.of(context).size.width / listOfIcons.length,
              color: ColorStyles.primaryButtonColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabItem(int index, IconData icon, String title, String count) {
    final isSelected = selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 4.0,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8.0),
                  Text(
                    title,
                    style: TextStyle(
                        color: isSelected ? Colors.black : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 8.0),
                  count.isEmpty
                      ? SizedBox()
                      : Container(
                          height: 25,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: isSelected ? Colors.black : Colors.black,
                          ),
                          child: Center(
                            child: Text(
                              count,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 8,
              )
            ],
          )),
    );
  }

  PreferredSizeWidget _getAppBarWidget(size) {
    switch (currentIndex) {
      case 0:
        return PreferredSize(
          preferredSize: Size.fromHeight(165),
          child: Container(
            decoration: BoxDecoration(
              color: ColorStyles.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 20,
                                  backgroundImage: AssetImage('assets/vectors/splash.png'),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              'Hi, $name',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height / 80,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                            "Let's access your readmission \nrisk and improve your \n healthcare journey.",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ],
                  )),
            ),
          ),
        );

      case 1:
        return PreferredSize(
          preferredSize: Size.fromHeight(size.height / 6),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage('assets/vectors/appbar.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   ],
                ),
              ),
            ),
          ),
        );

      case 2:
        return PreferredSize(
          preferredSize: Size.fromHeight(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.2),
              //     blurRadius: 2.0,
              //     spreadRadius: 1.0,
              //   ),
              // ],
            ),
          ),
        );

      default:
        return PreferredSize(
          child: Container(),
          preferredSize: isTextFieldFocused
              ? Size.fromHeight(size.height / 14)
              : Size.fromHeight(size.height / 6),
        );
    }
  }

  Widget _getBodyWidget() {
    switch (currentIndex) {
      case 0:
        return isTextFieldFocused
            ? FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: ModalRoute.of(context)!.animation!,
                    curve: Curves.easeIn,
                  ),
                ),
                child: Track(shippingNumber: _shippingNumber),
              )
            : Home(fullname: name, phone: phone);
        ;
      case 1:
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeIn,
            ),
          ),
          child: Orders(phone: phone),
        );
      case 2:
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeIn,
            ),
          ),
          child: wallets(
              selectedTab: getShipmentStatus(selectedTabIndex),
              fullname: name,
              telephone: avatar),
        );
      default:
        return Container();
    }
  }
}

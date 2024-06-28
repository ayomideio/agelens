import 'package:readmitpredictor/ui/constants/index.dart';
import 'package:readmitpredictor/ui/user-taskbar/models/drink.dart';

import 'package:readmitpredictor/ui/widgets/success.dart';

import 'homescreen.dart';
import 'package:flutter/material.dart';

class ClubDrink extends StatefulWidget {
  final String clubname;
  final String fullname;
  final String phone;
  const ClubDrink(
      {super.key,
      required this.clubname,
      required this.fullname,
      required this.phone});

  @override
  State<ClubDrink> createState() => _ClubDrinkState();
}

class _ClubDrinkState extends State<ClubDrink>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final int startValue = 1091;
  int item = 1;
  double amount = 20;
  final int endValue = 14300;
  bool isTextFieldFocused = false;
  final Duration duration = Duration(seconds: 5);
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animation = Tween<double>(
      begin: startValue.toDouble(),
      end: endValue.toDouble(),
    ).animate(curvedAnimation);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();

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

  void _showBottomAlert(BuildContext context, Drink drink) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(
                width: 1,
                color: Color(0xff90DDE8),
              ),
              color: Color(0xff90DDE8).withOpacity(.1),
            ),
            height: 800,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage(drink.category == 'cocktails'
                        ? 'assets/vectors/cocktail.png'
                        : drink.category == 'bottle'
                            ? 'assets/vectors/bottle.png'
                            : drink.category == 'shots'
                                ? 'assets/vectors/shot.png'
                                : ''),
                    fit: BoxFit.fitHeight,
                  ),
                  // color: Colors.grey
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
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
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/vectors/back.png',
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(60, 20, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                color: Color(0xff320E0E),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    focusNode: _focusNode,
                                    decoration: InputDecoration(
                                      hintText: 'Search Drinks',
                                      hintStyle: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width / 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // backgroundColor: Colors.transparent,
      body: Container(
        color: Color(0xff90DDE8).withOpacity(.1),
        height: size.height,
        child: SingleChildScrollView(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                  child: Row(
                    children: [
                      Text(
                        widget.clubname + " Drinks",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  "Tap on the plus icon  to buy a drink ",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Colors.deepPurple.withOpacity(.8)),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 20, 0, 0),
                child: Container(
                  height: size.height / 1.8,
                  width: size.width / 1.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),

      // floatingActionButton: Stack(children: [
      //   Positioned(
      //     top:390,
      //     left:MediaQuery.of(context).size.width/2-20,
      //     child: FloatingActionButton(onPressed: () {

      //   },

      //   child:Icon(Icons.search)
      //   ))
      // ]),
    );
  }
}

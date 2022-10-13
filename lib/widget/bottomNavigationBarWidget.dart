import 'package:chalkboard/screen/myDocuments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../screen/home_screen.dart';
import '../screen/my_donation_screen.dart';
import '../screen/Account_Screen.dart';
import '../screen/sign_up_and_user_detail_screen.dart';
import '../services/auth.dart';
import 'badge.dart';
import 'navigationDrawerWidget.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key, required this.newuser})
      : super(key: key);
  final bool newuser;
  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;
  String title = 'CHALKBOARD';

  void _logout(BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    await auth.signOut();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      title = 'CHALKBOARD';
    } else if (index == 1) {
      title = 'VOLUNTEER';
    } else if (index == 2) {
      title = 'DONATIONS';
    } else if (index == 3) {
      title = 'ACCOUNT';
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.newuser) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) {
            return SignUpScreen(isThirdpartySignup: true);
          },
        ));
      });
    }
  }

  void moveToCartScreen() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void moveToDonationScreen() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return widget.newuser
        ? Container(
            color: Colors.white70,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
          )
        : WillPopScope(
            onWillPop: () {
              if (_selectedIndex != 0) {
                setState(() {
                  _selectedIndex = 0;
                });
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Scaffold(
              drawer: NavigationDrawerWidget(),
              appBar: AppBar(
                title: Text(title),
                // leading: IconButton(
                //   icon: Icon(Icons.menu),
                //   onPressed: () {
                //
                //   },
                // ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.notifications_none),
                    onPressed: () {},
                  ),
                  Consumer<User?>(
                    builder: (ctx, user, child) => Badge(
                      value: user!.cartItemCount.toString(),
                      color: Colors.blue,
                      child: IconButton(
                        icon: Icon(Icons.volunteer_activism),
                        onPressed: moveToDonationScreen,
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () => {_logout(context)},
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.blue],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
              ),
              body: IndexedStack(
                children: [
                  HomeScreen(),
                  MyDocuments(uid: auth.currentuser!.uid,),
                  MyDonationScreen(),
                  AccountScreen(),
                ],
                index: _selectedIndex,
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                    backgroundColor: Colors.blue,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.man_outlined),
                    label: 'Volunteer',
                    backgroundColor: Colors.blue,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.volunteer_activism),
                    label: 'Donations',
                    backgroundColor: Colors.blue,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Account',
                    backgroundColor: Colors.blue,
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.orange,
                onTap: _onItemTapped,
              ),
            ),
          );
  }
}

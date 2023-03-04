import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../services/auth.dart';
import '../services/cacheManager.dart';
import '../widget/navigationDrawerWidget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // final padding = EdgeInsets.symmetric(horizontal: 20);
  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'ହିନ୍ଦୀ', 'locale': Locale('hi', 'IN')},
    {'name': 'ଓଡିଆ', 'locale': Locale('od', 'IN')},
    {'name': 'தமிழ்', 'locale': Locale('tam', 'IN')},
    {'name': 'తెలుగు', 'locale': Locale('tel', 'IN')},
  ];

updatelanguage(Locale locale){
  Get.back();
  Get.updateLocale(locale); 
}
  builddialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Choose a language'.tr),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            updatelanguage(locale[index]['locale']);
                          },
                          child: Text(
                            locale[index]['name'],
                          ),
                        ));
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.blue,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                Consumer<User?>(
                  builder: (_, user, __) => buildHeader(
                    urlImage:
                        user!.profileUrl == null ? null : user.profileUrl!,
                    name: '${user.firstName} ${user.lastName}',
                    email: '${user.email}',
                    joinOn:
                        '${user.joinedOn.year}-${user.joinedOn.month}-${user.joinedOn.day}',
                    onClicked: () {
                      final auth = Provider.of<Auth>(context, listen: false);
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => UploadProfileImg(
                              currentuser: user,
                              uid: auth.currentuser!.uid,
                            )),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ButtonCard(
                  press: () {},
                  title: 'My Profile'.tr,
                  icon: Icon(Icons.account_circle),
                ),
                ButtonCard(
                  press: () {
                    builddialog(context);
                  },
                  title: 'Change Language'.tr,
                  icon: Icon(Icons.language),
                ),
                ButtonCard(
                  press: () {},
                  title: 'My  Cart'.tr,
                  icon: Icon(Icons.shopping_cart),
                ),
                ButtonCard(
                  press: () {},
                  title: 'My Donations'.tr,
                  icon: Icon(Icons.shopping_bag),
                ),
                ButtonCard(
                  press: () {},
                  title: 'Terms and conditions'.tr,
                  icon: Icon(Icons.note),
                ),
                ButtonCard(
                  press: () {},
                  title: 'Share with Friends'.tr,
                  icon: Icon(Icons.share),
                ),
                ButtonCard(
                  press: () {},
                  title: 'About Us'.tr,
                  icon: Icon(Icons.developer_board),
                ),
                ButtonCard(
                  press: () {},
                  title: 'Exit'.tr,
                  icon: Icon(Icons.exit_to_app),
                ),
                ButtonCard(
                  press: () {
                    AppCacheManager.documentCacheManager.emptyCache();
                    AppCacheManager.profilecacheManager.emptyCache();
                    final auth = Provider.of<Auth>(context, listen: false);
                    auth.signOut();
                  },
                  title: 'Sign Out'.tr,
                  icon: Icon(Icons.logout),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget buildHeader({
  String? urlImage,
  required String name,
  required String email,
  required VoidCallback onClicked,
  required String joinOn,
}) =>
    Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(children: [
            urlImage == null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "assets/images/avatar.png",
                      height: 130.0,
                      width: 130.0,
                    ),
                  )
                : CircleAvatar(
                    radius: 75,
                    backgroundImage: CachedNetworkImageProvider(
                      urlImage,
                      cacheManager: AppCacheManager.profilecacheManager,
                    ),
                  ),
            Positioned(
                bottom: 0,
                right: -5,
                child: IconButton(
                  icon: Icon(
                    Icons.circle,
                    size: 35,
                    color: Colors.blue,
                  ),
                  onPressed: onClicked,
                )),
            Positioned(
                bottom: 0,
                right: -6,
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 25,
                    color: Colors.white,
                  ),
                  onPressed: onClicked,
                )),
          ]),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name.tr,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                "Member Since: ${joinOn}",
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );

class ButtonCard extends StatelessWidget {
  const ButtonCard({
    Key? key,
    required this.title,
    required this.press,
    required this.icon,
  }) : super(key: key);
  final String title;
  final VoidCallback press;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: InkWell(
        onTap: press,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blue[200],
            // gradient: LinearGradient(
            //   colors: [Colors.green, Colors.blue],
            //   begin: Alignment.topRight,
            //   end: Alignment.bottomLeft,
            // ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              Text(
                title,
                style: TextStyle(fontSize: 17.0),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}

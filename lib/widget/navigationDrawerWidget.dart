import 'dart:io';

import 'package:chalkboard/screen/Account_Screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../services/auth.dart';
import '../services/cacheManager.dart';
import '../services/firestoreApi.dart';

class NavigationDrawerWidget extends StatefulWidget {

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  bool uploading = false;
  @override
  Widget build(BuildContext context) {
    void _logout(BuildContext context) async {
      final auth = Provider.of<Auth>(context, listen: false);
      await auth.signOut();
    }

    return Drawer(
      child: Material(
        color: Colors.blue[200],
        child: ListView(
          children: <Widget>[
            Consumer<User?>(
              builder: (_, user, __) => buildHeader(
                urlImage: user!.profileUrl == null ? null : user.profileUrl!,
                name: '${user.firstName} ${user.lastName}',
                email: '${user.email}',
                phone: '${user.phoneNumber}',
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
            Divider(color: Colors.white70),
            Container(
              padding: padding,
              child: Column(
                children: [
                  Divider(color: Colors.white70),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'My Donations',
                    icon: Icons.shopping_bag,
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Volunteer',
                    icon: Icons.shopping_cart,
                    // onClicked: () {
                    //   final auth = Provider.of<Auth>(context, listen: false);
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => ProfileScreen()));
                    // },
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Updates',
                    icon: Icons.update,
                    onClicked: () {},
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Notifications',
                    icon: Icons.notifications_outlined,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'About Us',
                    icon: Icons.developer_board,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.account_tree_outlined,
                    onClicked: () {
                      AppCacheManager.documentCacheManager.emptyCache();
                      AppCacheManager.profilecacheManager.emptyCache();
                      final auth = Provider.of<Auth>(context, listen: false);
                      auth.signOut();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    String? urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked, required String phone,
  }) =>
      Container(
        padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
        child: Column(
          children: [
            Stack(children: [
              urlImage == null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  "images/avatar.png",
                  height: 130.0,
                  width: 130.0,
                ),
              )
                  : CircleAvatar(
                radius: 65,
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
                  name,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      );

  Widget buildSearchField() {
    final color = Colors.white;

    return TextField(
      style: TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        prefixIcon: Icon(Icons.search, color: color),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
    // case 0:
    //   Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => ManageMyHealth(),
    //   ));
    //   break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AccountScreen(),
        ));
        break;
    }
  }
}

class UploadProfileImg extends StatefulWidget {
  const UploadProfileImg(
      {Key? key, required this.currentuser, required this.uid})
      : super(key: key);
  final User currentuser;
  final String uid;

  @override
  _UploadProfileImgState createState() => _UploadProfileImgState();
}

class _UploadProfileImgState extends State<UploadProfileImg> {
  final ImagePicker _picker = ImagePicker();
  bool uploading = false;

  void takePhoto(ImageSource source, String uid, User user) async {
    final image = await _picker.pickImage(source: source);
    if (image == null) return;

    final pickedImage = File(image.path);
    try {
      setState(() {
        uploading = true;
      });
      await FirestoreApi.uploadProfilePicture(uid, pickedImage, user);
      AppCacheManager.deleteProfilecache();
      setState(() {
        uploading = false;
      });

      Navigator.of(context).pop();
    } on Exception catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to upload image: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            uploading
                ? "uploading profile picture ..."
                : "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (!uploading)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera, widget.uid, widget.currentuser);
                },
                label: Text("Camera"),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(
                      ImageSource.gallery, widget.uid, widget.currentuser);
                },
                label: Text("Gallery"),
              ),
            ]),
          if (uploading)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}

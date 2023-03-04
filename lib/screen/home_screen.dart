import 'package:chalkboard/model/user.dart';
import 'package:chalkboard/services/auth.dart';
import 'package:chalkboard/widget/badge.dart';
import 'package:chalkboard/widget/navigationDrawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'VolunteerProfile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class Volunteer {
  final String username;
  final String email;
  final String urlAvatar;
  const Volunteer({
    required this.username,
    required this.email,
    required this.urlAvatar,
  });
}

class _HomeScreenState extends State<HomeScreen> {
  void _logout(BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    await auth.signOut();
  }

  @override
  void initState() {
    super.initState();
  }

  List<Volunteer> volunteers = [
    const Volunteer(
        username: 'Amlanjyoti Sahoo',
        email: 'iamamlan2002@gmail.com',
        // urlAvatar: Image.asset('assets/images/join.png'),
        urlAvatar:
            'https://media-exp1.licdn.com/dms/image/C4D03AQFHKN42v3lEuA/profile-displayphoto-shrink_400_400/0/1654916299732?e=1668643200&v=beta&t=W21h4_O6-k6Wo0ughzUl7TcGY7sb1ARQZo5BcnwK8dA'),
            const Volunteer(
        username: 'Ashutosh Sahoo',
        email: 'ashutoshsahoo247@gmail.com',
        // urlAvatar: Image.asset('assets/images/join.png'),
        urlAvatar:
            'https://media-exp1.licdn.com/dms/image/C5603AQGu1J9x-_-WWw/profile-displayphoto-shrink_100_100/0/1598973156878?e=1668643200&v=beta&t=XZqGbQtX8zP9USc4jnVITm3uQuLMeyUEbJFO9GMBads'),
            const Volunteer(
        username: 'Debasish Behera',
        email: 'debasishbehera@gmail.com',
        // urlAvatar: Image.asset('assets/images/join.png'),
        urlAvatar:
            'https://media-exp1.licdn.com/dms/image/D5635AQGx-5jiVKPyAA/profile-framedphoto-shrink_100_100/0/1657030106258?e=1664010000&v=beta&t=qr3jSJFyt8eW9kWu1XYn8ZYoFYwpO4FW831aEjDq7Z8'),
            const Volunteer(
        username: 'Bishal Patel',
        email: 'bishalpatel9861@gmail.com',
        // urlAvatar: Image.asset('assets/images/join.png'),
        urlAvatar:
            'https://media-exp1.licdn.com/dms/image/C5603AQF4rHP97z1K2Q/profile-displayphoto-shrink_400_400/0/1608911460403?e=1668643200&v=beta&t=THEe0VfevbLgdiZHkpetNJGXr3jexKOdvlxiaVTtWeA'),
  ];
  final List<String> imageList = [
    "https://images.unsplash.com/flagged/photo-1574097656146-0b43b7660cb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2hpbGRyZW4lMjBlZHVjYXRpb258ZW58MHx8MHx8&w=1000&q=80",
    'https://www.aljazeera.com/mritems/Images/2016/5/11/1c15e64956214db39142d04240fd79bd_8.jpg',
    'https://media.istockphoto.com/photos/school-children-writing-on-slate-picture-id648418766?b=1&k=20&m=648418766&s=170667a&w=0&h=DsoMirs_E7YcRafNsZNOp_ueEb7oaV5FSZCwkz1cOSk=',
    'https://cdn.givind.org/static/images/update/2020-07-05-SevaMandir_Helpruraltribalchildrenaccesseducation_2.JPG'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            child: CarouselSlider.builder(
              itemCount: imageList.length,
              options: CarouselOptions(
                enlargeCenterPage: true,
                height: 300,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                reverse: false,
                aspectRatio: 5.0,
              ),
              itemBuilder: (context, i, id) {
                //for onTap to redirect to another screen
                return GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white,
                        )),
                    //ClipRRect for image border radius
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        imageList[i],
                        width: 500,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    var url = imageList[i];
                    print(url.toString());
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Image.asset('assets/images/join.png'),
          ),
          SizedBox(height:10),
          Text(
            'Weekly Top Volunteers'.tr,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold,
            fontSize: 25),
          ),
          
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30),
              height: 500,
              width: double.infinity,
              child: ListView.builder(
                itemCount: volunteers.length,
                itemBuilder: (context, index) {
                  final volunteer = volunteers[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(volunteer.urlAvatar),
                      ),
                      title: Text(volunteer.username.tr),
                      subtitle: Text(volunteer.email),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => VolunteerProfile(volunteer:volunteer)));
                      },
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    ));
  }
}

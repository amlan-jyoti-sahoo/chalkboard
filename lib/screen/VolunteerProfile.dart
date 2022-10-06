
import 'package:chalkboard/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:chalkboard/main.dart';

class VolunteerProfile extends StatelessWidget {
  final Volunteer volunteer;
  const VolunteerProfile({
    Key? key,
    required this.volunteer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(volunteer.username),
        ),
        body: Center(
            child: Column(
          children:<Widget> [
              Image.network(volunteer.urlAvatar,
              height: 400,
              width: double.infinity,
              fit:BoxFit.cover),
              const SizedBox(height: 16,),
              Text(volunteer.username,style: const TextStyle(fontSize: 40,
              fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Container(padding:EdgeInsets.all(20),child: Text("Joined on 12/04/2022. Contributing many voluteer activity. All total 24 session of taken. ",style: const TextStyle(fontSize: 20),)),
          ],
        )),
      );
}

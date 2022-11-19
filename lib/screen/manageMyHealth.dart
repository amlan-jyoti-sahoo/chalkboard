import 'package:chalkboard/widget/healthdata.dart';
import 'package:chalkboard/widget/uploadImage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ManageMyHealth extends StatefulWidget {
  const ManageMyHealth({Key? key, required this.uid}) : super(key: key);

  final String uid;

  static const routeName = '/Manage-My-Health';

  @override
  _ManageMyHealthState createState() => _ManageMyHealthState();
}

class _ManageMyHealthState extends State<ManageMyHealth> {
  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text('Session Data'),
          content: const Center(
            child: HealthData(),
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: const Text('Upload'),
            content: Center(
              child: UploadImage(
                uid: widget.uid,
              ),
            )),
        Step(
            state: StepState.editing,
            isActive: _activeStepIndex >= 2,
            title: const Text('Confirm'),
            content: const Center(
              child: Text('Confirm'),
            )),
      ];

  int _activeStepIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Session Report"),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _activeStepIndex,
        steps: stepList(),
        onStepContinue: () {
          if (_activeStepIndex < (stepList().length - 1)) {
            _activeStepIndex += 1;
          }
          if(_activeStepIndex == 2){
            Fluttertoast.showToast(
        msg: "Session Report Uploaded Succesfully!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 21, 163, 219),
        textColor: Colors.white,
        fontSize: 16.0
    );
            Navigator.pop(context);

          }
          setState(() {});
        },
        onStepCancel: () {
          if (_activeStepIndex == 0) {
            return;
          }
          _activeStepIndex -= 1;
          setState(() {});
        },
      ),
    );
  }
}

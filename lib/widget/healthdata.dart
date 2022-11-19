import 'package:flutter/material.dart';

class HealthData extends StatefulWidget {
  const HealthData({Key? key}) : super(key: key);

  @override
  State<HealthData> createState() => _HealthDataState();
}

enum RecentlyDiagnosed { Yes, No }
enum ChronicDisease { Yes, No }
enum EyeSightProblem { Yes, No }

class _HealthDataState extends State<HealthData> {
  String? valueBloodGroup;
  RecentlyDiagnosed? _recentlyDiagnosed = RecentlyDiagnosed.No;
  ChronicDisease? _chronicDisease = ChronicDisease.No;
  EyeSightProblem? _eyeSightProblemDisease = EyeSightProblem.No;
  final bloodGroups = ['30min','45min','1hour','2hour','3hour'];

  /* TextField input controllers */
  final recentlyDiagnosedController = TextEditingController();
  final chronicDiseaseController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final eyeSightProblemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
          ),
        );

    return SingleChildScrollView(
      child: Column(
        children: [
          /* *start*  Blood Group input section */
          Row(
            children: [
              const Text(
                "Session Time:  ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: valueBloodGroup,
                    iconSize: 36,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.amber),
                    items: bloodGroups.map(buildMenuItem).toList(),
                    onChanged: (valueBloodGroup) =>
                        setState(() => this.valueBloodGroup = valueBloodGroup!),
                  ),
                ),
              ),
            ],
          ),
          /* *end*  Blood Group input section */

          const SizedBox(
            height: 10,
          ),
          // ElevatedButton(
          //     onPressed: showDoneDialog, child: Text("hello press me")),

          /* *start* height input section */
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                width: 110.0,
                height: 40.0,
                child: Text(
                  'Students:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 210.0,
                height: 40.0,
                child: TextField(
                  controller: heightController,
                  decoration: InputDecoration(
                    labelText: 'enter the NO.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => heightController.clear(),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
          /* *end* height input section */

          SizedBox(
            height: 10,
          ),

          /* *start* weight input section */
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                width: 90.0,
                height: 40.0,
                child: Text(
                  'Location:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 210.0,
                height: 40.0,
                child: TextField(
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: 'street Name.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => weightController.clear(),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
          /* *end* weight input section */

          const SizedBox(
            height: 10,
          ),

          //**start** Recently Diagnosed input section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Supply the study kits: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Yes'),
                    leading: Radio<RecentlyDiagnosed>(
                      value: RecentlyDiagnosed.Yes,
                      groupValue: _recentlyDiagnosed,
                      onChanged: (RecentlyDiagnosed? value) {
                        setState(() {
                          _recentlyDiagnosed = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('No'),
                    leading: Radio<RecentlyDiagnosed>(
                      value: RecentlyDiagnosed.No,
                      groupValue: _recentlyDiagnosed,
                      onChanged: (RecentlyDiagnosed? value) {
                        setState(() {
                          _recentlyDiagnosed = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              //text field for recentlyDiagnosedController
              if (_recentlyDiagnosed == RecentlyDiagnosed.Yes)
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  controller: recentlyDiagnosedController,
                  decoration: InputDecoration(
                    labelText: 'Mention in Details:',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => recentlyDiagnosedController.clear(),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          //**End** Recently Diagnosed input section

          //**start** Suffering from any chronic disease input section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Any Extra Fun activity Conducted: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Yes'),
                    leading: Radio<ChronicDisease>(
                      value: ChronicDisease.Yes,
                      groupValue: _chronicDisease,
                      onChanged: (ChronicDisease? value) {
                        setState(() {
                          _chronicDisease = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('No'),
                    leading: Radio<ChronicDisease>(
                      value: ChronicDisease.No,
                      groupValue: _chronicDisease,
                      onChanged: (ChronicDisease? value) {
                        setState(() {
                          _chronicDisease = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              //text field for chronicDiseaseController
              if (_chronicDisease == ChronicDisease.Yes)
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  controller: chronicDiseaseController,
                  decoration: InputDecoration(
                    labelText: 'Mention the Details:',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => chronicDiseaseController.clear(),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          //**End** Suffering from any chronic disease input section

          //**start** Eye sight Problems input section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Do the Children are Statisfied: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Yes'),
                    leading: Radio<EyeSightProblem>(
                      value: EyeSightProblem.Yes,
                      groupValue: _eyeSightProblemDisease,
                      onChanged: (EyeSightProblem? value) {
                        setState(() {
                          _eyeSightProblemDisease = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('No'),
                    leading: Radio<EyeSightProblem>(
                      value: EyeSightProblem.No,
                      groupValue: _eyeSightProblemDisease,
                      onChanged: (EyeSightProblem? value) {
                        setState(() {
                          _eyeSightProblemDisease = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              //text field for eyeSightProblemController
              if (_eyeSightProblemDisease == EyeSightProblem.Yes)
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  controller: eyeSightProblemController,
                  decoration: InputDecoration(
                    labelText: 'Mention in Deatils:',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => eyeSightProblemController.clear(),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
            ],
          ),
          //**End** Eye sight Problems input section
        ],
      ),
    );
  }
}

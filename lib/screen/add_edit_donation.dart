import 'package:chalkboard/model/address.dart';
import 'package:chalkboard/model/donation.dart';
import 'package:chalkboard/model/user.dart';
import 'package:chalkboard/services/auth.dart';
import 'package:chalkboard/services/firestoreApi.dart';
import 'package:chalkboard/widget/alret_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class AddEditDonation extends StatefulWidget {
  const AddEditDonation(
      {Key? key, this.currentUser, this.isEditMode = false, this.donation})
      : super(key: key);

  final User? currentUser;
  final bool? isEditMode;
  final Donation? donation;

  @override
  _AddEditDonationState createState() => _AddEditDonationState();
}

class _AddEditDonationState extends State<AddEditDonation> {

  //for adding image
  bool uploading = false;
  double val = 0;
  late firebase_storage.Reference ref;
  late String imageUrl ;

  List<File> _image = [];
  final picker = ImagePicker();

  File? image;


  //------------------
  final _form = GlobalKey<FormState>();
  var _isLoading = false;

  late Donation food;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode!) {
      _foodnameController.text = widget.donation!.foodName;
      _foodQuantityContoller.text =
          widget.donation!.donationQuantity.toString();
      _foodTypeConntroller.text = widget.donation!.foodType;
      // _imageUrlController.text = widget.donation!.foodImageUrl;
    }
  }

  final _foodnameController = TextEditingController();
  final _foodQuantityContoller = TextEditingController();
  final _foodTypeConntroller = TextEditingController();
  // final _imageUrlController = TextEditingController();

  // @override
  // void dispose() {
  //   _imageUrlController.dispose();
  //   super.dispose();
  // }

  void _saveForm() async {
    final isVaild = _form.currentState!.validate();
    if (!isVaild) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final db = Provider.of<FirestoreApi>(context, listen: false);

      Address defaultAddress = await db.getUserDefaultAddress(
          widget.currentUser!.defaultAddressId, auth.currentuser!.uid);

      Donation newDonation = Donation(
        donorId: auth.currentuser!.uid,
        foodName: _foodnameController.text,
        foodImageUrl: imageUrl,
        ref: ref,
        foodType: _foodTypeConntroller.text,
        remainingQuantity: int.parse(_foodQuantityContoller.text),
        donationQuantity: int.parse(_foodQuantityContoller.text),
        donatedTime: DateTime.now(),
        expiredTime: DateTime.now().add(Duration(hours: 25)),
        donorName:
            '${widget.currentUser!.firstName} ${widget.currentUser!.lastName}',
        donorContact: widget.currentUser!.phoneNumber,
        status: 'available',
        address: defaultAddress, imgUploadTime: DateTime.now(),
      );
      if (widget.isEditMode == true) {
        await db.editDonation(newDonation, widget.donation!.donationId!);
      } else {
        await db.postDonation(newDonation);
      }
      setState(() {
        _isLoading = false;
      });
      await showNormalAlretDialog(
        context,
        title: 'Success',
        message: widget.isEditMode!
            ? 'your donation updated succesfully'
            : 'your donation updated succesfully',
      );
      Navigator.of(context).pop();
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
      });
      showExceptionAlertDialog(
        context,
        title: 'Donation failed',
        exception: e,
      );
    }
  }

  //for pickImage
  Future pickImage(ImageSource source) async {
    try {
      final image = await picker.pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      Navigator.of(context).pop();
      setState(() => _image.add(imageTemporary));
    } on Exception catch (e) {
      print('Failed to pick image: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to pick image: $e"),
      ));
    }
  }



  //for popup dialog for choosing image
  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose One Method'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildButton(
            title: 'Pick Gallery',
            icon: Icons.image_outlined,
            onClicked: () => pickImage(ImageSource.gallery),
          ),
          const SizedBox(
            height: 24,
          ),
          buildButton(
            title: 'Pick Camera',
            icon: Icons.camera_alt_outlined,
            onClicked: () => pickImage(ImageSource.camera),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
          child: const Text('Close'),
        ),
      ],
    );
  }


  //for upload the file
  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      // final name = Path.basename(img.path);
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('foodImage/${widget.donation?.donorId}/${widget.donation?.foodName}');
      await ref.putFile(img).whenComplete(() async {
         imageUrl = await ref.getDownloadURL();
        // FirebaseFile file = FirebaseFile(
        //     ref: ref, name: name, url: url, uploadTime: DateTime.now());
        // await FirestoreApi.postDocument(file, widget.uid);
      });
      i++;
    }
  }

  Widget buildButton({
      required String title,
      required IconData icon,
      required VoidCallback onClicked,
    }) =>
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(56),
            primary: Colors.white,
            onPrimary: Colors.black,
            textStyle: TextStyle(fontSize: 20),
          ),
          onPressed: onClicked,
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 16),
              Text(title)
            ],
          ),
        );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add & Edit Donation'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: SpinKitFadingFour(
                color: Colors.greenAccent,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _foodnameController,
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide a food name.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _foodQuantityContoller,
                        decoration: InputDecoration(
                          labelText: 'Quantity Per Person',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter a Quantity.';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a vaild number.';
                          }
                          if (int.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _foodTypeConntroller,
                        decoration: InputDecoration(
                            labelText: 'Food type', hintText: 'veg or nonveg'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide food type';
                          }
                          return null;
                        },
                      ),
                      // Row(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        // children: [
                        //   Container(
                        //     width: 100,
                        //     height: 100,
                        //     margin: EdgeInsets.only(
                        //       top: 8,
                        //       right: 10,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       border: Border.all(
                        //         width: 1,
                        //         color: Colors.grey,
                        //       ),
                        //     ),
                        //     child: _imageUrlController.text.isEmpty
                        //         ? Text('Enter a URL')
                        //         : FittedBox(
                        //             child: Image.network(
                        //               food.foodImageUrl,
                        //               fit: BoxFit.fill,
                        //             ),
                        //           ),
                        //   ),
                        //   Expanded(
                        //     child: TextFormField(
                        //         decoration:
                        //             InputDecoration(labelText: 'Image URL'),
                        //         keyboardType: TextInputType.url,
                        //         textInputAction: TextInputAction.done,
                        //         controller: _imageUrlController,
                        //         onChanged: (_) {
                        //           setState(() {});
                        //         },
                        //         onFieldSubmitted: (_) {
                        //           _saveForm();
                        //         },
                        //         validator: (value) {
                        //           if (value!.isEmpty) {
                        //             return 'Please Provide a Image Url.';
                        //           }
                        //           return null;
                        //         }),
                        //   ),
                        // ],
                      // )
                  TextButton(
                              onPressed: () {
                                setState(() {
                                  uploading = true;
                                });
                                uploadFile().whenComplete(() => Navigator.of(context).pop());
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(width: 2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  'Upload Image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),),

                      Container(
                        height: 500,
                        padding: const EdgeInsets.all(4),
                        child: GridView.builder(
                            itemCount: _image.length + 1,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Center(
                                child: IconButton(
                                  color: Colors.red,
                                  icon: const Icon(Icons.add_a_photo_rounded,
                                      size: 50),
                                  onPressed: () {
                                    !uploading
                                        ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return _buildPopupDialog(context);
                                      },
                                    )
                                        : null;
                                  },
                                ),
                              )
                                  : Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_image[index - 1]),
                                        fit: BoxFit.cover)),
                              );
                            }),
                      ),
                      uploading
                          ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                child: const Text(
                                  'uploading...',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CircularProgressIndicator(
                                value: val,
                                valueColor:
                                const AlwaysStoppedAnimation<Color>(Colors.green),
                              )
                            ],
                          ))
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }


}

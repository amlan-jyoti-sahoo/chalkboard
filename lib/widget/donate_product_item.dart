import 'package:chalkboard/model/donation.dart';
import 'package:chalkboard/model/user.dart';
import 'package:chalkboard/screen/add_edit_donation.dart';
import 'package:chalkboard/services/firestoreApi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonateProductItem extends StatelessWidget {
  const DonateProductItem({Key? key, required this.donation}) : super(key: key);
  final Donation donation;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text(donation.foodName),
          subtitle: Text(donation.address.city),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(donation.foodImageUrl),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    final user = Provider.of<User?>(context, listen: false);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => AddEditDonation(
                        currentUser: user,
                        isEditMode: true,
                        donation: donation,
                      ),
                    ));
                  },
                  icon: Icon(Icons.edit),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () async {
                    final db =
                        Provider.of<FirestoreApi>(context, listen: false);
                    await db.deleteMyDonation(donation.donationId!);
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}

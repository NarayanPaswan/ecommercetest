import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/exports.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  
  
  @override
  
  Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return  const Center(child: CircularProgressIndicator());
    }

    final userId = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: ListView(
        children: [
    

    StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child:  CircularProgressIndicator());
        }

      final user = snapshot.data!.data() as Map<String, dynamic>?;
      final accountName = user?['name'] ?? 'Your Name';
      final accountEmail = user?['email'] ?? 'Your Email';
      //  const Image(image: AssetImage(AssetsPath.emptyCartImage)),
      return Column(
        children: [
          const Padding(
           padding: EdgeInsets.all(8.0),
           child: Center(
            child: CircleAvatar(
              backgroundImage: AssetImage(AssetsPath.profilePic),
              radius: 100,
            )),
         ),

          Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           AppText(text: "Name: ", size: 14,),
                           AppText(text: accountName, size: 14,)
                           
                         ],
                       ),
            ),

            Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           AppText(text: "Email Id: ", size: 14,),
                           AppText(text: accountEmail, size: 14,)
                           
                         ],
                       ),
            ),

        ],
      );

        // return ListView(
        //   children: [
        //     UserAccountsDrawerHeader(
        //       decoration: BoxDecoration(
        //         color: AppColors.primaryColor,
        //       ),
        //       accountName: Text(accountName),
        //       accountEmail: Text(accountEmail),
        //       currentAccountPicture: const CircleAvatar(
        //         backgroundColor: Colors.white,
        //       ),
        //     ),
            
        //   ],
        // );
      },
    ),
        ],
      ),
    );
  }
}
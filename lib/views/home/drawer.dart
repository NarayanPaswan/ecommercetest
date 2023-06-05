import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercetest/views/profile/user_profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Controller/auth_controller_provider.dart';
import '../../utils/exports.dart';
import '../auth/login_view.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
 final authControllerProvider = AuthControllerProvider();
  @override
  Widget build(BuildContext context) {
       final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return  const Center(child: CircularProgressIndicator());
    }

    final userId = user.uid;

    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
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

          return ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                accountName: Text(accountName),
                accountEmail: Text(accountEmail),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                ),
              ),
              ListTile(
                title: const Text('Categories Link'),
                leading: const Icon(Icons.link),
                onTap: () {},
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  PageNavigator(ctx: context).nextPage(page: const UserProfileView());
                },
                child: const ListTile(
                  title:  Text('User Profile'),
                  leading:  Icon(Icons.person),
               
                ),
              ),
              const Divider(),
              InkWell(
                   onTap: () {
                    authControllerProvider.logout();
                    PageNavigator(ctx: context).nextPageOnly(page: const LoginView());
                  },
                child: const ListTile(
                  title:  Text('Logout'),
                  leading:  Icon(Icons.exit_to_app),
               
                ),
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
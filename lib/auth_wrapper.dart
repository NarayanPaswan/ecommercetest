import 'package:ecommercetest/utils/exports.dart';
import 'package:ecommercetest/views/auth/login_view.dart';
import 'package:ecommercetest/views/home/home_view.dart';

import 'Controller/auth_controller_provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthControllerProvider authControllerProvider = AuthControllerProvider();
  @override
  Widget build(BuildContext context) {
    return authControllerProvider.user != null ? const HomeView() : const LoginView();
  }
}
import 'package:ecommercetest/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Controller/auth_controller_provider.dart';
import 'Controller/cart_controller_provider.dart';
import 'Controller/home_controller_provider.dart';
import 'utils/exports.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
       providers: [
       ChangeNotifierProvider(create: (_)=> AuthControllerProvider()),
       ChangeNotifierProvider(create: (_)=> HomeControllerProvider()),
       ChangeNotifierProvider(create: (_)=> CartControllerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
           appBarTheme: AppBarTheme(
            color: AppColors.primaryColor,
           ),
          primaryColor: AppColors.primaryColor
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}



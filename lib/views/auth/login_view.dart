import 'package:ecommercetest/views/auth/register_view.dart';
import 'package:ecommercetest/views/home/home_view.dart';
import 'package:provider/provider.dart';
import '../../Controller/auth_controller_provider.dart';
import '../../utils/components/app_error_snackbar.dart';
import '../../utils/components/snack_message.dart';
import '../../utils/exports.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final authControllerProvider = AuthControllerProvider();

   @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              Labels.signIn,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: Colors.black),
            ),
            const SizedBox(
              height: 25,
            ),
             AppTextFormField(
              controller: _emailController,
              hintText: Labels.email,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                    return authControllerProvider.emailValidate(value!);
                  },
            ),
            const SizedBox(
              height: 15,
            ),
        
              Consumer<AuthControllerProvider>(
              builder: (context, auth, child) {
              return AppTextFormField(
              controller: _passwordController,
              hintText: Labels.password,
              prefixIcon: Icons.lock_outline_rounded,
              suffixIcon: auth.obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              suffixIconOnPressed: () {
                    auth.obscurePassword =
                        !auth.obscurePassword;
                  },
               obscureText: auth.obscurePassword,
                validator: (value) {
                    return auth.validatePassword(value!);
                  },             
              keyboardType: TextInputType.emailAddress,
            );
            }),
        
            const SizedBox(
              height: 25,
            ),
            
            Consumer<AuthControllerProvider>(
              builder: (context, auth, child) {
                     WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (auth.responseMessage != '') {
                          showMessage(
                           message: auth.responseMessage, context: context);
                          ///Clear the response message to avoid duplicate
                          auth.clear();
                        }
                      });
        
                return customButton(
                  text: Labels.signIn,
                  ontap: () async {
                    if (_formKey.currentState!.validate()) {
                       try {
                        await auth.login( 
                        email: _emailController.text.trim(), 
                        password: _passwordController.text.trim());
                        // ignore: use_build_context_synchronously
                        PageNavigator(ctx: context).nextPageOnly(page: const HomeView());
                      
                        } catch (e) {
                          AppErrorSnackBar(context).error(e);
                        }
                    }
                  },
               
                context: context,
                status: auth.isLoading,
            
                );
              }
            ),
        
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: (){
                   PageNavigator(ctx: context).nextPageOnly(
                    page: const RegisterView(),
                 );
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: Labels.dontHaveAccount,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                  children: [
                    TextSpan(
                      text: Labels.register,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      
                    )
                  ]
                  ),
              ),
            )
        
           
          ],
        ),
      ),
    );
  }
}
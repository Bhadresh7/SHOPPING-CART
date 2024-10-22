import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_example/components/custom_login_btn.dart';
import 'package:shopping_cart_example/providers/auth_provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>(); // Key for the FormBuilder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
          return FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0), // Add padding
                  child: FormBuilderTextField(
                    name: 'email',
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomLoginbtn(
                  onTap: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final email =
                          _formKey.currentState?.fields['email']?.value;

                      provider.resetPassword(email, context);
                    }
                  },
                  text: "Get Email",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

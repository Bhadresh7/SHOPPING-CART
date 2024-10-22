import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_example/components/custom_login_btn.dart';
import 'package:shopping_cart_example/providers/auth_provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Become a Member"),
          ),
          backgroundColor: Colors.grey[100],
          body: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 200.0,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 20),
                    // Wrapping the form in FormBuilder
                    FormBuilder(
                      key: provider.formKey1,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: 'Username',
                            decoration:
                                const InputDecoration(labelText: 'username'),
                            keyboardType: TextInputType.emailAddress,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.username(),
                            ]),
                          ),
                          const SizedBox(height: 25),
                          FormBuilderTextField(
                            name: 'email',
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                            ]),
                          ),
                          const SizedBox(height: 25),
                          FormBuilderTextField(
                            name: 'password',
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.password(),
                            ]),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    CustomLoginbtn(
                      onTap: () => provider.userSignUp(context),
                      text: "Register",
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already a member?"),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "Login Now",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("or"),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SignInButton(
                Buttons.google,
                onPressed: () => provider.googleRegister(context),
                padding: const EdgeInsets.all(10),
              ),
            ],
          ),
        );
      },
    );
  }
}

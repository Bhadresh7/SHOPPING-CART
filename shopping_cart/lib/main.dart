import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_example/database_connection.dart';
import 'package:shopping_cart_example/providers/auth_provider.dart';
import 'package:shopping_cart_example/providers/cart_provider.dart';
import 'package:shopping_cart_example/screen/authentication/auth_screen.dart';

void main() async {
  await databaseConnection();
  if (databaseConnection() != null) {
    print("connected successfully");
  } else {
    print("Not Connected");
    return;
  }
  runApp(const myApp());
}

class myApp extends StatefulWidget {
  const myApp({super.key});

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.pinkAccent,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white)),
        debugShowCheckedModeBanner: false,
        home: const AuthScreen(),
      ),
    );
  }
}

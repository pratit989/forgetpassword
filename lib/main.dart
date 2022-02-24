import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Forget Password',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  late String email;

  @override
  void initState() {
    // TODO: implement initState
    try {
      auth.signInWithEmailAndPassword(
          email: "md@pondyworld.com", password: 'md@pondyworld',
      ).then((value) => print('user signed in'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           Form(
             key: formKey,
               child: Column(
                 children: [
                   TextFormField(
                     obscureText: false,
                     decoration: const InputDecoration(
                       hintText: 'Enter your email',
                       // suffixIcon: GestureDetector(
                       //   onTap: () => setState(() {
                       //     obscureField1 = !obscureField1;
                       //   }),
                       //   child: Icon(
                       //       obscureField1 ? Icons.lock : Icons.lock_open,
                       //   ),
                       // )
                     ),
                     validator: (val) {
                       if (val!.isEmpty) {
                         return 'Please enter your email';
                       }
                       email = val;
                       return null;
                     },
                   ),
                 ],
               )
           )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
        if (formKey.currentState!.validate()) {
          auth.sendPasswordResetEmail(email: email).then((value) => print('link sent'));
        }
      }, label: const Text('Reset Password')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

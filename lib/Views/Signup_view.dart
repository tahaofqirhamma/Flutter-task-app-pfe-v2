import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/Constants/Routes.dart';
import 'package:task_management_app/Services/auth/auth_exceptions.dart';
import 'package:task_management_app/Services/auth/auth_service.dart';
import 'package:task_management_app/Utilities/color_app.dart';

// class SigupView extends StatefulWidget {
//   const SigupView({super.key});

//   @override
//   State<SigupView> createState() => _SigupViewState();
// }

// class _SigupViewState extends State<SigupView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Sign up")),
//       body: const Text("HNA RADI YKON LOGIN"),
//     );
//   }
// }

class SigupView extends StatefulWidget {
  const SigupView({super.key});
  @override
  State<SigupView> createState() => _SigupViewState();
}

// ignore: camel_case_types
class _SigupViewState extends State<SigupView> {
  //Variables
  bool _obsecure = true;
  late final TextEditingController _username;
  late final TextEditingController _mail;
  late final TextEditingController _password;

  final Map<int, List> _Mp = {
    0: ['Username', Icons.person],
    1: ['Email', Icons.mail_lock_outlined],
    2: const ['Password', Icons.lock, Icons.remove_red_eye]
  };
  final List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());
  List<bool> etatfocus = [for (int i = 0; i < 3; i++) false];
  @override
  void initState() {
    _username = TextEditingController();
    _mail = TextEditingController();
    _password = TextEditingController();
    for (int i = 0; i < 3; i++) {
      _focusNodes[i].addListener(() {
        setState(() {
          etatfocus[i] = (etatfocus[i]) ? false : true;
        });
      });
      super.initState();
    }
  }
  //   @override
  // void initState() {
  //   _email = TextEditingController();
  //   _password = TextEditingController();
  //   super.initState();
  // }

  @override
  void dispose() {
    _username.dispose();
    _mail.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "lib/assets/backgrounds/signup_background.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: IconButton(
                          onPressed: () => {},
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: ColorApp.white)),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    const Center(
                      child: Text(
                        'Create  Account',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /**Form input */
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                for (int i = 1; i < 3; i++)
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: TextFormField(
                        focusNode: _focusNodes[i],
                        obscureText: (i == 2) ? _obsecure : false,
                        cursorColor:
                            (etatfocus[i]) ? ColorApp.prpColor : ColorApp.grey,
                        controller: (i == 0)
                            ? _username
                            : (i == 1)
                                ? _mail
                                : _password,
                        keyboardType: (i == 1)
                            ? TextInputType.emailAddress
                            : TextInputType.text,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: (etatfocus[i])
                                    ? ColorApp.prpColor
                                    : ColorApp.grey,
                                style: BorderStyle.solid),
                          ),
                          labelText: _Mp[i]![0]?.toString(),
                          labelStyle: TextStyle(
                            color: (etatfocus[i])
                                ? ColorApp.prpColor
                                : ColorApp.grey,
                          ),
                          prefixIcon: Icon(
                            _Mp[i]![1],
                            color: (etatfocus[i])
                                ? ColorApp.prpColor
                                : ColorApp.grey,
                          ),
                          suffixIcon: (i == 2)
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obsecure = !_obsecure;
                                    });
                                  },
                                  icon: Icon(Icons.remove_red_eye,
                                      color: (etatfocus[i])
                                          ? ColorApp.prpColor
                                          : ColorApp.grey),
                                )
                              : null,
                        )),
                  )
                /**SingUp Login Button */
                ,
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final username = _username.text;
                      final email = _mail.text;
                      final password = _password.text;
                      try {
                        await AuthService.firebase().createUser(
                          email: email,
                          password: password,
                        );
                        AuthService.firebase().sendEmailVerification();

                        // Navigator.of(context).pushNamed(VerifyEmailRoute);
                      } on WeakPasswordAuthException {
                        // await showErrorDialog(
                        //   context,
                        //   'Weak password',
                        // );
                      } on EmailAlreadyInUseAuthException {
                        print("a");
                        // await showErrorDialog(
                        //   context,
                        //   'Email is already in use',
                        // );
                      } on InvalidEmailAuthException {
                        print("b");
                        // await showErrorDialog(
                        //   context,
                        //   'This is an invalid email address',
                        // );
                      } on GenericAuthException {
                        print("c");

                        // await showErrorDialog(
                        //   context,
                        //   'Failed to register',
                        // );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(ColorApp.prpColor),
                      side: const MaterialStatePropertyAll(
                        BorderSide(
                          color: ColorApp.prpColor,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                      padding:
                          const MaterialStatePropertyAll(EdgeInsets.all(20)),
                    ),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                Stack(
                  children: const [
                    Divider(
                      color: ColorApp.scndColor,
                      thickness: 1,
                    ),
                    Center(
                      child: Text(
                        'OR',
                        style: TextStyle(
                            backgroundColor: ColorApp.white,
                            color: ColorApp.prpColor),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      padding:
                          const MaterialStatePropertyAll(EdgeInsets.all(20)),
                    ),
                    child: const Text(
                      "Login ",
                      style: TextStyle(color: ColorApp.prpColor),
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

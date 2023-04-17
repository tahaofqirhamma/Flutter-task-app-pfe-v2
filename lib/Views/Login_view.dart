import 'package:flutter/material.dart';
import 'package:task_management_app/Constants/Routes.dart';
import 'package:task_management_app/Services/auth/auth_exceptions.dart';
import 'package:task_management_app/Services/auth/auth_service.dart';
import 'package:task_management_app/Utilities/color_app.dart';
import 'package:task_management_app/Utilities/errors_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obsecure = true;
  final _mail = TextEditingController(), _password = TextEditingController();

  // ignore: non_constant_identifier_names
  final Map<int, List> _Mp = {
    0: ['Email', Icons.mail_lock_outlined],
    1: const ['Password', Icons.lock]
  };

  final List<FocusNode> _focusNodes = List.generate(2, (_) => FocusNode());
  List<bool> etatfocus = [for (int i = 0; i < 2; i++) false];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 2; i++) {
      _focusNodes[i].addListener(() {
        setState(() {
          etatfocus[i] = (etatfocus[i]) ? false : true;
        });
      });
    }
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
                        "lib/assets/backgrounds/signup_background.png"),
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
                              color: Colors.white)),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    const Center(
                      child: Text(
                        'Welcome Back ',
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
            Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    for (int i = 0; i < 2; i++)
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: TextFormField(
                          focusNode: _focusNodes[i],
                          obscureText: (i >= 1) ? _obsecure : false,
                          cursorColor: (etatfocus[i])
                              ? ColorApp.prpColor
                              : ColorApp.grey,
                          /**0 */
                          controller: (i == 0) ? _mail : _password,
                          keyboardType:
                              (i == 0) ? TextInputType.emailAddress : null,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: (etatfocus[i])
                                      ? ColorApp.prpColor
                                      : ColorApp.grey /**1 */,
                                  style: BorderStyle.solid),
                            ),
                            labelText: _Mp[i]![0]?.toString(),
                            labelStyle: TextStyle(
                              color: (etatfocus[i])
                                  ? ColorApp.prpColor
                                  : ColorApp.grey, /**2 */
                            ),
                            prefixIcon: Icon(
                              _Mp[i]![1],
                              color: (etatfocus[i])
                                  ? ColorApp.prpColor
                                  : ColorApp.grey, /**3 */
                            ),
                            suffixIcon: (i >= 1)
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obsecure = (_obsecure) ? false : true;
                                      });
                                    },
                                    icon: Icon(Icons.remove_red_eye,
                                        color: (etatfocus[i])
                                            ? ColorApp.prpColor
                                            : ColorApp.grey), /**4 */
                                  )
                                : null,
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forget Password ?",
                            style: TextStyle(
                              color: ColorApp.scndColor,
                              fontWeight: FontWeight.w700,
                            ),
                          )),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          final email = _mail.text;
                          final password = _password.text;

                          try {
                            await AuthService.firebase()
                                .logIn(email: email, password: password);

                            final user = AuthService.firebase().currentUser;
                            if (user?.isEmailVerified ?? false) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  homeRoute, (route) => false);
                            } else {
                              print('user is not verified check your email');
                            }
                          } on UserNotFoundAuthException {
                            await showErrorDialog(
                              context,
                              'User not found',
                            );
                          } on WrongPasswordAuthException {
                            await showErrorDialog(
                              context,
                              'Wrong password',
                            );
                          } on GenericAuthException {
                            await showErrorDialog(
                              context,
                              'Authentication error',
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(
                            ColorApp.prpColor,
                          ),
                          side: const MaterialStatePropertyAll(
                            BorderSide(
                              color: ColorApp.prpColor,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          shape:
                              MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.all(20)),
                        ),
                        child: const Text(
                          "Login",
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
                              signupRoute, (route) => false);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.white),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.all(20)),
                        ),
                        child: const Text(
                          "Sign up ",
                          style: TextStyle(color: ColorApp.prpColor),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

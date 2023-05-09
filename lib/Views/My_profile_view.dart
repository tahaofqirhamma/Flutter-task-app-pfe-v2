import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:task_management_app/Constants/Routes.dart';
import 'package:task_management_app/Services/auth/auth_service.dart';
import 'package:task_management_app/Services/cloud/user/cloud_user.dart';
import 'package:task_management_app/Services/cloud/user/cloud_user_constants.dart';
import 'package:task_management_app/Utilities/color_app.dart';
import 'package:task_management_app/Utilities/logout_dialog.dart';
import 'package:task_management_app/Utilities/update_user._dialog.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfiletState();
}

class _MyProfiletState extends State<MyProfile> {
  double containerWidth = 0.0;
  bool _obsecure = true;
  final _formKey = GlobalKey<FormState>();
  final List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());
  List<bool> etatfocus = [for (int i = 0; i < 3; i++) false];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      _focusNodes[i].addListener(() {
        setState(() {
          etatfocus[i] = (etatfocus[i]) ? false : true;
        });
      });
    }
  }

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(AuthService.firebase().currentUser!.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
                child: CircularProgressIndicator(
              color: ColorApp.fthColor,
            )); // or any other widget to show a loading state
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final user = CloudUser(
            userId: userData[userId],
            email: userData[eamil],
            username: userData[userName],
          );
          final username = user.username;
          final email = user.email;
          final updateduser = user.userId;
          if (!snapshot.hasData) {}

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: ListView(
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                              width: double.infinity,
                              height: 200,
                              decoration: const BoxDecoration(
                                color: ColorApp.prpColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30)),
                              )),
                          Container(
                            decoration: const BoxDecoration(
                              color: ColorApp.white,
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              homeRoute, (route) => false);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: ColorApp.white,
                                    )),
                              ],
                            ),
                            LayoutBuilder(builder: (BuildContext context,
                                BoxConstraints constraints) {
                              containerWidth = constraints.maxWidth;
                              return Stack(children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  padding: const EdgeInsets.only(
                                      top: 50, bottom: 25),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: ColorApp.scndColor,
                                        blurRadius: 2.0,
                                        spreadRadius: 1.0,
                                        offset: Offset(0.0, 0.0),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Hello , $username",
                                        style: const TextStyle(fontSize: 25),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        ' $email',
                                        style: const TextStyle(
                                            fontSize: 16, color: ColorApp.grey),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: (containerWidth - 100) * 0.5,
                                  child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(50),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              '../assets/image/back_sing.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                ),
                              ]);
                            }),
                            const SizedBox(height: 55),
                            const Center(
                              child: Text(
                                "Profile informations",
                                style: TextStyle(
                                    color: ColorApp.scndColor,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                color: Color.fromARGB(255, 244, 244, 244),
                              ),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _usernameController,
                                        focusNode: _focusNodes[0],
                                        cursorColor: (etatfocus[0])
                                            ? ColorApp.prpColor
                                            : ColorApp.grey,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: (etatfocus[0])
                                                ? ColorApp.prpColor
                                                : ColorApp.grey,
                                          ),
                                          labelStyle: TextStyle(
                                            color: (etatfocus[0])
                                                ? ColorApp.prpColor
                                                : ColorApp.grey, /**2 */
                                          ),
                                          labelText: "Enter your new username",
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: (etatfocus[0])
                                                    ? ColorApp.prpColor
                                                    : ColorApp.grey /**1 */,
                                                style: BorderStyle.solid),
                                          ),
                                        ),
                                        validator: (name) {
                                          if (name!.isEmpty) {
                                            return "Enter Your Username";
                                          }
                                        },
                                      ),
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        focusNode: _focusNodes[1],
                                        cursorColor: (etatfocus[1])
                                            ? ColorApp.prpColor
                                            : ColorApp.grey,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.mail_lock_outlined,
                                            color: (etatfocus[1])
                                                ? ColorApp.prpColor
                                                : ColorApp.grey,
                                          ),
                                          labelStyle: TextStyle(
                                            color: (etatfocus[1])
                                                ? ColorApp.prpColor
                                                : ColorApp.grey, /**2 */
                                          ),
                                          labelText: "Enter your new Email",
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: (etatfocus[1])
                                                    ? ColorApp.prpColor
                                                    : ColorApp.grey /**1 */,
                                                style: BorderStyle.solid),
                                          ),
                                        ),
                                        validator: (mail) {
                                          if (mail!.isEmpty) {
                                            return "Enter Your Email";
                                          }
                                        },
                                      ),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obsecure,
                                        focusNode: _focusNodes[2],
                                        cursorColor: (etatfocus[2])
                                            ? ColorApp.prpColor
                                            : ColorApp.grey,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: (etatfocus[2])
                                                ? ColorApp.prpColor
                                                : ColorApp.grey,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obsecure =
                                                    (_obsecure) ? false : true;
                                              });
                                            },
                                            icon: Icon(Icons.remove_red_eye,
                                                color: (etatfocus[2])
                                                    ? ColorApp.prpColor
                                                    : ColorApp.grey), /**4 */
                                          ),
                                          labelStyle: TextStyle(
                                            color: (etatfocus[2])
                                                ? ColorApp.prpColor
                                                : ColorApp.grey, /**2 */
                                          ),
                                          labelText: "Enter your new password",
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: (etatfocus[2])
                                                    ? ColorApp.prpColor
                                                    : ColorApp.grey /**1 */,
                                                style: BorderStyle.solid),
                                          ),
                                        ),
                                        validator: (password) {
                                          if (password!.isEmpty) {
                                            return "Enter Your  newPassword";
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              await showUpdateUserInfoDialog(
                                                  context,
                                                  'Are you sure about updating your information ?');
                                              await updateUser(
                                                  CloudUser(
                                                    userId: updateduser,
                                                    email: (_emailController
                                                            .text.isNotEmpty)
                                                        ? _emailController.text
                                                        : email,
                                                    username:
                                                        (_usernameController
                                                                .text
                                                                .isNotEmpty)
                                                            ? _usernameController
                                                                .text
                                                            : username,
                                                  ),
                                                  _passwordController.text);
                                            },
                                            style: ButtonStyle(
                                                shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30))),
                                                padding:
                                                    const MaterialStatePropertyAll(
                                                        EdgeInsets.all(20)),
                                                backgroundColor:
                                                    const MaterialStatePropertyAll(
                                                        ColorApp.scndColor)),
                                            child: const Text(
                                              "Update my infos",
                                              style: TextStyle(
                                                  color: ColorApp.white),
                                            )),
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              height: 55,
                            ),
                            Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final shouldLogout =
                                      await showLogOutDialog(context);
                                  if (shouldLogout) {
                                    await AuthService.firebase().logOut();
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      loginRoute,
                                      (_) => false,
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  padding: const MaterialStatePropertyAll(
                                      EdgeInsets.all(20)),
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                    ColorApp.scndColor,
                                  ),
                                ),
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(color: ColorApp.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

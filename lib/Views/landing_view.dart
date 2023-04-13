import 'package:flutter/material.dart';
import 'package:task_management_app/Constants/Routes.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "lib/assets/backgrounds/back.png",
                ),
                fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Welecome",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tasks Manager App",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Fantasy',
                      ),
                    ),
                    const Text(
                      "Create Your tasks and manage it",
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          left: 0, top: 10, right: 0, bottom: 10),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                                left: 0, top: 15, right: 0, bottom: 15),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  loginRoute,
                                  (route) => false,
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                    Colors.white),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(19))),
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.all(16)),
                              ),
                              child: const Text(
                                "Login ",
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 71, 71, 1)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(signupRoute);
                              },
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                    Color.fromRGBO(0, 71, 71, 1)),
                                side: const MaterialStatePropertyAll(
                                  BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(19),
                                )),
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.all(16)),
                              ),
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

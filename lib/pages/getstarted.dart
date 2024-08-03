import 'package:flutter/material.dart';
import 'package:travel/pages/signup.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF97AFB8), // Corrected Color Usage
      body: Container(
        margin: EdgeInsets.only(top: 130.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("images/login.png"),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(
                child: Text.rich(
                  TextSpan(
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: "Travel",
                          style: TextStyle(color: Color(0xffffffff))),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 50.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        color: Color(0xffBFB4AD),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )

            // Add your widget components here
          ],
        ),
      ),
    );
  }
}

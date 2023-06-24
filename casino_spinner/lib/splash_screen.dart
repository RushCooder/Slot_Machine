import 'dart:async';
import 'package:casino_spinner/second_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    startProgress();
  }

  void startProgress() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        _progressValue += 0.1;
        if (_progressValue >= 1.0) {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SecondScreen()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff171717),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Image.asset('assets/images/loading_page_image.png'),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const Text(
                    'Please wait. Loading\nin progress...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 20, // Specify the desired height
                    child: LinearProgressIndicator(
                      value: _progressValue,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xff7FF800)), // Change the color here
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

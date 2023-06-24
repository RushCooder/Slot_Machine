import 'package:flutter/material.dart';

void addMoney(BuildContext context, int balance, Function setState) {
  if (balance < 3000) {
    setState(() {
      balance += 2000;
    });
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 27, 27, 27),
          title: const Text(
            'Warning',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'You are not eligible to add money',
                style: TextStyle(
                  color: Color(0xff7FF800),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xff7FF800),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

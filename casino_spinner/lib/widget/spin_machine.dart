import 'dart:async';

import 'package:flutter/material.dart';

void spinItems(BuildContext context, int betAmount, int balance,
    Function setState, Function saveBalance, bool isSameItems) {
  if (betAmount <= balance) {
    setState(() {
      isSameItems = false;
    });
    Timer(const Duration(seconds: 4), () {
      setState(() {
        isSameItems = true;
        if (betAmount == balance) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Congratulations!'),
                content: const Text('You won! Claim your prize.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        balance += 20000;
                        betAmount = 0;
                        saveBalance(balance);
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Claim'),
                  ),
                ],
              );
            },
          );
        } else {
          if (isSameItems) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Better Luck Next Time'),
                  content: const Text('You lost! Try again.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          balance -= betAmount;
                          betAmount = 0;
                          saveBalance(balance);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      });
    });
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Insufficient Balance'),
          content:
              const Text('You do not have enough balance to place this bet.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

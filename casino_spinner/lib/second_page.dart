import 'dart:async';
import 'dart:math';

import 'package:casino_spinner/widget/slot_machine.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  TextEditingController _textEditingController = TextEditingController();
  int _balance = 10000;
  int _betAmount = 0;
  bool _isSameItems = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    initializePreferences();
  }

  Future<void> initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _balance = _prefs.getInt('balance') ?? 10000;
    });
  }

  void saveBalance() {
    _prefs.setInt('balance', _balance);
  }

  void addMoney() {
    setState(() {
      if (_balance < 3000) {
        _balance += 2000;
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
    });
  }

  void _updateTextField() {
    final text = '$_betAmount';
    final selection = TextSelection.collapsed(offset: text.length);
    final controller = TextEditingController.fromValue(
      TextEditingValue(text: text, selection: selection),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Delayed to avoid overriding onChanged value
      // when setting the text field value.
      if (mounted) {
        setState(() {
          // Assign the updated controller to the TextField.
          _textEditingController = controller;
        });
      }
    });
  }

  void spinItems() {
    if (_betAmount <= _balance) {
      setState(() {
        _isSameItems = false;
      });
      Timer(const Duration(seconds: 4), () {
        setState(() {
          _isSameItems = true;
          if (_betAmount == _balance) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // title: const Text('Congratulations!'),
                  // content: const Text('You won! Claim your prize.'),
                  actions: [
                    Image.asset('casino_spinner/assets/images/pngwing_7.png'),
                    Text(
                      '10,000,00',
                      style: TextStyle(
                          color: Color(
                            0xff7FF800,
                          ),
                          fontSize: 20),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _balance += 20000;
                          _betAmount = 0;
                          saveBalance();
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 200,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xff7FF800),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text(
                            'CLAIM',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            if (_isSameItems) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Better Luck Next Time'),
                    content: const Text('You lost!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _balance -= (_betAmount * 0.3).toInt();
                            _betAmount = 0;
                            saveBalance();
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
            title: const Text('Alert'),
            content: const Text('You do not have sufficient balance.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void spinSlotMachine() {
    final index = Random().nextInt(20);

    if (_betAmount <= _balance) {
      setState(() {
        _balance -= _betAmount;
        saveBalance();
      });

      _controller.start(hitRollItemIndex: index < 8 ? index : null);

      Timer(const Duration(seconds: 4), () {
        _controller.stop(reelIndex: 0);
      });
      Timer(const Duration(seconds: 5), () {
        _controller.stop(reelIndex: 1);
      });
      Timer(const Duration(seconds: 6), () {
        _controller.stop(reelIndex: 2);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Insufficient Balance'),
            content: Text('You don\'t have enough balance to place this bet.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  TextEditingController _betController = TextEditingController();

  late SlotMachineController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _betController.text = '$_betAmount';
    _betController.selection =
        TextSelection.collapsed(offset: _betController.text.length);

    return Scaffold(
      backgroundColor: const Color(0xff171717),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.92,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      color: const Color(0xff7FF800),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          color: const Color(0xff212121),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Balance ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(78, 255, 255, 255)),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '$_balance',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: InkWell(
                                        onTap: () {
                                          addMoney();
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff7FF800),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Icon(
                                            Icons.add,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: SlotMachine(
                      shuffle: true,
                      height: 200,
                      reelSpacing: 10,
                      rollItems: [
                        RollItem(
                          index: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/symbol_1.png'),
                              ),
                            ),
                          ),
                        ),
                        RollItem(
                          index: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/symbol_2.png'),
                              ),
                            ),
                          ),
                        ),
                        RollItem(
                          index: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/symbol_3.png'),
                              ),
                            ),
                          ),
                        ),
                        RollItem(
                          index: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/symbol_4.png'),
                              ),
                            ),
                          ),
                        ),
                        RollItem(
                          index: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/symbol_5.png'),
                              ),
                            ),
                          ),
                        ),
                        RollItem(
                          index: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/symbol_6.png'),
                              ),
                            ),
                          ),
                        ),
                        RollItem(
                          index: 6,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/symbol_7.png'),
                              ),
                            ),
                          ),
                        ),
                        RollItem(
                          index: 7,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/symbol_8.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                      onCreated: (controller) {
                        _controller = controller;
                      },
                      onFinished: (resultIndexes) {
                        print('Result: $resultIndexes');
                        if (resultIndexes
                            .every((index) => index == resultIndexes[0])) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Congratulations!'),
                                content: Text('You won!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _balance += 20000;
                                        saveBalance();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text('Claim'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Better Luck Next Time'),
                                content: Text('You lost!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          setState(() {
                            _balance -= (_betAmount * 0.3).toInt();
                            saveBalance();
                          });
                        }
                      },
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 290,
                    width: double.infinity,
                    color: Color.fromARGB(255, 29, 29, 29),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Bet Controls',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        Spacer(),
                        // const SizedBox(height: 16),
                        Container(
                          height: 40,
                          width: double.infinity,
                          color: const Color(0xff7FF800),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              color: const Color(0xff212121),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Bet Amount ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(
                                          78,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: TextField(
                                        textAlign: TextAlign.end,
                                        focusNode: _focusNode,
                                        controller: _betController,
                                        onChanged: (value) {
                                          _betAmount = int.tryParse(value) ?? 0;
                                          _textEditingController.value =
                                              TextEditingValue(
                                            text: value,
                                            selection:
                                                TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: value.length),
                                            ),
                                          );
                                        },
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                            ),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          suffixIcon: Icon(
                                            Icons.euro,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          filled: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: "0",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 7,
                                      color: const Color(0xff7FF800),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 16),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _betAmount =
                                      (_betAmount - 100).clamp(0, _balance);
                                  _updateTextField();
                                });
                              },
                              child: Container(
                                height: 30,
                                width: 90,
                                color: Color(0xff212121),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _betAmount =
                                      (_betAmount + 100).clamp(0, _balance);
                                  _updateTextField();
                                });
                              },
                              child: Container(
                                height: 30,
                                width: 90,
                                color: Color(0xff212121),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    // spinItems();
                                    _betAmount = 0;
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Color(0xff7FF800)),
                                        color: Color.fromARGB(255, 29, 29, 29)),
                                    child: Icon(
                                      Icons.cached,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    //spinItems();
                                    if (_betAmount > 0) {
                                      _focusNode.unfocus();
                                      spinSlotMachine();
                                      return;
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: const Color.fromARGB(
                                              255, 27, 27, 27),
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
                                                'Bet amount is too low',
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
                                                    color:
                                                        const Color(0xff7FF800),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'OK',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                  },
                                  child: Container(
                                    width: 200,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff7FF800),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'SPIN',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

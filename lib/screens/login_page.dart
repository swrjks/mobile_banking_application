import 'package:flutter/material.dart';
import 'home_page.dart';
import '../widgets/pin_input.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String enteredPin = '';

  void onKeyTap(String value) {
    if (enteredPin.length < 5) {
      setState(() {
        enteredPin += value;
      });
    }
  }

  void onDelete() {
    if (enteredPin.isNotEmpty) {
      setState(() {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);
      });
    }
  }

  void onLogin() {
    if (enteredPin == '12345') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect PIN. Try 12345.')),
      );
      setState(() {
        enteredPin = '';
      });
    }
  }

  Widget buildPinBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            index < enteredPin.length ? '●' : '',
            style: TextStyle(fontSize: 24),
          ),
        );
      }),
    );
  }

  Widget buildNumberPad() {
    final keys = [
      '1','2','3',
      '4','5','6',
      '7','8','9',
      '','0','⌫',
    ];
    return GridView.builder(
      shrinkWrap: true,
      itemCount: keys.length,
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        final key = keys[index];
        if (key == '') return Container();
        return InkWell(
          onTap: () {
            key == '⌫' ? onDelete() : onKeyTap(key);
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                key,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF3B5EDF),
                    child: Text("ai", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 16),
                  Text("Canara Bank", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Enter your 5-digit PIN to continue"),
                  SizedBox(height: 24),
                  PinInput(enteredPin: enteredPin),
                  SizedBox(height: 24),
                  buildNumberPad(),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3B5EDF),
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19// Set text color to white
                      ),
                    ),
                  ),

                  SizedBox(height: 8),
                  Text("Demo PIN: 12345", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

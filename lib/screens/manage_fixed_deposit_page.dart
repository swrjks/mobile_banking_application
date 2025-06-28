import 'package:flutter/material.dart';
import 'otp_verification_page.dart'; // Import the OTP verification page

class ManageDepositsPage extends StatefulWidget {
  @override
  _ManageDepositsPageState createState() => _ManageDepositsPageState();
}

class _ManageDepositsPageState extends State<ManageDepositsPage> {
  final List<Map<String, dynamic>> _fixedDeposits = [
    {
      'id': '1',
      'amount': 100000.0,
      'principal': 100000.0,
      'rate': 6.5,
      'duration': 365,
      'startDate': DateTime.now().subtract(Duration(days: 30)),
      'type': 'Regular',
      'status': 'Active',
    },
    {
      'id': '2',
      'amount': 200000.0,
      'principal': 200000.0,
      'rate': 7.25,
      'duration': 180,
      'startDate': DateTime.now().subtract(Duration(days: 60)),
      'type': 'Tax Saver',
      'status': 'Active',
    },
  ];

  String _formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    )}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showTermsDialog(int index) {
    bool acceptedTerms = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("FD Break Terms & Conditions"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "By breaking this FD, you agree to:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text("1. Premature withdrawal penalty of 1% will apply"),
                    Text("2. Interest will be paid at 4% below contracted rate"),
                    Text("3. Processing may take 1-2 business days"),
                    Text("4. Request cannot be undone once processed"),
                    SizedBox(height: 20),
                    CheckboxListTile(
                      title: Text("I accept the terms and conditions"),
                      value: acceptedTerms,
                      onChanged: (value) {
                        setState(() {
                          acceptedTerms = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: acceptedTerms
                      ? () {
                    Navigator.pop(context);
                    _showOTPVerification(index);
                  }
                      : null,
                  child: Text("Continue"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showOTPVerification(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPVerificationPage(
          phoneNumber: '+91 XXXXXXX123', // Use actual user's mobile number
          onVerificationComplete: (enteredOTP) {
            Navigator.pop(context); // Close OTP screen
            _breakFixedDeposit(index);
          },
          onResendCode: () {
            // Implement OTP resend logic here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('OTP resent successfully')),
            );
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _breakFixedDeposit(int index) {
    setState(() {
      _fixedDeposits[index]['status'] = 'Broken';
    });
    _showSuccessDialog("FD Broken Successfully!");
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Icon(Icons.check_circle, color: Colors.green, size: 50),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateFdDialog() {
    // To be implemented for FD creation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create New FD"),
        content: Text("FD creation functionality will be implemented here"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Fixed Deposits",
          style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF3B5EDF),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _fixedDeposits.length,
        itemBuilder: (context, index) {
          final fd = _fixedDeposits[index];
          final maturityDate = (fd['startDate'] as DateTime).add(Duration(days: fd['duration'] as int));
          final daysLeft = maturityDate.difference(DateTime.now()).inDays;
          final maturityAmount = (fd['principal'] as double) +
              ((fd['principal'] as double) *
                  (fd['rate'] as double) *
                  (fd['duration'] as int) /
                  36500);

          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "FD-${fd['id']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Chip(
                        label: Text(
                          fd['status'].toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: fd['status'] == 'Active'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Principal", style: TextStyle(color: Colors.grey)),
                            Text(
                              _formatCurrency(fd['principal'] as double),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Rate", style: TextStyle(color: Colors.grey)),
                            Text(
                              "${fd['rate']}%",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Start Date", style: TextStyle(color: Colors.grey)),
                            Text(
                              _formatDate(fd['startDate'] as DateTime),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Maturity Date", style: TextStyle(color: Colors.grey)),
                            Text(
                              _formatDate(maturityDate),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Maturity Amount"),
                            Text(
                              _formatCurrency(maturityAmount),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        if (fd['status'] == 'Active')
                          ElevatedButton(
                            onPressed: () => _showTermsDialog(index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[50],
                              foregroundColor: Colors.red,
                            ),
                            child: Text("Break FD"),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateFdDialog,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF3B5EDF),
        elevation: 4,
      ),
    );
  }
}
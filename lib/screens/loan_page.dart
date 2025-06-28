import 'package:flutter/material.dart';
import 'add_loan_page.dart';
import 'otp_verification_page.dart';

class LoanPage extends StatefulWidget {
  @override
  _LoanPageState createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  List<Map<String, dynamic>> _loans = [
    {
      'id': '1',
      'type': 'Home Loan',
      'amount': '₹2,500,000',
      'interest': '8.4%',
      'duration': '20 years',
      'remaining': '₹1,800,000',
      'icon': Icons.home,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'type': 'Vehicle Loan',
      'amount': '₹800,000',
      'interest': '9.2%',
      'duration': '5 years',
      'remaining': '₹350,000',
      'icon': Icons.directions_car,
      'color': Colors.green,
    },
  ];

  Color _getColorForLoanType(String type) {
    switch (type) {
      case 'Home Loan':
        return Colors.blue;
      case 'Vehicle Loan':
        return Colors.green;
      case 'Education Loan':
        return Colors.purple;
      case 'Personal Loan':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getIconForLoanType(String type) {
    switch (type) {
      case 'Home Loan':
        return Icons.home;
      case 'Vehicle Loan':
        return Icons.directions_car;
      case 'Education Loan':
        return Icons.school;
      case 'Personal Loan':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }

  Future<void> _addNewLoan() async {
    // Step 1: Get new loan data from AddLoanPage
    final newLoan = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddLoanPage(getIconForLoanType: _getIconForLoanType),
      ),
    );

    if (newLoan != null && mounted) {
      // Step 2: Go to OTPVerificationPage
      final otpVerified = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationPage(
            // Pass any required info, e.g. phoneNumber, verificationId
            onVerificationComplete: (otp) {
              Navigator.of(context).pop(true); // Return true to indicate success
            },
            onResendCode: () {},
            onCancel: () {
              Navigator.of(context).pop(false); // Return false to indicate cancel
            },
          ),
        ),
      );

      // Step 3: If OTP was verified, add the loan
      if (otpVerified == true && mounted) {
        setState(() {
          _loans.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            ...newLoan,
            'color': _getColorForLoanType(newLoan['type']),
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${newLoan['type']} added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Loans", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3B5EDF),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (_loans.isNotEmpty)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implement search functionality
              },
            ),
        ],
      ),
      body: _loans.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card_off, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No Loans Added",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              "Tap the + button to add loans",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Loans: ${_loans.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Total Remaining: ₹${_calculateTotalRemaining()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _loans.length,
              itemBuilder: (context, index) {
                final loan = _loans[index];
                final cardColor = _getColorForLoanType(loan['type']);
                return _buildLoanCard(loan, cardColor);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewLoan,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF3B5EDF),
        elevation: 4,
        tooltip: 'Add New Loan',
      ),
    );
  }

  Widget _buildLoanCard(Map<String, dynamic> loan, Color cardColor) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to loan details page if needed
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: cardColor.withOpacity(0.2),
                        child: Icon(
                          loan['icon'],
                          color: cardColor,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loan['type'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Started ${_randomDate()} ago',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLoanDetail('Amount', loan['amount']),
                  _buildLoanDetail('Interest', loan['interest']),
                  _buildLoanDetail('Duration', loan['duration']),
                ],
              ),
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: _calculateProgress(loan),
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(cardColor),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Remaining',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    loan['remaining'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  double _calculateProgress(Map<String, dynamic> loan) {
    try {
      final total = double.parse(loan['amount'].replaceAll(RegExp(r'[^0-9.]'), ''));
      final remaining = double.parse(loan['remaining'].replaceAll(RegExp(r'[^0-9.]'), ''));
      return (total - remaining) / total;
    } catch (e) {
      return 0.5;
    }
  }

  String _randomDate() {
    final months = ['3', '5', '8', '10', '15', '22'];
    return '${months[DateTime.now().second % months.length]} months';
  }

  String _calculateTotalRemaining() {
    try {
      double total = 0;
      for (var loan in _loans) {
        total += double.parse(loan['remaining'].replaceAll(RegExp(r'[^0-9.]'), ''));
      }
      return total.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    } catch (e) {
      return '0';
    }
  }
}

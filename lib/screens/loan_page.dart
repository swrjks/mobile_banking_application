
import 'package:flutter/material.dart';

class LoanPage extends StatefulWidget {
  @override
  _LoanPageState createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  final List<Map<String, dynamic>> _loans = [
    {
      'id': '1',
      'type': 'Home Loan',
      'amount': '₹2,500,000',
      'interest': '8.4%',
      'duration': '20 years',
      'remaining': '₹1,800,000',
      'icon': Icons.home,
    },
    {
      'id': '2',
      'type': 'Vehicle Loan',
      'amount': '₹800,000',
      'interest': '9.2%',
      'duration': '5 years',
      'remaining': '₹350,000',
      'icon': Icons.directions_car,
    },
    {
      'id': '3',
      'type': 'Education Loan',
      'amount': '₹500,000',
      'interest': '7.5%',
      'duration': '10 years',
      'remaining': '₹200,000',
      'icon': Icons.school,
    },
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _remainingController = TextEditingController();
  IconData _selectedIcon = Icons.credit_card;

  // Method to get color based on loan type
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

  // Method to get icon based on loan type
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

  @override
  void dispose() {
    _typeController.dispose();
    _amountController.dispose();
    _interestController.dispose();
    _durationController.dispose();
    _remainingController.dispose();
    super.dispose();
  }

  void _addLoan() {
    if (_formKey.currentState!.validate()) {
      final loanType = _typeController.text;
      setState(() {
        _loans.add({
          'id': DateTime.now().toString(),
          'type': loanType,
          'amount': _amountController.text,
          'interest': _interestController.text,
          'duration': _durationController.text,
          'remaining': _remainingController.text,
          'icon': _getIconForLoanType(loanType),
        });

        // Clear form
        _typeController.clear();
        _amountController.clear();
        _interestController.clear();
        _durationController.clear();
        _remainingController.clear();

        // Close the add dialog
        Navigator.of(context).pop();
      });
    }
  }

  void _deleteLoan(String id) {
    setState(() {
      _loans.removeWhere((loan) => loan['id'] == id);
    });
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Loan"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _typeController,
                    decoration: InputDecoration(labelText: "Loan Type"),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: "Loan Amount"),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _interestController,
                    decoration: InputDecoration(labelText: "Interest Rate"),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(labelText: "Duration"),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _remainingController,
                    decoration: InputDecoration(labelText: "Remaining Amount"),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _addLoan,
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Loans",
          style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF3B5EDF),
        iconTheme: IconThemeData(color: Colors.white),
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
              "Tap the + button to add a loan",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _loans.length,
        itemBuilder: (context, index) {
          final loan = _loans[index];
          final cardColor = _getColorForLoanType(loan['type']);

          return Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 4,
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
                          Text(
                            loan['type'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteLoan(loan['id']),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Amount",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            loan['amount'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Interest",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            loan['interest'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Duration",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            loan['duration'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Remaining Amount",
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF3B5EDF),
        elevation: 4,
      ),
    );
  }
}

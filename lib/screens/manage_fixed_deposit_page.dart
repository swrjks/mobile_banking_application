import 'package:flutter/material.dart';

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
                            Text(
                              "Principal",
                              style: TextStyle(color: Colors.grey),
                            ),
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
                            Text(
                              "Rate",
                              style: TextStyle(color: Colors.grey),
                            ),
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
                            Text(
                              "Start Date",
                              style: TextStyle(color: Colors.grey),
                            ),
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
                            Text(
                              "Maturity Date",
                              style: TextStyle(color: Colors.grey),
                            ),
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
                            onPressed: () {
                              setState(() {
                                _fixedDeposits[index]['status'] = 'Broken';
                              });
                            },
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
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF3B5EDF),
        elevation: 4,
      ),
    );
  }
}
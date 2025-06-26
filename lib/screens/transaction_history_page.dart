import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  final List<Map<String, String>> transactions = [
    {"title": "Salary Credit", "amount": "+₹85,000", "date": "2024-01-15", "type": "credit"},
    {"title": "UPI Payment to Swiggy", "amount": "-₹245", "date": "2024-01-14", "type": "debit"},
    {"title": "ATM Withdrawal", "amount": "-₹5,000", "date": "2024-01-14", "type": "debit"},
    {"title": "Amazon refund", "amount": "+₹500", "date": "2024-01-15", "type": "credit"},
    {"title": "Uber ride", "amount": "-₹245", "date": "2024-01-14", "type": "debit"},
    {"title": "Petrol", "amount": "-₹400", "date": "2024-01-14", "type": "debit"},
    {"title": "Surat Trip", "amount": "+₹1500", "date": "2024-01-15", "type": "credit"},
    {"title": "Rewards", "amount": "+₹150", "date": "2024-01-15", "type": "credit"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transaction History",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF3B5EDF),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Center-aligned cards using Wrap
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildStatCard(context, "₹45,625", "Total Credits", Colors.green),
              _buildStatCard(context, "₹6,743", "Total Debits", Colors.red),
              _buildStatCard(context, "24", "Transactions", Colors.blue),
              _buildStatCard(context, "₹1,25,430", "Current Balance", Colors.purple),
            ],
          ),
          SizedBox(height: 24), // Increased from 16 to 24
          Text(
            "Recent Transactions",
            style: TextStyle( // Replaced Theme.of(context).textTheme.headlineSmall
              fontSize: 18, // Reduced from default headlineSmall (usually 24)
              fontWeight: FontWeight.w600, // Semi-bold instead of bold
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12), // Reduced from 10 to 12
          ...transactions.map((txn) => ListTile(
            leading: Icon(
              txn["type"] == "credit" ? Icons.arrow_downward : Icons.arrow_upward,
              color: txn["type"] == "credit" ? Colors.green : Colors.red,
            ),
            title: Text(txn["title"]!),
            subtitle: Text(txn["date"]!),
            trailing: Text(txn["amount"]!, style: TextStyle(fontWeight: FontWeight.bold)),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }
}
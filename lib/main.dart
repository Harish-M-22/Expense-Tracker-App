import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'expense.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
      ),
      home: BudgetHomePage(),
    );
  }
}

class BudgetHomePage extends StatefulWidget {
  @override
  _BudgetHomePageState createState() => _BudgetHomePageState();
}

class _BudgetHomePageState extends State<BudgetHomePage> {
  final List<Expense> _expenses = [];

  final _expenseNameController = TextEditingController();
  final _expenseAmountController = TextEditingController();

  void _addExpense() {
    String name = _expenseNameController.text;
    double? amount = double.tryParse(_expenseAmountController.text);

    if (name.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid name and amount!')),
      );
      return;
    }

    DateTime date = DateTime.now();

    Expense newExpense = Expense(name: name, amount: amount, date: date);

    setState(() {
      _expenses.add(newExpense);
    });

    _expenseNameController.clear();
    _expenseAmountController.clear();
  }

  @override
  void dispose() {
    _expenseNameController.dispose();
    _expenseAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Personal Expense App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _expenseNameController,
                      decoration: InputDecoration(
                        labelText: 'Expense Name',
                        icon: Icon(Icons.note_add_outlined, color: Colors.teal),
                      ),
                    ),
                    TextField(
                      controller: _expenseAmountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        icon: Icon(Icons.attach_money_outlined, color: Colors.teal),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _addExpense,
                      icon: Icon(Icons.add, color: Colors.white),
                      label: Text('Add Expense'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _expenses.isEmpty
                  ? Center(
                      child: Text(
                        'No expenses added yet!',
                        style: TextStyle(fontSize: 18, color: Colors.teal),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _expenses.length,
                      itemBuilder: (context, index) {
                        final expense = _expenses[index];
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color.fromARGB(255, 168, 72, 16),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FittedBox(
                                  child: Text(
                                    '\$${expense.amount.toStringAsFixed(2)}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              expense.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: const Color.fromARGB(221, 0, 0, 0)),
                            ),
                            subtitle: Text(
                              DateFormat.yMMMd().format(expense.date),
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

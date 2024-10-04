import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database_helper.dart';
import 'user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Increment App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  User? get currentUser => _currentUser;

  Future<void> login(String username) async {
    _currentUser = await _dbHelper.getUser(username) ??
        User(username: username, counter: 0);
    notifyListeners();
  }

  void increment() {
    if (_currentUser != null) {
      _currentUser!.counter++;
      _dbHelper.updateUser(_currentUser!);
      notifyListeners();
    }
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String username = _controller.text.trim();
                if (username.isNotEmpty) {
                  Provider.of<UserProvider>(context, listen: false)
                      .login(username)
                      .then((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => CounterScreen()),
                    );
                  });
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${userProvider.currentUser?.username ?? ''}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Counter Value: ${userProvider.currentUser?.counter ?? 0}',
              style: TextStyle(fontSize: 36),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                userProvider.increment();
              },
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

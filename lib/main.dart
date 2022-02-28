import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/ui/all_screen.dart';
import 'package:to_do_app/ui/complete_screen.dart';
import 'package:to_do_app/ui/incomplete_screen.dart';
import 'data/task_database.dart';
import 'models/list_task.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ListTask(),
        )
      ],
      child: const MaterialApp(
        title: _title,
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    final listTaskDAO = ListTaskDAO();
    listTaskDAO.getListTask().then((value) =>
        Provider.of<ListTask>(context, listen: false).setItems(value));
    // NotificationService.init();
    // listenNotifications();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    AllScreen(),
    CompleteScreen(),
    IncompleteScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Complete',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.close),
            label: 'Incomplete',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

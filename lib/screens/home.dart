import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kalendi/screens/calander_view.dart';
import 'package:kalendi/screens/convert.dart';
import 'package:kalendi/screens/add_event.dart';
import 'package:kalendi/screens/settings.dart';
import 'package:kalendi/utils/theme_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late List<String> _pageTitles;

  @override
  void initState() {
    super.initState();
    _pages = [
      CalendarView(),
      ConvertPage(),
      const AddEventPage(),
      const SettingsPage(),
    ];
    _pageTitles = ['Home', 'Convert', 'Add Event', 'Settings'];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Drawer _buildDrawer(BuildContext context) {
    final kalendiState = Provider.of<KalendiAppState>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: const Color.fromARGB(255, 10, 204, 107),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Kalendi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  kalendiState.isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Switch(
                  value: kalendiState.isDarkMode,
                  onChanged: (value) => kalendiState.toggleTheme(value),
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.grey[600],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: _selectedIndex == 0,
            onTap: () {
              _onItemTapped(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Convert Date'),
            selected: _selectedIndex == 1,
            onTap: () {
              _onItemTapped(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add,),
            title: const Text('Add Event'),
            selected: _selectedIndex == 2,
            onTap: () {
              _onItemTapped(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: _selectedIndex == 3,
            onTap: () {
              _onItemTapped(3);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Planed Events'),
            onTap: () {
              Navigator.pushNamed(context, '/saved_events');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        backgroundColor: const Color.fromARGB(255, 10, 204, 107),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_selectedIndex == 2)
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () {
                Navigator.pushNamed(context, '/saved_events');
              },
            ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 9, 243, 1),
        unselectedItemColor: const Color.fromARGB(134, 2, 11, 245),
        backgroundColor: const Color.fromARGB(255, 68, 255, 0),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Convert'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Event'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

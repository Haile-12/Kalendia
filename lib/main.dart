import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Required for Hive UI support
import 'package:timezone/data/latest.dart' as tzData; // For alarms

// Local imports
import 'package:kalendi/utils/theme_service.dart';
import 'package:kalendi/screens/home.dart';
import 'package:kalendi/services/event_service.dart';
import 'package:kalendi/screens/saved_events.dart';
import 'package:kalendi/models/event.dart';
import 'package:kalendi/models/time_of_day_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzData.initializeTimeZones();

  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(TimeOfDayAdapter()); // ✅ Add this line

  await Hive.openBox<Event>('events');
  tzData.initializeTimeZones(); // For alarms

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KalendiAppState()),
        ChangeNotifierProvider(
          create: (_) {
            final service = EventService();
            service.init(); // Initializes Hive box
            return service;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kalendiState = Provider.of<KalendiAppState>(context);

    return MaterialApp(
      title: 'Kalendi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFF007A3D),
        colorScheme: const ColorScheme.light().copyWith(
          secondary: const Color(0xFFF5F5F5),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF007A3D),
        colorScheme: const ColorScheme.dark().copyWith(
          secondary: const Color(0xFF2E7D32),
        ),
      ),
      themeMode: kalendiState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
      routes: {'/saved_events': (context) => const SavedEventsPage()},
    );
  }
}

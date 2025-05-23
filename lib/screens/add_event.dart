import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import 'package:flutter/services.dart';

// Local imports
import 'package:kalendi/models/event.dart';
import 'package:kalendi/services/event_service.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _eventDate;
  TimeOfDay? _alarmTime;
  String _selectedPlan = 'Personal';
  bool _hasAlarm = false;
  final List<String> _plans = ['Work', 'Personal', 'Health', 'Study'];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
    _initNotifications();
  }

  void _initializeDefaults() {
    _eventDate = DateTime.now();
    _alarmTime = TimeOfDay.now();
  }

  Future<void> _initNotifications() async {
    tzData.initializeTimeZones(); // Initialize time zone support
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: initializationSettingsAndroid),
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification tapped: ${details.payload}');
      },
    );
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImplementation?.createNotificationChannel(
      const AndroidNotificationChannel(
        'event_channel',
        'Event Alarms',
        importance: Importance.max,
        enableLights: true,
        showBadge: true,
        enableVibration: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alarm'),
        description: 'Alarms for scheduled Events',
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _eventDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _alarmTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _alarmTime = pickedTime;
      });
    }
  }

  Future<void> _scheduleNotification(
    DateTime date,
    TimeOfDay? alarmTime,
  ) async {
    if (_hasAlarm && alarmTime != null) {
      final scheduledDate = DateTime(
        date.year,
        date.month,
        date.day,
        alarmTime.hour,
        alarmTime.minute,
      );

      final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

      const androidDetails = AndroidNotificationDetails(
        'event_channel',
        'Event Alarms',
        importance: Importance.max,
        priority: Priority.high,
        channelDescription: 'Alarms for scheduled Events',
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alarm'),
        enableVibration: true,
        enableLights: true,
      );

      final notificationDetails = NotificationDetails(android: androidDetails);
      final int notificationId =
          '$date-${_titleController.text}'.hashCode.abs() % 2147483647;

      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          androidScheduleMode: AndroidScheduleMode.exact,
          notificationId,
          'Event Reminder',
          'Your event "${_titleController.text}" is due!',
          tzDateTime,
          notificationDetails,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: 'event|$notificationId|${_titleController.text}',
        );
      } catch (e) {
        if (e is PlatformException) {
          debugPrint("Failed to schedule alarm: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to set alarm. Go to Settings > Battery > Kalendi > Disable battery optimization',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final event = Event(
        title: _titleController.text,
        description: _descriptionController.text,
        eventDate: _eventDate,
        alarmTime: _hasAlarm ? _alarmTime : null,
        plan: _selectedPlan,
      );

      final eventService = Provider.of<EventService>(context, listen: false);

      if (_isHiveReady(eventService)) {
        eventService.addEvent(event);

        if (_hasAlarm && _alarmTime != null) {
          _scheduleNotification(_eventDate, _alarmTime);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event saved successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: 'View All',
              onPressed: () => Navigator.pushNamed(context, '/saved_events'),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Storage not ready. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }

      _titleController.clear();
      _descriptionController.clear();
      _initializeDefaults();
    }
  }

  bool _isHiveReady(EventService eventService) {
    try {
      eventService.events;
      return true;
    } catch (e) {
      return false;
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _titleController.clear();
    _descriptionController.clear();
    _initializeDefaults();
    setState(() {
      _hasAlarm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Event Form",
          style: TextStyle(color: Color.fromARGB(255, 62, 138, 179)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  hintText: 'Max 50 characters',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Title is required.';
                  if (value.length > 50)
                    return 'Title cannot exceed 50 characters.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text("Select Date"),
                subtitle: Text("${_eventDate.toLocal()}".split(" ")[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text("Set Alarm"),
                value: _hasAlarm,
                onChanged: (value) {
                  setState(() {
                    _hasAlarm = value;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
              ),
              if (_hasAlarm)
                ListTile(
                  title: const Text("Set Alarm Time"),
                  subtitle: Text(
                    _alarmTime?.format(context) ?? 'Select Time',
                    style: const TextStyle(color: Colors.black),
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _selectTime(context),
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPlan,
                items:
                    _plans.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 1, 106, 243),
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedPlan = newValue;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Plan',
                  labelStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveEvent,
                      icon: const Icon(
                        Icons.save,
                        color: Color.fromARGB(255, 2, 245, 10),
                      ),
                      label: const Text(
                        "Save Event",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 65, 255, 2),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          89,
                          121,
                          148,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _resetForm,
                      icon: const Icon(
                        Icons.refresh,
                        color: Color.fromARGB(255, 255, 247, 2),
                      ),
                      label: const Text(
                        "Reset",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 65, 255, 2),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          89,
                          121,
                          148,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

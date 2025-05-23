import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/date_converter.dart';

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = _selectedDay;
  }

  void _updateSelectedDay(DateTime day) {
    setState(() {
      _selectedDay = day;
      _focusedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ethiopianDate = DateConverter.convertToEthiopianDate(_selectedDay);
    final dayOfWeek = DateFormat('EEEE').format(_selectedDay);
    final formattedGregorian =
        "$dayOfWeek, ${DateFormat('MMMM d, yyyy').format(_selectedDay)}";
    final formattedEthiopian =
        '${ethiopianDate.month}/${ethiopianDate.day}/${ethiopianDate.year}, $dayOfWeek';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Select Date',
            style:
                theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ) ??
                TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
          ),
          const SizedBox(height: 12),

          // 📆 Gregorian Calendar
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withAlpha(128),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(1900, 1, 1),
              lastDay: DateTime.utc(3000, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                _updateSelectedDay(selectedDay);
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green.shade300,
                  shape: BoxShape.circle,
                ),

                selectedDecoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle:
                    theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ) ??
                    TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle:
                    theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ) ??
                    const TextStyle(fontWeight: FontWeight.bold),
                weekendStyle:
                    theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ) ??
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // 📅 Gregorian & Ethiopian Date Cards
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 400) {
                return Column(
                  children: [
                    _buildDateCard(
                      'Gregorian Date',
                      formattedGregorian,
                      Icons.calendar_month,
                      Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    _buildDateCard(
                      'Ethiopian Date',
                      formattedEthiopian,
                      Icons.calendar_month,
                      Colors.teal,
                    ),
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildDateCard(
                        'Gregorian Date',
                        formattedGregorian,
                        Icons.calendar_month,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDateCard(
                        'Ethiopian Date',
                        formattedEthiopian,
                        Icons.calendar_month,
                        Colors.teal,
                      ),
                    ),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ✅ Enhanced Date Card
  Widget _buildDateCard(String title, String date, IconData icon, Color color) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withAlpha(76)),
      ),
      color: color.withAlpha(13),
      child: InkWell(
        onTap: () => _showDateDialog(context, title, date),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ) ??
                          TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      date,
                      style:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ) ??
                          const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  // 💡 Date Info Dialog
  void _showDateDialog(BuildContext context, String title, String date) {
    final ethiopianDate = DateConverter.convertToEthiopianDate(_selectedDay);
    final gregorianDate = _selectedDay;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow(
                    'Gregorian',
                    DateFormat('yyyy-MM-dd').format(gregorianDate),
                  ),
                  _buildDetailRow('Ethiopian', '$ethiopianDate'),
                  _buildDetailRow(
                    'Day of the Week',
                    DateFormat('EEEE').format(gregorianDate),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  // 📄 Reusable Detail Row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text(value),
        ],
      ),
    );
  }
}

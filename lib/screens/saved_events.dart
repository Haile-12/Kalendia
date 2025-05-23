import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kalendi/services/event_service.dart';
import 'package:intl/intl.dart';
import 'package:kalendi/models/event.dart';

class SavedEventsPage extends StatelessWidget {
  const SavedEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventService = Provider.of<EventService>(context);
    final events = eventService.events;

    // Sort events by date and time in descending order
    events.sort((a, b) => b.eventDate.compareTo(a.eventDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Events'),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 10, 204, 107),
        actions: [
          if (events.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                _showDeleteAllDialog(context, eventService);
              },
              tooltip: 'Delete All',
            ),
        ],
      ),
      backgroundColor: Colors.teal.shade50,
      body:
          events.isEmpty
              ? const Center(child: Text('Ooh! No events saved yet.'))
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Dismissible(
                      key: Key('${event.title}_$index'),
                      direction: DismissDirection.endToStart,
                      background: _buildDismissBackground(),
                      onDismissed:
                          (_) =>
                              _onEventDismissed(context, eventService, index),
                      child: _buildEventCard(context, event),
                    );
                  },
                ),
              ),
    );
  }

  void _showDeleteAllDialog(BuildContext context, EventService eventService) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete All Events'),
            content: const Text('Are you sure you want to delete all events?'),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  eventService.deleteAllEvents();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'All events are deleted successfully',
                        style: TextStyle(
                          color: Color.fromARGB(255, 39, 254, 1),
                        ),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _onEventDismissed(
    BuildContext context,
    EventService eventService,
    int index,
  ) {
    final removedEvent = eventService.events[index];

    eventService.deleteEventAt(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Event deleted successfully',
          style: TextStyle(color: Color.fromARGB(255, 39, 254, 1)),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            eventService.addEvent(removedEvent);
          },
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    final formattedDate = DateFormat('MMM d, y').format(event.eventDate);
    final alarmSet = event.alarmTime != null;
    final String capitalizedTitle =
        event.title.isEmpty
            ? ''
            : '${event.title[0].toUpperCase()}${event.title.substring(1)}';

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.green.shade700.withAlpha(76)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    capitalizedTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (alarmSet)
                  Icon(
                    Icons.notifications_active,
                    color: Colors.green.shade700,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (event.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Description: ${event.description}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Plan: ${event.plan} • $formattedDate',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (alarmSet)
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Alarm: ${event.alarmTime!.format(context)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Icon(Icons.notifications_off, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'Alarm: Not set',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red.shade400,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}

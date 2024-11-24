import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:device_calendar/device_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  final List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _retrieveDeviceCalendarEvents();
  }

  Future<void> _retrieveDeviceCalendarEvents() async {
    var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
    if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
      permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
      if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Calendar permissions denied.')),
          );
        }
        return;
      }
    }

    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    if (calendarsResult.isSuccess && calendarsResult.data != null) {
      for (var calendar in calendarsResult.data!) {
        final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendar.id!,
          RetrieveEventsParams(
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 30)),
          ),
        );
        if (eventsResult.isSuccess && eventsResult.data != null) {
          if (mounted) {
            setState(() {
              _events.addAll(eventsResult.data!);
            });
          }
        }
      }
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      final eventDate = event.start?.toLocal();
      return eventDate != null &&
          eventDate.year == day.year &&
          eventDate.month == day.month &&
          eventDate.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dayEvents = _getEventsForDay(_selectedDay ?? _focusedDay);

   // Ensure all `child` properties are last in their respective widget constructors
return Scaffold(
  appBar: AppBar(
    title: const Text('Calendar'),
    centerTitle: true,
  ),
  body: Column(
    children: [
      TableCalendar(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.yellow,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          _selectedDay != null
              ? '${_selectedDay!.toLocal()}'.split(' ')[0]
              : '${_focusedDay.toLocal()}'.split(' ')[0],
          style: const TextStyle(fontSize: 16),
        ),
      ),
      dayEvents.isEmpty
          ? const Center(
              child: Text(
                'Your calendar is empty\nYou don’t have anything scheduled',
                textAlign: TextAlign.center, // Ensure child comes last here
              ),
            )
          : Expanded(
              child: ListView.builder(
                itemCount: dayEvents.length,
                itemBuilder: (context, index) {
                  final event = dayEvents[index];
                  return ListTile(
                    title: Text(event.title ?? 'No Title'),
                    subtitle: Text(
                      event.start?.toLocal().toString() ?? 'No Date',
                    ),
                  );
                },
              ),
            ),
    ],
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      // Add new event logic here
    },
    backgroundColor: Colors.yellow,
    child: const Icon(Icons.add),
  ),
  bottomNavigationBar: BottomNavigationBar(
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: 'Calendar',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.timer),
        label: 'Timer',
      ),
    ],
    currentIndex: 0,
    selectedItemColor: Colors.yellow,
  ),
);
  }
}

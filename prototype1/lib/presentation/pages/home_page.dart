import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prototype1/global/common/toast.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final String formattedDate = DateFormat('MMMM yyyy').format(_focusedDay);
    final dayEvents = _getEventsForDay(_selectedDay ?? _focusedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Procrastination Terminator',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              // Handle menu selection
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Settings', child: Text('Settings')),
              const PopupMenuItem(value: 'Help', child: Text('Help')),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 196, 0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.black,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                showToast(message: "Successfully signed out.");
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacementNamed(context, '/login'); // Navigate to login
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Custom Calendar Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate, // Display "November 2024"
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _calendarFormat = _calendarFormat == CalendarFormat.week
                          ? CalendarFormat.month
                          : CalendarFormat.week;
                    });
                  },
                  icon: Icon(
                    _calendarFormat == CalendarFormat.week
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                  ),
                ),
              ],
            ),
          ),

          // TableCalendar without default header
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            headerVisible: false, // Disable the default header
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 196, 0),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 196, 0),
                shape: BoxShape.circle,
              ),
            ),
          ),
          dayEvents.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text(
                      'Your calendar is empty\nYou don’t have anything scheduled',
                      textAlign: TextAlign.center,
                    ),
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
        backgroundColor: const Color.fromARGB(255, 255, 196, 0),
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
        selectedItemColor: const Color.fromARGB(255, 255, 196, 0),
      ),
    );
  }
}

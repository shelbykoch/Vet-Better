import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/appointment.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'appointment_screen.dart';

class CalendarScreen extends StatefulWidget {
  static const routeName = '/calendarScreen';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  _Controller con;
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  List<Appointment> _appointments;
  User _user;

  @override
  void initState() {
    con = _Controller(this);

    super.initState();
    final _selectedDay = DateTime.now();
    _events = new Map<DateTime, List<dynamic>>();
    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  void render(fn) => setState(fn);

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  /*
  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }
  */
  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    _appointments ??= arg[Constant.ARG_APPOINTMENTS];
    _user ??= arg[Constant.ARG_USER];
    con.buildMaps();

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
          const SizedBox(height: 8.0),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.blue[400],
        todayColor: Colors.blue[200],
        markersColor: Colors.white,
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.blue[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      //onVisibleDaysChanged: _onVisibleDaysChanged,
      //onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text((event as Appointment).title),
                  subtitle: Text((event as Appointment).getTimeandLocation()),
                  //onTap: () => print('$event tapped!'),
                  trailing: Wrap(
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => con.editAppointment(event)),
                      IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => con.deleteAppointment(event)),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _Controller {
  _CalendarScreenState _state;
  _Controller(this._state);

  void buildMaps() {
    //We store appointments in Firebase but require a specific event object
    //to work with the calendar. This function will build an event map for the
    //calendar but also a map to pair and event with our custom appointment object
    _state._appointments.forEach((appt) {
      _state._events[appt.dateTime] = <dynamic>[appt];
    });
  }

  void editAppointment(Object appointment) {
    Appointment appt = appointment;
    Navigator.pushNamed(_state.context, AppointmentScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state._user,
          Constant.ARG_APPOINTMENT: appt,
        });
  }

  void deleteAppointment(Object object) {
    Appointment appt = object;
    FirebaseController.deleteAppointment(appt.docID);

    _state.render(() => _state._events
        .remove(appt.dateTime)); //Remove it from events render on map});
    _state.render({});
  }
}

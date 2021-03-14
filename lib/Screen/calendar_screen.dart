import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/appointment.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  //Making firebase within the build function causes really issues.
  //To alleviate this we will set the appointments list on the first load
  //And then maintain that list internally instead of resetting it
  //with a database call. This boolean manages that process.
  bool firstLoad = true;

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
    _selectedEvents = events;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    _user ??= arg[Constant.ARG_USER];
    if (firstLoad)
      _appointments ??= arg[Constant
          .ARG_APPOINTMENTS]; //Maps appointments in database to the event objects required for the calendar
    con.buildMap();
    firstLoad = false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.add, color: Colors.white),
            label: Text(
              'Schedule',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () =>
                con.createAppointment(_calendarController.selectedDay),
          ),
        ],
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
                  trailing: Wrap(
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => con.editAppointment((event
                              as Appointment))), //This will default the created appointment to the selected day
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

  void buildMap() {
    //We store appointments in Firebase but require a specific event object
    //to work with the calendar. This function will build an event map for the
    //calendar but also a map to pair and event with our custom appointment object
    _state._events.clear();
    _state._appointments.forEach((appt) {
      if (_state._events[appt.getEventKey()] == null)
        _state._events[appt.getEventKey()] = new List<Appointment>();
      if (!_state._events[appt.getEventKey()].contains(appt))
        _state._events[appt.getEventKey()].add(appt);
    });
  }

  //GOOD TO GO!!
  void deleteAppointment(Object object) async {
    Appointment appt = object;
    await FirebaseController.deleteAppointment(appt.docID);

    //Remove it from events render on map});
    _state._appointments.remove(appt);
    _state._selectedEvents.remove(appt);
    _state.setState(() {}); //Update screen to reflect changes
  }

  //This will open the appointment details screen. If an appointment
  //is passed it will populate the initail values. If not, a new appointment will
  //be created
  void createAppointment(DateTime dateTime) async {
    Appointment appointment = new Appointment.withEmail(_state._user.email);
    appointment.dateTime = dateTime.toLocal();
    await Navigator.pushNamed(_state.context, AppointmentScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state._user,
          Constant.ARG_APPOINTMENT: appointment,
        });
    if (appointment.docID != null) {
      _state._appointments.add(appointment);
      _state._selectedEvents.add(appointment);
      _state.setState(() {});
    }
  }

  //This will open the appointment details screen. If an appointment
  //is passed it will populate the initail values. If not, a new appointment will
  //be created
  void editAppointment(Appointment appointment) {
    Navigator.pushNamed(_state.context, AppointmentScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state._user,
          Constant.ARG_APPOINTMENT: appointment,
        });
    //Remove the old appointment
    _state._appointments
        .removeWhere((element) => element.docID == appointment.docID);
    _state._selectedEvents.removeWhere(
        (element) => (element as Appointment).docID == appointment.docID);

    //Add the newly edited appointment
    _state._appointments.add(appointment);
    _state._selectedEvents.add(appointment);
    _state.setState(() {});
  }
}

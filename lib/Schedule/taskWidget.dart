
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psm_project/model/class.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../event/eventPage.dart';

class TaskWidget extends StatefulWidget {
  final List<Activity> ?list;
  const TaskWidget({this.list});
  
  @override
  TaskWidgetState createState() => TaskWidgetState();
}

class TaskWidgetState extends State<TaskWidget>{
  @override
  void initState() {
    // print(widget.list![2].startTime);
    // print(widget.list![2].endTime);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context){
    DateTime date = DateFormat("dd-MM-yyyy").parse(widget.list![0].startTime!);
    return SfCalendarTheme(
      data: SfCalendarThemeData(
        timeTextStyle: TextStyle(
          fontSize: 16, 
          color: Colors.black
        ),
      ),
      child: SfCalendar(
        initialDisplayDate: date,
        appointmentBuilder: appointmentBuilder,
        view: CalendarView.timelineDay,
        dataSource: ActivityDataSource(widget.list!),
        headerHeight: 0,
        todayHighlightColor: Colors.black,
        selectionDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        onTap: (details){
          if(details.appointments == null) return;
          
          final event = details.appointments!.first;
          try{
            Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> EventPage(event: event))
          ).whenComplete(() => Navigator.of(context).pop(context));
          } catch(e){
            
          }
        },
      ),
    );
  }
  
  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final event = details.appointments.first;
    
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Center(
        child: Text(
          event.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16
          ),
        ),
      ),
    );
  }
  
}

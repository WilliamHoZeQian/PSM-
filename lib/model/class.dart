import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Activity{
  String? name,
          id,
          date,
          startTime,
          endTime;
         
  Activity({
    this.id,
    this.name, 
    this.date,
    this.startTime,
    this.endTime,
  });
}

class Question{
  String text;
  List<Option> options;
  Option? selection;
  bool isLocked;
  
  Question({
    required this.text,
    required this.options,
    this.selection,
    this.isLocked = false,
  });
}

class Option{
  final String text;
  final int selection;
  
  const Option({
    required this.text,
    required this.selection,
  });
}

final Plannerquestions = [
  // Question 1
  Question(
    text: 'What is your gender', 
    options: [
      Option(
        text: 'Male', 
        selection: 1
      ),
      Option(
        text: 'Female', 
        selection: 2
      ),
    ]
  ),
  // Question 2
  Question(
    text: 'How old are you', 
    options: [
      Option(
        text: 'Below 20', 
        selection: 1
      ),
      Option(
        text: '20 - 29', 
        selection: 2
      ),
      Option(
        text: '30 - 39', 
        selection: 3
      ),
      Option(
        text: 'Above 40', 
        selection: 4
      ),
    ]
  ),
  // Question 3
  Question(
    text: 'Are you a student or worker?', 
    options: [
      Option(
        text: 'Student', 
        selection: 1
      ),
      Option(
        text: 'Worker', 
        selection: 2
      ),
    ]
  ),
];

final Activityquestions = [
  // Question 1
  Question(
    text: 'What is your gender', 
    options: [
      Option(
        text: 'Male', 
        selection: 1
      ),
      Option(
        text: 'Female', 
        selection: 2
      ),
    ]
  ),
  // Question 2
  Question(
    text: 'How old are you', 
    options: [
      Option(
        text: 'Below 20', 
        selection: 1
      ),
      Option(
        text: '20 - 29', 
        selection: 2
      ),
      Option(
        text: '30 - 39', 
        selection: 3
      ),
      Option(
        text: 'Above 40', 
        selection: 4
      ),
    ]
  ),
  // Question 3
  Question(
    text: 'Are you prefer indoor or outdoor?', 
    options: [
      Option(
        text: 'Indoor', 
        selection: 1
      ),
      Option(
        text: 'Outdoor', 
        selection: 2
      ),
    ]
  ),
];

class ActivityDataSource extends CalendarDataSource{
  ActivityDataSource(List<Activity> appointments){
    this.appointments = appointments;
  }
  
  Activity getActivity(int index) => appointments![index] as Activity;
  
  @override
  DateTime getStartTime(int index) => DateFormat("dd-MM-yyyy HH:mm:ss").parse(getActivity(index).startTime!);

  @override
  DateTime getEndTime(int index) => DateFormat("dd-MM-yyyy HH:mm:ss").parse(getActivity(index).endTime!);
  
  @override
  String getSubject(int index) => getActivity(index).name!;
  
  // @override
  // String getSubject(int index) => getActivity(index).name!;
}
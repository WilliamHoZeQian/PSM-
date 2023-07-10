// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:psm_project/data/userdata.dart';
import 'package:psm_project/model/class.dart';

import '../model/server.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => ActivitypageState();
}

class ActivitypageState extends State<ActivityPage> {
  
  Offset _tapPosition = Offset.zero;
  bool isActive = false;
  final formkey1 = GlobalKey<FormState>();
  TextEditingController activityController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  List record = [];
  List<Activity> activityList = [];
  List<Activity> listShowed = [];
  
  Future<void> getActivity() async {
    try {
      var url = Uri.https(host, '/getActivitySpecific.php', {'q': '{http}'});
      var response = await http.post(
        url,
        body: {
          "userID": userID,
          "date": date,
        });
      setState(() {
        record = json.decode(response.body);
        for(int i=0;i<record.length; i++) {
            activityList.add(
              Activity(
                id: record[i]['activityID'], 
                name: record[i]['name'], 
                startTime: record[i]['startTime'],
                endTime: record[i]['endTime'],
                )
            );
        }
      });
    } catch (e) {
      print(e.toString());
    }
    listShowed = activityList;
  }
  
  Future<void> createActivity() async{
    DateTime time1 = DateFormat("HH:mm:00").parse(startTimeController.text);
    String stime = time1.toString();
    DateTime time2 = DateFormat("HH:mm:00").parse(endTimeController.text);
    String etime = time2.toString();
    
    var url = Uri.https(host, '/insertActivity.php', {'q': '{http}'});
    var response = await http.post(
        url,
        body: {
          "userID": userID.toString(),
          "name": activityController.text.toString(),
          "startTime": stime,
          "endTime": etime,
          "date": date,
        });
    var data = await json.decode(response.body);

    if(data["upload"] == true) {
      print("Create Success");
    }else {
      print("Upload invoice error");
    }
  }
  
  Future<void> DeleteActivity(int index) async{ 
    var url = Uri.https(host, '/deleteActivitySpecific.php', {'q': '{http}'});
    var response = await http.post(
        url,
        body: {
          "id": listShowed[index].id.toString()
        });
    var data = json.decode(response.body);
    if(data["delete"] == true) {
      Fluttertoast.showToast(
        msg: 'Activity Deleted',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    }else{
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Activity Delete Failed',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }
  
    /**
   * Function to get the position of tap by the user on the screen
   * @param the tap position on the screen
   */
  void getTapPosition(TapDownDetails tapPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(tapPosition.globalPosition);
    });
  }
  
  /**
   * Function to display the options of edit & delete of payment
   * @param: context of page, index of payment
   */
  void showBar(context, int index) async {
      final RenderObject? overlay = Overlay.of(context).context.findRenderObject();
      final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width, overlay.paintBounds.size.height)
        ),
        items: [
          PopupMenuItem(child: Text("Delete"), value: 0),
        ],
      );

      switch (result){
        case 0: {
          ShowDeleteDialog(index);
          break;
        }
      }
  }
  
  @override
  void initState() {
    getActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; // Height and width of current device
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5CEB8),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () => ShowCreateDialog(), 
            icon: Icon(
              (Icons.add),
              color: Colors.black)
            )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            // Here the height of the container is 45% of our total height
            height: size.height * .30,
            decoration: BoxDecoration(
              color: Color(0xFFF5CEB8),
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("assets/images/background.png"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    "Activity",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20
                      ),
                      itemCount: listShowed.length,
                      itemBuilder: (BuildContext context, int index){
                        return ViewActivity(listShowed[index].name.toString(), index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget ViewActivity(String text, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                offset: Offset(0,17),
                blurRadius: 17,
                spreadRadius: -23,
                color: Color(0xFFE6E6E6),
              )
            ]
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){
                print(date);
              },
              onLongPress: (){
                showBar(context, index);
              },
              onTapDown: (position){
                getTapPosition(position);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                  child: Column(
                  children: [
                    Text(
                    text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15)),
                    SizedBox(height: 10),
                    SvgPicture.asset(
                      "assets/images/calendar.svg",
                      height: 50,
                      width: 50
                      ),
                      SizedBox(height: 10),
                      Text('${listShowed[index].startTime} to ${listShowed[index].endTime}' ,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15)),
                  ],
                ),
              )
            ),
          )
        ),
    );
  }
  
  /**
   * Pop-up dialog for create activity
   */
  ShowCreateDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext contextLogout) {
        return StatefulBuilder(
          builder: (contextTime, setState){
            return AlertDialog(
              contentPadding: EdgeInsets.all(8),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: formkey1,
                      child: TextFormField(
                        controller: activityController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Activity Name",
                          labelStyle: TextStyle(fontSize: 20)
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value){
                          if(value!.isEmpty || value == ''){
                            return "Name should not be empty";
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: startTimeController,
                      readOnly: true,
                      style: TextStyle(fontSize: 10),
                      decoration: InputDecoration(
                        labelText: 'Start time',
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.timer),
                          onPressed: () {

                          },
                        )
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: endTimeController,
                      readOnly: true,
                      style: TextStyle(fontSize: 10),
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.timer),
                          onPressed: () {

                          },
                        )
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400]
                      ),
                      child: Text('Cancel', style: TextStyle(fontSize: 15)),
                      onPressed: (){
                        Navigator.of(contextTime, rootNavigator: true).pop();
                      }, 
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400]
                      ),
                      child: Text('Create', style: TextStyle(fontSize: 15)),
                      onPressed: () async{
                        if(formkey1.currentState!.validate()){
                          if(startTimeController.text != '' && endTimeController.text != '' ){
                            await createActivity().whenComplete(() {
                              getActivity().whenComplete(() => Navigator.of(contextTime, rootNavigator: true).pop());
                              activityList.clear();
                              activityController.clear();
                              startTimeController.clear();
                              endTimeController.clear();
                            });
                          }
                          else{
                            Fluttertoast.showToast(
                              msg: 'Please key in all the field',
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          }
                        }
                      }, 
                    ),
                  ],
                )
              ],
            );
          } 
          );
      },
    );
  }
  
  ShowDeleteDialog(int index) {
    return showDialog(
      context: context,
      builder: (BuildContext contextDelete) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Click 'CONFIRM' to logout"),
          actions: [
            TextButton(
              child: Text("CANCEL", style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.of(contextDelete, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text("CONFIRM", style: TextStyle(color: Colors.green, fontSize: 18),),
              onPressed: () async {
                await DeleteActivity(index).whenComplete(() {
                activityList.clear();
                getActivity().whenComplete(() => Navigator.of(contextDelete, rootNavigator: true).pop());
          });
              },
            ),
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:psm_project/data/userdata.dart';
import 'package:psm_project/profile.dart';
import 'Recommendation/activitySuggestion.dart';
import 'Recommendation/plannerSuggestion.dart';
import 'Schedule/schedule.dart';
import 'authentication/login.dart';


class MyHomepage extends StatelessWidget {
  const MyHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  
  bool isActive = false;
  int clickIndex = 0;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; // Height and width of current device
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            clickIndex = index;
            if(clickIndex == 1){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              ).whenComplete(() => setState(() => clickIndex = 0));
            }
          });
        },
        currentIndex: clickIndex,
        items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile'
        ),
      ]),
      body: Stack(
        children: <Widget>[
          Container(
            // Here the height of the container is 45% of our total height
            height: size.height * .45,
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
                  SizedBox(height: 50),
                  Text(
                    "Good Morning \n${name}",
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
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        ExerciseRecommend(
                          "Exercise Recommendation",
                          "assets/images/exercise.svg"
                        ),
                        ViewTimetable(
                          "Timetable",
                          "assets/images/calendar.svg"
                        ),
                        PlannerRecommend(
                          "Planner Recommendation",
                          "assets/images/PlannerWomen.svg"
                        ),
                      ],
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
  
  Widget ExerciseRecommend(String text, String image) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivitySuggestionPage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                  child: Column(
                  children: [
                    Spacer(),
                    SvgPicture.asset(image),
                    Spacer(),
                    Text(text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),)
                  ],
                ),
              )
            ),
          )
        ),
    );
  }
  
  Widget PlannerRecommend(String text, String image) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlannerSuggestionPage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                  child: Column(
                  children: [
                    Spacer(),
                    SvgPicture.asset(image),
                    Spacer(),
                    Text(text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),)
                  ],
                ),
              )
            ),
          )
        ),
    );
  }
  
  Widget ViewTimetable(String text, String image) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SchedulePage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                  child: Column(
                  children: [
                    Spacer(),
                    SvgPicture.asset(image, 
                    height: 80,
                    width: 80,),
                    Spacer(),
                    Text(text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),)
                  ],
                ),
              )
            ),
          )
        ),
    );
  }

  /**
   * Function to refresh the name on the top of homepage
   */
  // _GetRequestName() {
  //   setState(() {
  //     tempName = userName;
  //     topName = tempName.substring(0, tempName.indexOf(" "));
  //   });
  // }

  /**
   * Pop-up dialog for logout
   * if confirm, update loggedIn in database, save log in details,
   * destroy session and go back to login page
   */
  ShowLogoutDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext contextLogout) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Click 'CONFIRM' to logout"),
          actions: [
            TextButton(
              child: Text("CANCEL", style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.of(contextLogout, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text("CONFIRM", style: TextStyle(color: Colors.green, fontSize: 18),),
              onPressed: () async {
                // Navigator.of(contextLogout, rootNavigator: true).pop();
                // await Logout();
                // String temploginUsername = await SessionManager().get("username");
                // String temploginPassword = (await SessionManager().get("password")).toString();
                // await SessionManager().destroy();
                // await SessionManager().set('loginUsername', temploginUsername);
                // await SessionManager().set('loginPassword', temploginPassword);
                // loginAuthenticate = false;
                runApp(MyLoginPage());
              },
            ),
          ],
        );
      },
    );
  }
}
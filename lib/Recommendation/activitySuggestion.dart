// ignore_for_file: body_might_complete_normally_nullable
import 'package:flutter/material.dart';
import 'package:psm_project/model/class.dart';

class ActivitySuggestionPage extends StatefulWidget {
  const ActivitySuggestionPage({super.key});

  @override
  State<ActivitySuggestionPage> createState() => ASuggestionpageState();
}

class ASuggestionpageState extends State<ActivitySuggestionPage> {
  
  int questiionNo = 1;
  late PageController _controller;
  bool clickable = false;
  List resultList = [];
  
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    for(int i=0; i<Activityquestions.length; i++){
      Activityquestions[i].isLocked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${questiionNo}', style: TextStyle(fontSize: 25, color: Colors.black)),
        backgroundColor: const Color(0xFFF5CEB8),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 100),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: Activityquestions.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  final _question = Activityquestions[index];
                  return buildQuestion(_question);
                }
              )
            ),
            buildButton(),
            const SizedBox(height: 20),
          ],
        ),
      )
    );
  }
  
  Column buildQuestion(Question question){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(
          question.text,
          style: const TextStyle(fontSize: 25),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: OptionWidget(
            question: question,
            onClickedOption: (option){
              if(question.isLocked){
                return;
              }else {
                setState(() {
                  question.isLocked = true;
                  question.selection = option;
                  clickable = true;
                  resultList.add(question.selection?.selection);
                });
              }
            },
          ),
        ),
      ],
    );
  }
  
  Visibility buildButton(){
    return Visibility(
      visible: clickable,
      child: ElevatedButton(
        onPressed: (){
          if(questiionNo < Activityquestions.length){
            _controller.nextPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInExpo,
            );
            setState(() {
              questiionNo ++;
              clickable = false;
            });
          } else{
            Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => ResultPage(list: resultList))
              );
          }
        }, 
        child: Text(
          questiionNo < Activityquestions.length ? "Next Page" : "See the result"
        )
      ),
    );
  }
}

class OptionWidget extends StatelessWidget{
  final Question question;
  final ValueChanged<Option> onClickedOption;
  
  const OptionWidget({
    Key? key,
    required this.question,
    required this.onClickedOption
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
            child: Column(
              children: question.options.map((option) => buildOption(context, option)).toList(),
            ),
          );
  }
  
  Widget buildOption(BuildContext context, Option option){
    final color = getColorOption(option, question);
    return GestureDetector(
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option.text,
              style: const TextStyle(fontSize: 20),
            ),
            getIcon(option, question),
          ],
        ),
      ),
      onTap: () => onClickedOption(option),
    );
  }
  
  Color getColorOption(Option option, Question question){
    final isSelected = option == question.selection;
    if(question.isLocked){
      if(isSelected){
        return Colors.green;
      }
    }
    return Colors.grey.shade200;
  }
  
  Widget getIcon(Option option, Question question){
    final isSelected = option == question.selection;
    if(question.isLocked){
      if(isSelected){
        return const Icon(Icons.check_circle, color: Colors.green);
      }
    }
    return const SizedBox.shrink();
  }
}

class ResultPage extends StatelessWidget{
  const ResultPage({
    Key? key,
    required this.list
  }): super(key: key);
  
  final List list;
  
  @override
  Widget build(BuildContext context){
    List activity = [];
    List duration = [];
    List time = [];
    
    if(list[2] == 1){
      if(list[0] == 1){
        if(list[1] == 1){ // Male below 20 years old for indoor
          activity.add('Fitness and Exercise');
          duration.add('1');
          time.add('Anytime');
          
          activity.add('Gardening');
          duration.add('1');
          time.add('Evening');
          
          activity.add('Arts and Crafts');
          duration.add('2');
          time.add('Anytime');
          
          activity.add('Reading and writing');
          duration.add('2');
          time.add('Anytime');
          
        } else if(list[1] == 2){ // Male between 20 - 29 years old for indoor    
          activity.add('Fitness and Exercise');
          duration.add('1');
          time.add('Anytime');
          
          activity.add('Gardening');
          duration.add('1');
          time.add('Evening');
          
          activity.add('Indoor Sports');
          duration.add('2');
          time.add('Evening or Night');
          
          activity.add('Reading and writing');
          duration.add('2');
          time.add('Anytime');
          
        } else if(list[1] == 3){ // Male between 30 - 39 years old for indoor
          activity.add('Fitness and Exercise');
          duration.add('1');
          time.add('Anytime');
          
          activity.add('Gardening');
          duration.add('1');
          time.add('Evening');
          
          activity.add('Arts and Crafts');
          duration.add('2');
          time.add('Anytime');
          
          activity.add('Reading and writing');
          duration.add('2');
          time.add('Anytime');
        } else{ // Male above 40 years old for indoor
          activity.add('Fitness and Exercise');
          duration.add('1');
          time.add('Anytime');
          
          activity.add('Gardening');
          duration.add('1');
          time.add('Evening');
          
          activity.add('Arts and Crafts');
          duration.add('2');
          time.add('Anytime');
          
          activity.add('Reading and writing');
          duration.add('2');
          time.add('Anytime');
        }
      } else{
        if(list[1] == 1){ // Female below 20 years old for indoor
          activity.add('Cooking and baking');
          duration.add('1');
          time.add('Anytime');
          
          activity.add('Gardening');
          duration.add('1');
          time.add('Evening');
          
          activity.add('Arts and Crafts');
          duration.add('2');
          time.add('Anytime');
          
          activity.add('Reading and writing');
          duration.add('2');
          time.add('Anytime');
          
        } else if(list[1] == 2){ // Female between 20 - 29 years old for indoor
          activity.add('Cooking and baking');
          duration.add('1');
          time.add('Anytime');
          
          activity.add('Gardening');
          duration.add('1');
          time.add('Evening');
          
          activity.add('Arts and Crafts');
          duration.add('2');
          time.add('Anytime');
          
          activity.add('Reading and writing');
          duration.add('2');
          time.add('Anytime');
          
        } else if(list[1] == 3){ // Female between 30 - 39 years old for indoor
          activity.add('Cooking and baking');
          duration.add('1');
          time.add('Anytime');
          
          activity.add('Indoor fitness');
          duration.add('1');
          time.add('Evening');
          
          activity.add('Arts and Crafts');
          duration.add('2');
          time.add('Anytime');
          
          activity.add('Reading and writing');
          duration.add('2');
          time.add('Anytime');
          
        } else{ // Female above 40 years old for indoor
          activity.add('Cooking and baking');
          duration.add('1');
          time.add('Anytime');
          
          activity.add('Indoor fitness');
          duration.add('1');
          time.add('Evening');
          
          activity.add('Arts and Crafts');
          duration.add('2');
          time.add('Anytime');
          
          activity.add('Reading and writing');
          duration.add('2');
          time.add('Anytime'); 
        }
      }
    } else{
      if(list[0] == 1){
        if(list[1] == 1){ // Male below 20 years old for outdoor
          activity.add('Sports');
          duration.add('2');
          time.add('Evening');
          
          activity.add('Volunteer works');
          duration.add('-');
          time.add('Anytime');
          
          activity.add('Hiking');
          duration.add('-');
          time.add('Morning');
          
        } else if(list[1] == 2){ // Male between 20 - 29 years old for outdoor
          activity.add('Sports');
          duration.add('2');
          time.add('Evening');
          
          activity.add('Volunteer works');
          duration.add('-');
          time.add('Anytime');
          
          activity.add('Hiking');
          duration.add('-');
          time.add('Morning');
          
        } else if(list[1] == 3){ // Male between 30 - 39 years old for outdoor
          activity.add('Sports');
          duration.add('2');
          time.add('Evening or Night');
          
          activity.add('Volunteer works');
          duration.add('-');
          time.add('Anytime');
          
          activity.add('Hiking');
          duration.add('-');
          time.add('Morning');
          
        } else{ // Male above 40 years old for outdoor
          activity.add('Sports');
          duration.add('2');
          time.add('Evening or Night');
          
          activity.add('Volunteer works');
          duration.add('-');
          time.add('Anytime');
          
          activity.add('Hiking');
          duration.add('-');
          time.add('Morning');
          
          activity.add('Camping');
          duration.add('-');
          time.add('Anytime');
        }
      } else{
        if(list[1] == 1){ // Female below 20 years old for outdoor
          activity.add('Jogging');
          duration.add('1');
          time.add('Evening or Night');
          
          activity.add('Volunteer works');
          duration.add('-');
          time.add('Anytime');
          
          activity.add('Cycling');
          duration.add('1');
          time.add('Evening');
          
        } else if(list[1] == 2){ // Female between 20 - 29 years old for outdoor
          activity.add('Jogging');
          duration.add('1');
          time.add('Evening or Night');
          
          activity.add('Volunteer works');
          duration.add('-');
          time.add('Anytime');
          
          activity.add('Cycling');
          duration.add('1');
          time.add('Evening');
          
          activity.add('Nature walk');
          duration.add('1');
          time.add('Evening or Night');
          
        } else if(list[1] == 3){ // Female between 30 - 39 years old for outdoor
          activity.add('Jogging');
          duration.add('1');
          time.add('Evening or Night');
          
          activity.add('Volunteer works');
          duration.add('-');
          time.add('Anytime');
          
          activity.add('Cycling');
          duration.add('1');
          time.add('Evening');
          
          activity.add('Nature walk');
          duration.add('1');
          time.add('Evening or Night');
          
        } else{ // Female above 40 years old for outdoor
          activity.add('Jogging');
          duration.add('1');
          time.add('Evening or Night');
          
          activity.add('Volunteer works');
          duration.add('-');
          time.add('Anytime');
          
          activity.add('Cycling');
          duration.add('1');
          time.add('Evening');
          
          activity.add('Nature walk');
          duration.add('1');
          time.add('Evening or Night');
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result', style: TextStyle(fontSize: 25, color: Colors.black)),
        backgroundColor: const Color(0xFFF5CEB8),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text('Your activity recommendation is listed out as below: ', style: TextStyle(fontSize: 16)),
          ),
          SizedBox(height: 20),
          Center(
            child: Table(
              border: TableBorder.all(),
              columnWidths: {
                0:FractionColumnWidth(0.4),
                1:FractionColumnWidth(0.3),
                2:FractionColumnWidth(0.3),
              },
              children: [
                buildTitle(['Activity', 'Duration', 'Time']),
                for(int i=0;i<activity.length;i++)
                buildBody(activity[i], duration[i], time[i]),
              ],
            )
          ),
        ],
      )
    );
  }
  
  TableRow buildTitle(List cells) => TableRow(
    children: cells.map((cell) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Text(cell, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
        ),
      );
    }).toList()
  );
  
  TableRow buildBody(String activity, String duration, String time) {
      return TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                child: Text('${activity}', style: TextStyle(fontSize: 15)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Text('${duration}', style: TextStyle(fontSize: 15)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
            child: SizedBox(
              child: Text('${time}', style: TextStyle(fontSize: 15)),
            ),
          ),
        ]
      );
  }
}
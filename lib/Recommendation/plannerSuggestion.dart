// ignore_for_file: body_might_complete_normally_nullable
import 'package:flutter/material.dart';
import 'package:psm_project/model/class.dart';

class PlannerSuggestionPage extends StatefulWidget {
  const PlannerSuggestionPage({super.key});

  @override
  State<PlannerSuggestionPage> createState() => PSuggestionpageState();
}

class PSuggestionpageState extends State<PlannerSuggestionPage> {
  
  int questiionNo = 1;
  late PageController _controller;
  bool clickable = false;
  List resultList = [];
  
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    for(int i=0; i<Plannerquestions.length; i++){
      Plannerquestions[i].isLocked = false;
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
                itemCount: Plannerquestions.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  final _question = Plannerquestions[index];
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
          if(questiionNo < Plannerquestions.length){
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
          questiionNo < Plannerquestions.length ? "Next Page" : "See the result"
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
        if(list[1] == 1){ // Male student below 20 years old
          activity.add('Going to school');
          duration.add('7');
          time.add('7 a.m. to 2 p.m.');
          
          activity.add('Lunch');
          duration.add('1');
          time.add('2 p.m. to 3 p.m.');
          
          activity.add('Doing homework');
          duration.add('1');
          time.add('3:30 p.m. to 4:30 p.m.');
          
          activity.add('Doing hobby');
          duration.add('2');
          time.add('5 p.m. to 7 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('8 p.m. to 9 p.m.');
          
          activity.add('Doing homework');
          duration.add('1');
          time.add('9:30 p.m. to 10:30 p.m.');
        } else if(list[1] == 2){ // Male student between 20 - 29 years old       
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Doing hobby');
          duration.add('2');
          time.add('5 p.m. to 7 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('8 p.m. to 9 p.m.');
          
          activity.add('Doing homework');
          duration.add('2');
          time.add('9:30 p.m. to 11:30 p.m.');
          
        } else if(list[1] == 3){ // Male student between 30 - 39 years old 
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('7 p.m. to 8 p.m.');
          
          activity.add('Doing homework');
          duration.add('2');
          time.add('9:30 p.m. to 11:30 p.m.');
        } else{ // Male student above 40 years old 
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('6 p.m. to 7 p.m.');
          
          activity.add('Doing homework');
          duration.add('2');
          time.add('8:30 p.m. to 10:30 p.m.');
        }
      } else{
        if(list[1] == 1){ // Female student below 20 years old
          activity.add('Going to school');
          duration.add('7');
          time.add('7 a.m. to 2 p.m.');
          
          activity.add('Lunch');
          duration.add('1');
          time.add('2 p.m. to 3 p.m.');
          
          activity.add('Doing homework');
          duration.add('1');
          time.add('3:30 p.m. to 4:30 p.m.');
          
          activity.add('Doing hobby');
          duration.add('2');
          time.add('5 p.m. to 7 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('8 p.m. to 9 p.m.');
          
          activity.add('Doing homework');
          duration.add('1');
          time.add('9:30 p.m. to 10:30 p.m.'); 
          
        } else if(list[1] == 2){ // Female student between 20 - 29 years old
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Doing hobby');
          duration.add('2');
          time.add('5 p.m. to 7 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('8 p.m. to 9 p.m.');
          
          activity.add('Doing homework');
          duration.add('2');
          time.add('9:30 p.m. to 11:30 p.m.'); 
          
        } else if(list[1] == 3){ // Female student between 30 - 39 years old
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Doing hobby');
          duration.add('2');
          time.add('5 p.m. to 7 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('8 p.m. to 9 p.m.');
          
          activity.add('Doing homework');
          duration.add('2');
          time.add('9:30 p.m. to 11:30 p.m.'); 
          
        } else{ // Female student above 40 years old
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Doing hobby');
          duration.add('2');
          time.add('5 p.m. to 7 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('7 p.m. to 8 p.m.');
          
          activity.add('Doing homework');
          duration.add('1');
          time.add('9:00 p.m. to 10:00 p.m.'); 
        }
      }
    } else{
      if(list[0] == 1){
        if(list[1] == 1){ // Male worker below 20 years old
          activity.add('Go to work');
          duration.add('8');
          time.add('9 a.m. to 6 p.m.');
          
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('7 p.m. to 8 p.m.');
          
          activity.add('Doing hobby');
          duration.add('1');
          time.add('9 p.m. to 10 p.m.');
          
          activity.add('Rest');
          duration.add('8');
          time.add('11 p.m. to 7 p.m.');
          
        } else if(list[1] == 2){ // Male worker between 20 - 29 years old
          activity.add('Go to work');
          duration.add('8');
          time.add('9 a.m. to 6 p.m.');
          
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('7 p.m. to 8 p.m.');
          
          activity.add('Doing hobby');
          duration.add('1');
          time.add('9 p.m. to 10 p.m.');
          
          activity.add('Rest');
          duration.add('8');
          time.add('11 p.m. to 7 p.m.');
          
        } else if(list[1] == 3){ // Male worker between 30 - 39 years old
          activity.add('Go to work');
          duration.add('8');
          time.add('9 a.m. to 6 p.m.');
          
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('7 p.m. to 8 p.m.');
          
          activity.add('Doing hobby');
          duration.add('1');
          time.add('9 p.m. to 10 p.m.');
          
          activity.add('Rest');
          duration.add('8');
          time.add('11 p.m. to 7 p.m.');
          
        } else{ // Male worker above 40 years old
          activity.add('Go to work');
          duration.add('8');
          time.add('9 a.m. to 6 p.m.');
          
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('7 p.m. to 8 p.m.');
          
          activity.add('Doing hobby');
          duration.add('1');
          time.add('9 p.m. to 10 p.m.');
          
          activity.add('Rest');
          duration.add('8');
          time.add('11 p.m. to 7 p.m.');
        }
      } else{
        if(list[1] == 1){ // Female worker below 20 years old
          activity.add('Go to work');
          duration.add('8');
          time.add('9 a.m. to 6 p.m.');
          
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('7 p.m. to 8 p.m.');
          
          activity.add('Doing hobby');
          duration.add('1');
          time.add('9 p.m. to 10 p.m.');
          
          activity.add('Rest');
          duration.add('8');
          time.add('11 p.m. to 7 p.m.');
          
        } else if(list[1] == 2){ // Female worker below 20 years old
          activity.add('Go to work');
          duration.add('8');
          time.add('9 a.m. to 6 p.m.');
          
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('7 p.m. to 8 p.m.');
          
          activity.add('Doing hobby');
          duration.add('1');
          time.add('9 p.m. to 10 p.m.');
          
          activity.add('Rest');
          duration.add('8');
          time.add('11 p.m. to 7 p.m.');
          
        } else if(list[1] == 3){ // Female worker below 20 years old
          activity.add('Go to work');
          duration.add('8');
          time.add('9 a.m. to 6 p.m.');
          
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('7 p.m. to 8 p.m.');
          
          activity.add('Doing hobby');
          duration.add('1');
          time.add('9 p.m. to 10 p.m.');
          
          activity.add('Rest');
          duration.add('8');
          time.add('11 p.m. to 7 p.m.');
          
        } else{ // Female worker below 20 years old
          activity.add('Go to work');
          duration.add('8');
          time.add('9 a.m. to 6 p.m.');
          
          activity.add('Lunch');
          duration.add('1');
          time.add('1 p.m. to 2 p.m.');
          
          activity.add('Dinner');
          duration.add('1');
          time.add('7 p.m. to 8 p.m.');
          
          activity.add('Doing hobby');
          duration.add('1');
          time.add('9 p.m. to 10 p.m.');
          
          activity.add('Rest');
          duration.add('8');
          time.add('11 p.m. to 7 p.m.');
          
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
            child: Text('Your time recommendation is listed out as below: ', style: TextStyle(fontSize: 16)),
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
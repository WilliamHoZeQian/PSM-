import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../model/server.dart';


class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => ResetPageState();
}

class ResetPageState extends State<ResetPage> {
  var font =  const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            );
            
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool verifyButton = false;
  int num = 0;
  bool _visible = true;
  bool clickable = true;
  bool showPasswordConfirm = false;

  /**
   * Send email function from PHP
   * TODO: Email is not finished yet
   */
  Future<void> SendEmail(String email, String otp) async{
    var url = Uri.https(host, "/email.php", {'q': 'http'});
    var response = await http.post(
      url,
      body: {
        "Email": email,
        "Code": otp
      }
    );
    print(response.body);
  }

  /**
   * Function to validate email and password
   */
  void validate() async{
    if(email.value.text == '') {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Please filled in the Email',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
    else if (password.value.text == '' || confirmPassword.value.text == '') {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Please filled in the password',
        toastLength: Toast.LENGTH_SHORT,
      );
    }else if(password.value.text.length <8) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Password need to be at least 8 digit',
        toastLength: Toast.LENGTH_SHORT,
      );
    }else if(password.value.text.length >20) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Password need to be at most 20 digit',
        toastLength: Toast.LENGTH_SHORT,
      );
    }else if (password.text == confirmPassword.text) {
      await reset().then((value) {
        if(value == 0){
          Navigator.pop(context);
        }
      });
    }else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Password does not match',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }
  
   /**
   * Function to check if email exist in the database
   * @param: email
   * @return:
   * ["exist"]: if true user exist, else user does not exist
   */
  Future<int> validateUser() async {
    var url = Uri.https(host, '/verfiyemail.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "Email": email.text.toString(),
    });
    var data = json.decode(response.body);
    if (data['exist'] == false) {
      return 0;
    }else {
      return 1;
    }
  }


  /**
   * Function to reset password in database
   * @pararm: email, password
   * @return:
   * ["reset"]: if true, password is reset, else password is not reset
   */
  Future<int> reset() async {
    var url = Uri.https(host, '/resetpassword.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "Email": email.text.toString(),
      "NewPassword": password.text.toString(),
    });

    var data = json.decode(response.body);
    
    if (data['reset'] == false) {
      Fluttertoast.showToast(
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        msg: 'User Not exist!',
        toastLength: Toast.LENGTH_SHORT,
      );
      return 1;
    }else {
      Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Password Reset Successful',
        toastLength: Toast.LENGTH_SHORT,
      );
      return 0;
    }
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Reset Password",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          /// go back to login page
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color.fromRGBO(17, 91, 137, 1)),
            onPressed: () {
              // passing this to our root
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 80),
                    SizedBox(child: Icon(Icons.lock, size: 130, color: Colors.black,),),
                    Email(),
                    OTPController(),
                    if(verifyButton) Password(),
                    if(verifyButton) ConfirmPassword(),
                    (verifyButton? ResetPassword() : VerifyOTP()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * @return textfield for email
   */
  Widget Email() {
    return Container(
      width: 350,
      height: 80,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        enabled: clickable,
        controller: email,
        decoration: InputDecoration(
          suffixIcon: TextButton(
            child: Text("Sent OTP"),
            onPressed: () async{
              num = Random().nextInt(99999 - 10000) + 10000;
              if(email.text != '') {
                await validateUser().then((value) async{
                  if(value == 0){
                    Fluttertoast.showToast(
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                      msg: 'User does not exist!',
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                  else{
                    await SendEmail(email.text, num.toString());
                  }
                });
              } else {
                print('Email is empty');
              }
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(80.0),
          ),
          labelText: 'Email *',
        ),
      ),
    );
  }

  /**
   * @return textfield for OTP code
   */
  Widget OTPController() {
    return Visibility(
      visible: _visible,
      child: Container(
        width: 350,
        height: 80,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: TextField(
          controller: otpController,
          decoration: InputDecoration(
            labelText: 'OTP Value',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(80.0),
            ),
          ),
        ),
      ),
    );
  }

  /**
   * @return textfield for entering new password
   */
  Widget Password() {
    return Container(
      width: 350,
      height: 80,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextFormField(
        controller: password,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(80.0),
          ),
          labelText: 'Password',
        ),
        validator: (value){
          if (value!.isEmpty) {
            return ("Password is required for registration");
          }else if (value.length < 8) {
            return ("Enter Valid Password(Min. 8 Character)");
          }else {
            return null;
          }
        },
      ),
    );
  }

  /**
   * @return textfield for confirming new password
   */
  Widget ConfirmPassword() {
    return Container(
      width: 350,
      height: 80,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextFormField(
        controller: confirmPassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: !showPasswordConfirm,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          labelText: 'Confirm Password',
          suffixIcon: IconButton(
            icon: (showPasswordConfirm? Icon(Icons.visibility): Icon(Icons.visibility_off)),
            onPressed: () {
              setState(() {
                showPasswordConfirm = !showPasswordConfirm;
              });
            },
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return ("Password is required for registration");
          }else if (value != password.text) {
            return ("Password does not match");
          }else {
            return null;
          }
        },
      ),
    );
  }

  /**
   * @return button to reset password
   */
  Widget ResetPassword() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: StadiumBorder(),
          backgroundColor: Colors.black,
        ),
        child: Text('Recover Password', style: font),
        onPressed: () {
          validate();
        },
      ),
    );
  }

  /**
   * @return button to verify OTP code
   */
  Widget VerifyOTP() {
    return Container(
      height: 80,
      width: 350,
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: StadiumBorder(),
          backgroundColor: Colors.black,
        ),
        child: Text('Verify', style: font),
        onPressed: () {
          if(otpController.value != '') {
            if (otpController.text == num.toString()) {
              setState(() {
                verifyButton = true;
                _visible = false;
                clickable = false;
              });
            } else {
              Fluttertoast.showToast(
                backgroundColor: Colors.red,
                textColor: Colors.white,
                msg: 'OTP Value or Email is Invalid',
                toastLength: Toast.LENGTH_SHORT,
              );
            }
          } else {
            print("otp value empty");
          }
        },
      ),
    );
  }
}

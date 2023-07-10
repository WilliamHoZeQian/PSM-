import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import '../model/server.dart';
import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey = GlobalKey<FormState>(); // on sign up information
  TextEditingController fullNameEditingController = new TextEditingController();
  TextEditingController userNameEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController phoneNoEditingController = new TextEditingController();
  TextEditingController confirmPasswordEditingController = new TextEditingController();
  final bool _show = true;
  String companyName = '';
  bool showPassword = false, showPasswordConfirm = false;
  /// for each textfield in order of (Name, Email, Phone No, username, password, confirm password)
  List<bool> valid = [false, false, false, false, false, false];
  bool pressDone = false;

  /**
   * Register user account to subcon
   * @param: username, password, name, email, phone, Reference ID
   * @return:
   * ["exist"]: if true, username already existed
   * ["insert"]: if true, user information is successfully signed up
   */
  Future<int> register() async {
    var url = Uri.https(host, "/signup.php", {'q': 'http'});
    var response = await http.post(
      url, body: 
      {
      "Username": userNameEditingController.text,
      "Password": passwordEditingController.text,
      "Name": fullNameEditingController.text,
      "Email": emailEditingController.text,
      "Phone": phoneNoEditingController.text,
    });
    print(response.body);
    var data = json.decode(response.body);

      if(data["exist"] == true) {
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: 'Username already existed',
          toastLength: Toast.LENGTH_SHORT,
        );
        return 1;
      }else if (data["insert"] == true) {
        Fluttertoast.showToast(
          backgroundColor: Colors.green,
          textColor: Colors.white,
          msg: 'Registration Successful',
          toastLength: Toast.LENGTH_SHORT,
        );
        return 0;
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: 'Registration Unsuccessful',
          toastLength: Toast.LENGTH_SHORT,
        );
        return 1;
    }
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.black,
              ),
              textScaleFactor: 1.3,
            ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // passing this to our root
              ({
                Navigator.of(context).pop(),
                runApp(MyLoginPage())
              });
                
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  children: [
                     Form(
                       key: formKey,
                       child: Column(
                         children: [
                           fullNameField(), /// Name textfield
                           space(),
                           emailField(), /// Email textfield
                           space(),
                           phoneNoField(), /// Phone textfield
                           space(),
                           userNameField(), /// Username textfield
                           space(),
                           passwordField(), /// Password textfield
                           space(),
                           confirmPasswordField(), /// Confirm Password textfield
                           space(),
                           signUpButton(), /// Sign up button
                           space(),
                         ],
                       ),
                     ),
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }

  /**
   * $return sizedBox with height of 20
   * wrapped with visibility widget with bool "_show" for visible
   */
  Widget space(){
    return Visibility(
      visible: _show,
      child: SizedBox(height: 20));
  }

  /**
   * @return textfield for name
   */
  Widget fullNameField() {
    return Visibility(
      visible: _show,
        child: TextFormField(
        autofocus: false,
        controller: fullNameEditingController,
        keyboardType: TextInputType.name,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty) {
            valid[0] = false;
            pressDone = !valid.any((b) => !b);
            return ("Name cannot be Empty");
          }else if (value.length < 3) {
            valid[0] = false;
            pressDone = !valid.any((b) => !b);
            return ("Enter Valid name(Min. 3 Character)");
          }else {
            valid[0] = true;
            pressDone = !valid.any((b) => !b);
            return null;
          }
        },
          onChanged: (value) {
            CheckPressDone();
          },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Full Name *",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(80),
          ),
        ),
      ),
    );
  }

  /**
   * @return textfield for email
   */
  Widget emailField() {
    return Visibility(
        visible: _show,
        child: TextFormField(
          autofocus: false,
          controller: emailEditingController,
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              valid[1] = false;
              pressDone = !valid.any((b) => !b);
              return ("Please Enter Your Email");
            }else if (!EmailValidator.validate(value)) {
              valid[1] = false;
              pressDone = !valid.any((b) => !b);
              return ("Please Enter a valid email");
            }else {
              valid[1] = true;
              pressDone = !valid.any((b) => !b);
              return null;
            }
          },
          onChanged: (value) {
            CheckPressDone();
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email *",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(80),
            ),
          ),
        )
    );
  }

  /**
   * @return textfield for phone
   */
  Widget phoneNoField() {
    return Visibility(
      visible: _show,
      child: TextFormField(
        autofocus: false,
        controller: phoneNoEditingController,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty) {
            valid[2] = false;
            pressDone = !valid.any((b) => !b);
            return ("Phone Number is required for registration");
          }else {
            valid[2] = true;
            pressDone = !valid.any((b) => !b);
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone_android),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number *",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(80),
          ),
        ),
      ),
    );
  }

  /**
   * @return textfield for username
   */
  Widget userNameField() {
    return Visibility(
      visible: _show,
      child: TextFormField(
        autofocus: false,
        maxLength: 20,
        controller: userNameEditingController,
        keyboardType: TextInputType.name,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty) {
            valid[3] = false;
            pressDone = !valid.any((b) => !b);
            return ("Username is required for registration");
          }else if (value.length < 5) {
            valid[3] = false;
            pressDone = !valid.any((b) => !b);
            return ("Enter username(Min. 8 Character)");
          }else {
            valid[3] = true;
            pressDone = !valid.any((b) => !b);
            return null;
          }
        },
        onChanged: (value) {
          CheckPressDone();
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Username *",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(80),
          ),
        ),
      ),
    );
  }

  /**
   * @return textfield for password
   */
  Widget passwordField() {
    return Visibility(
      visible: _show,
      child: TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: !showPassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty) {
            valid[4] = false;
            pressDone = !valid.any((b) => !b);
            return ("Password is required for registration");
          }else if (value.length < 8) {
            valid[4] = false;
            pressDone = !valid.any((b) => !b);
            return ("Enter Valid Password(Min. 8 Character)");
          }else {
            valid[4] = true;
            pressDone = !valid.any((b) => !b);
            return null;
          }
        },
        onChanged: (value) {
          CheckPressDone();
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          suffixIcon: IconButton(
            icon: (showPassword? Icon(Icons.visibility): Icon(Icons.visibility_off)),
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
          ),
          hintText: "Password *",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(80),
          ),
        ),
      )
    );
  }
  
    /**
   * @return textfield for confirm password
   */
  Widget confirmPasswordField() {
    return Visibility(
      visible: _show,
      child: TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: !showPasswordConfirm,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty) {
            valid[5] = false;
            pressDone = !valid.any((b) => !b);
            return ("Password is required for registration");
          }else if (value != passwordEditingController.text) {
            valid[5] = false;
            pressDone = !valid.any((b) => !b);
            return ("Password does not match");
          }else {
            valid[5] = true;
            pressDone = !valid.any((b) => !b);
            return null;
          }
        },
        onChanged: (value) {
          CheckPressDone();
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password *",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          suffixIcon: IconButton(
            icon: (showPasswordConfirm? Icon(Icons.visibility): Icon(Icons.visibility_off)),
            onPressed: () {
              setState(() {
                showPasswordConfirm = !showPasswordConfirm;
              });
            },
          ),
        ),
      )
    );
  }

  /**
   * @return button for sign up
   */
  Widget signUpButton() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(30),
      color: (pressDone? Colors.black: Colors.grey),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (pressDone? () async{
          if(formKey.currentState!.validate()){
            await register().then((value) {
              if(value == 0){
                Navigator.pop(context);
              }else{
                // do nothing
              }
            });
          }
        } : null
        ),
        child: Text(
          "Done",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
      ),
    );
  }

  /**
   * Function to check if any of the textfield is filled correctly or not
   * If all is true, then pressdone is true, else if false
   */
  CheckPressDone() {
    setState(() {
      pressDone = !valid.any((b) => !b);
    });
  }
}

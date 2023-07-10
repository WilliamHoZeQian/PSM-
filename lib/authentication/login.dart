import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:psm_project/homepage.dart';

import '../data/userdata.dart';
import '../model/server.dart';
import 'register.dart';
import 'resetPassword.dart';

class MyLoginPage extends StatelessWidget {
  MyLoginPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loginPage(),
    );
  }
}

class loginPage extends StatefulWidget {
  loginPage({super.key});

  @override
  State<loginPage> createState() => loginPageState();
}

class loginPageState extends State<loginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey2 = GlobalKey<FormState>(); // on Email
  final _formKey1 = GlobalKey<FormState>(); // on Password

  /**
   * Login Function
   * @param: Username, Password
   * @return:
   * ["login"]: If true data exist, else invalid log in details
   * ["end"]: if true subscription ended, else subscription still valid
   * ["loggedIn"]: if true account is logged in, else account is not logged in
   * User information, User permission
   */
  Future<void> login() async {
    var url = Uri.https(host, '/login.php', {'q': '{http}'});
    try{
        var response = await http.post(
        url,
        body: {
          "username": username.text,
          "password": password.text,
        },
      );
      var data = await json.decode(response.body);
      if (data["login"] == true) {
        Fluttertoast.showToast(
            backgroundColor: Colors.green,
            textColor: Colors.white,
            msg: 'Login Success',
            toastLength: Toast.LENGTH_SHORT,
          );
          name = data['name'];
          phone = data['phone'];
          email = data['email'];
          userID = data['id'];
          if(data['image'] == null){
            ByteData imageFile = await rootBundle.load('assets/images/profile.png');
            var Image = imageFile.buffer;
            var defaultImage = base64.encode(Uint8List.view(Image));
            imageDecoded = base64.decode(defaultImage.toString());
          }else{
            image = data['image'];
            try{
              imageDecoded = base64.decode(image.toString());
            }catch (e){
              print(e.toString());
            }
          }
          runApp(MyHomepage());
      }else{
          Fluttertoast.showToast(
            backgroundColor: Colors.red,
            textColor: Colors.white,
            msg: 'Username and password invalid',
            toastLength: Toast.LENGTH_SHORT,
          );
      }
    } catch(e){
      print(e);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          child: Stack(
            children: <Widget>[
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 140),
                      _logo(), /// Logo
                      const SizedBox(height: 15),
                      // _loginLabel(), /// System Name
                      // const SizedBox(height: 40),
                      _labelUsernameInput(), /// Textfield for username
                      const SizedBox(height: 30),
                      _labelPasswordInput(), /// Textfield for password
                      const SizedBox(height: 10),
                      _forgetPassword(), /// Forget password button
                      const SizedBox(height: 35),
                      _loginBtn(), /// Login button
                      const SizedBox(height: 7),
                      /// Sign up Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _signUpLabel(),
                          const SizedBox(width: 5),
                          _signUpLabel2(),
                          const SizedBox(height: 35),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * @return Logo
   */
  Widget _logo() {
    return Center(
      child: SizedBox(
        child: Image.asset("assets/images/logo.png"),
        height: 105,
      ),
    );
  }

  /**
   * Name of the system
   * @return label "SubCon System"
   */
  Widget _loginLabel() {
    return Center(
      child: Text(
        "H-Life System",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 34,
          ),
        ),
      );
  }

  /**
   * @return textfield for username
   */
  Widget _labelUsernameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Username",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: Form(
            key: _formKey2,
            child: TextField(
            controller: username,
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(80.0)
              ),
              hintText: "Your Username",
              hintStyle: TextStyle(
                  color: Color(0xffc5d2e1),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
            ),
          ),
          )          
        )
      ],
    );
  }

  /**
   * @return textfield for password
   */
  Widget _labelPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: Form(
            key: _formKey1,
            child: TextField(
            controller: password,
            obscureText: true,
            cursorColor: Colors.red,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(80.0)
              ),
              hintText: "Your Password",
              hintStyle: const TextStyle(
                  color: Color(0xffc5d2e1),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
              ),
            ),
          ),
          ),
        ),
      ],
    );
  }

  /**
   * @return button / gesture detector for forget password
   */
  Widget _forgetPassword() {
    return Padding(
      padding: EdgeInsets.only(left: 165),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPage(),
            ),
          );
        },
        child: Text(
          "Forget Password?",
          style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w800,
              fontSize: 12,
          ),
        ),
      ),
    );
  }


  /**
   * @return button for login
   */
  Widget _loginBtn() {
    return Container(
      width: 350,
      height: 40,
      child: ElevatedButton(
        child: Text(
          'Log In',
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
          ),
        ),
        onPressed: () async{
          if (_formKey2.currentState!.validate() && _formKey1.currentState!.validate()){
            await login();
          }
        },
      ),
    );
  }

  /**
   * @return text for sign up
   */
  Widget _signUpLabel() {
    return Text(
      "Don't have an account yet?",
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 13,
      ),
    );
  }

  /**
   * @return button for sign up
   */
  Widget _signUpLabel2() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationScreen(),
          ),
        );
      },
      child: Text(
        "Sign Up",
        style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
      ),
    );
  }
}

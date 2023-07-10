import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'authentication/login.dart';
import 'data/userdata.dart';
import 'model/server.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String fullname = name, useremail = email, userphone = phone;
  TextEditingController fullNameEditingController = TextEditingController(text: name);
  TextEditingController emailEditingController = TextEditingController(text: email);
  TextEditingController phoneNoEditingController = TextEditingController(text: phone);
  TextEditingController passwordEditingController = TextEditingController(text: "*******");
  bool edit = false;
  File? uploadImage;
  var showImage = imageDecoded;

  Future<void> Update() async {
    var url = Uri.https(host, "/updateprofile.php", {'q': 'http'});
    var response = await http.post(
      url,
      body: {
        "Name": fullNameEditingController.text,
        "Email": emailEditingController.text,
        "Phone": phoneNoEditingController.text,
      },
    );
    var data = await json.decode(response.body);

    if(data["update"] == true) {
      // SessionManager().set('name', fullNameEditingController.text);
      // SessionManager().set('email', emailEditingController.text);
      // SessionManager().set('phone', phoneNoEditingController.text);
      Fluttertoast.showToast(
        msg: 'Update Successful',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      setState(() {
        fullname = fullNameEditingController.text;
        useremail = emailEditingController.text;
        userphone = phoneNoEditingController.text;
        name = fullname;
        email = useremail;
        phone = userphone;
      });
    }else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Update Unsuccessful',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future<void> UploadImage() async {
    Uint8List imageByte = await uploadImage!.readAsBytes();
    String path = base64.encode(imageByte);

    var url = Uri.https(host, "/updateimage.php", {'q': 'http'});
    var response = await http.post(
      url,
      body: {
        "Email": email,
        "Image": path,
      },
    );
    var data = await json.decode(response.body);

    if(data["upload"] == true) {
      Fluttertoast.showToast(
        msg: 'Update Successful',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      setState(() {
        imageDecoded = base64.decode(path.toString());
        showImage = imageDecoded; 
      });
    }else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Update Unsuccessful',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile Page",
          textScaleFactor: 1.3,
          style: TextStyle(
              color: Colors.black
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                ViewImage(),
                const SizedBox(height: 30),
                EditButton(),
                const SizedBox(height: 10),
                (edit? EditUserInfo() : UserInfo()),
                LogoutButton(),
                // EditUserInfo(),
                // UserInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ViewImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: Colors.white),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  // blurRadius: 10,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: MemoryImage(showImage)
              ),
            ),
          ),
          Positioned(
            left: 150,
            top: 155,
            child: IconButton(
              onPressed: () async{
                await PickImage().whenComplete(() async{
                  await UploadImage();
                });
              },
              icon: Icon(Icons.edit),
            ),
          ),
        ]
      ),
    );
  }
  
  Widget LogoutButton() {
    return Visibility(
      visible: !edit,
      child: ElevatedButton.icon(
        onPressed: () {
          ShowLogoutDialog();
        },
        icon: Icon(Icons.logout_outlined),
        label: Text(
          "Logout",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        )
      ),
    );
  }

  Widget EditButton() {
    return Visibility(
      visible: !edit,
      child: ElevatedButton.icon(
        onPressed: () {
          fullNameEditingController.text = name;
          emailEditingController.text = email;
          phoneNoEditingController.text = phone;
          setState(() {
            edit = !edit;
          });
        },
        icon: Icon(Icons.edit),
        label: Text(
          "Edit",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        )
      ),
    );
  }

  Widget UserInfo() {
    return Column(
      children: <Widget>[
        TextField(
          controller: fullNameEditingController,
          keyboardType: TextInputType.name,
          enabled: false,
          decoration: InputDecoration(
            labelText: "Full Name",
            border: InputBorder.none,
          ),
        ),
        SizedBox(height: 15,),
        // TextField(
        //   controller: usernameEditingController,
        //   keyboardType: TextInputType.name,
        //   enabled: false,
        //   decoration: InputDecoration(
        //     labelText: "Username",
        //     border: InputBorder.none,
        //   ),
        // ),
        SizedBox(height: 15,),
        TextField(
          controller: emailEditingController,
          keyboardType: TextInputType.emailAddress,
          enabled: false,
          decoration: InputDecoration(
            labelText: "Email",
            border: InputBorder.none,
          ),
        ),
        SizedBox(height: 15,),
        TextField(
          controller: phoneNoEditingController,
          keyboardType: TextInputType.phone,
          enabled: false,
          decoration: InputDecoration(
            labelText: "Phone No.",
            border: InputBorder.none,
          ),
        ),
        SizedBox(height: 15,),
        // TextField(
        //   controller: passwordEditingController,
        //   keyboardType: TextInputType.name,
        //   readOnly: true,
        //   decoration: InputDecoration(
        //     labelText: "Password",
        //     border: InputBorder.none,
        //     suffixIcon: IconButton(
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => ChangePassword(),
        //           ),
        //         );
        //       },
        //       icon: Icon(Icons.edit),
        //     )
        //   ),
        // ),
      ],
    );
  }

  Widget EditUserInfo() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: fullNameEditingController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: "Full Name",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(80.0),
              ),
            ),
            validator: (value) {
              if(value!.isEmpty) {
                return "Cannot be empty";
              }
              return null;
            },
          ),
          SizedBox(height: 25,),
          TextFormField(
            readOnly: true,
            controller: emailEditingController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
            ),
            // validator: (value) {
            //   if(value!.isEmpty) {
            //     return "Cannot be empty";
            //   }
            //   if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
            //       .hasMatch(value)) {
            //     return ("Please Enter a valid email");
            //   }
            //   return null;
            // },
          ),
          SizedBox(height: 25,),
          TextFormField(
            controller: phoneNoEditingController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Phone No.",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
            ),
            validator: (value) {
              if(value!.isEmpty) {
                return "Cannot be empty";
              }
              return null;
            },
          ),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    edit = !edit;
                  });
                },
                child: Text("Cancel"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
              SizedBox(width: 25,),
              ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()) {
                    Update();
                    setState(() {
                      edit = !edit;
                    });
                  }
                },
                child: Text("Save"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future PickImage() async{
    ImagePicker picker = ImagePicker();
    try{
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if(image == null) {
        return;
      }else{
        setState(() {
          uploadImage = File(image.path);
        });
        print('imageFile: $uploadImage');
      }
    }on PlatformException catch(e){
      print(e.stacktrace);
    }
  }
  
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

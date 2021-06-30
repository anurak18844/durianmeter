import 'package:durianmeter/Models/authUser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'loginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthUser auth = AuthUser();
  final _formkey = GlobalKey<FormState>();
  var agree = false;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Container(
            child: Scaffold(
                body: Container(
                  //height: double.infinity,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 50.0, left: 8.0, right: 8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.accessible_forward_outlined,
                          size: 100.0,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'REGISTER',
                          style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                        Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30.0,
                                ),
                                TextFormField(
                                  validator: MultiValidator([
                                    EmailValidator(
                                        errorText: 'Enter a valid email address'),
                                    RequiredValidator(
                                        errorText: 'Enter your E-Mail please!')
                                  ]),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter your username',
                                    hintText: 'Enter Your username',
                                    icon: Icon(
                                      Icons.account_box_outlined,
                                      size: 50.0,
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (String? email) {
                                    auth.email = email;
                                  },
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                TextFormField(
                                  controller: _pass,
                                  validator: RequiredValidator(errorText: 'Enter your password.'),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter your password',
                                    hintText: 'Enter Your password',
                                    icon: Icon(
                                      Icons.lock_outline,
                                      size: 50.0,
                                    ),
                                  ),
                                  onSaved: (String? password) {
                                    auth.password = password;
                                  },
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                TextFormField(
                                  controller: _confirmPass,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Enter yout password confirm please!';
                                    } else if (_pass.text != _confirmPass.text) {
                                      return 'Password does not math!';
                                    } else {
                                      return null;
                                    }
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter your confirm password',
                                    hintText: 'Enter Your confirm password',
                                    icon: Icon(
                                      Icons.lock_outline,
                                      size: 50.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  height: 50.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(agree
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank),
                                            onPressed: () {
                                              setState(() {
                                                if (agree) {
                                                  agree = false;
                                                } else {
                                                  agree = true;
                                                }
                                              });
                                            },
                                          ),
                                          Text('Accept the agreements.  '),
                                          SizedBox(
                                            height: 20.0,
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                child: Text(
                                                  'Learn More.',
                                                  style: TextStyle(
                                                      decoration:
                                                      TextDecoration.underline),
                                                ),
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                            return RegisterScreen();
                                                          }));
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50.0,
                                  child: ElevatedButton(
                                    child: Text(
                                      'REGISTER',
                                      style: TextStyle(
                                          fontSize: 18.0, fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      if (_formkey.currentState!.validate()) {
                                        if (agree == false) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Accept the agreements!.'),
                                          ));
                                        } else {
                                          _formkey.currentState!.save();
                                          try {
                                            await FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                                email: auth.email.toString(),
                                                password: auth.password.toString())
                                                .then((value) {
                                              Fluttertoast.showToast(
                                                msg: 'REGISTER SUCCESS.!',
                                                gravity: ToastGravity.CENTER,
                                              );
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(builder: (context) {
                                                    return LoginScreen();
                                                  }));
                                            });
                                          } on FirebaseAuthException catch (e) {
                                            print(e.message);
                                            Fluttertoast.showToast(
                                              msg: e.message.toString(),
                                              gravity: ToastGravity.CENTER,
                                            );
                                          }
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('Please check correctness.'),
                                        ));
                                      }
                                    },
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                )));
      }
      else if(snapshot.hasError){
        return Scaffold(
          body: Text('${snapshot.error}'),
        );
      }
      else {
        print('No Data');
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}

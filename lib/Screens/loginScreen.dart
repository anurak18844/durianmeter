import 'package:durianmeter/Screens/homeScreen.dart';
import 'package:durianmeter/Screens/registerScreen.dart';
import 'package:durianmeter/Utils/globalVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Network/restApi.dart';
import '../Models/authUser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'audioPredict.dart';
import '../Network/auth_service.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // GoogleSignInAccount? _currentUser;
  final _formkey = GlobalKey<FormState>();
  var remember = false;
  AuthUser user = AuthUser();
  bool isCallInProgress = false;
  final TextEditingController _user = TextEditingController();
  final TextEditingController _token = TextEditingController();
  @override
  void initState() {
    super.initState();
    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
    //   setState(() {
    //     _currentUser = account;
    //   });
    // });
    // _googleSignIn.signInSilently();
  }

  Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
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
                      'SIGN IN',
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
                              validator: RequiredValidator(
                                    errorText: 'Enter your username please!'),

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
                              onSaved: (String? username) {
                                user.username = username;
                              },
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            TextFormField(
                              validator: RequiredValidator(
                                  errorText: 'Enter your password please!'),
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
                                user.password = password;
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              height: 20.0,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  child: Text(
                                    'Register Account.',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) => RegisterScreen()));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              height: 50.0,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(remember
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank),
                                        onPressed: () {
                                          setState(() {
                                            if (remember) {
                                              remember = false;
                                            } else {
                                              remember = true;
                                            }
                                          });
                                        },
                                      ),
                                      Text('Remember Me.'),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 150.0,
                                    height: 50.0,
                                    child: ElevatedButton(
                                      child: Text(
                                        'LOGIN',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () async {
                                        if (_formkey.currentState!.validate()) {
                                          _formkey.currentState!.save();
                                          setState(() {
                                            this.isCallInProgress = true;
                                          });
                                          CallApi().loginCustomer(user.username, user.password).then(
                                              (response) async {
                                                setState(() {
                                                  this.isCallInProgress = false;
                                                });
                                                print(response?.token);
                                                if(response!.token != ''){
                                                  Fluttertoast.showToast(
                                                    msg: 'LOGIN SUCCESS!!!!',
                                                    gravity: ToastGravity.CENTER,
                                                  );
                                                  userToken = response.token;
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                                                }
                                              }
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Please check correctness !.'),
                                          ));
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                        height: 20.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                                  child: Divider(
                                    color: Colors.black,
                                    height: 36,
                                  ),
                                )),
                            Text(' OR SIGN WITH '),
                            Expanded(
                                child: Container(
                                  child: Divider(
                                    color: Colors.black,
                                    height: 36,
                                  ),
                                )),
                          ],
                        )),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('Login With Facebook');
                            _googleSignIn.disconnect();
                            //print('${_currentUser}');
                          },
                          child: Container(
                              height: 60.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 6.0,
                                  )
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://facebookbrand.com/wp-content/uploads/2019/04/f_logo_RGB-Hex-Blue_512.png?w=512&h=512"),
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            _handleSignIn();
                            print('Login With Google');
                            //print('${_currentUser}');
                            //push
                          },
                          child: Container(
                              height: 60.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 6.0,
                                  )
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://www.pikpng.com/pngl/b/44-442110_jpg-black-and-white-library-google-logo-png.png"),
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
    // return FutureBuilder(
    //     future: firebase,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         return Scaffold(
    //             body: Container(
    //           //height: double.infinity,
    //           width: double.infinity,
    //           padding: EdgeInsets.only(top: 50.0, left: 8.0, right: 8.0),
    //           child: SingleChildScrollView(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Icon(
    //                   Icons.accessible_forward_outlined,
    //                   size: 100.0,
    //                 ),
    //                 SizedBox(
    //                   height: 8.0,
    //                 ),
    //                 Text(
    //                   'SIGN IN',
    //                   style: TextStyle(
    //                       fontSize: 40.0,
    //                       color: Colors.green,
    //                       fontWeight: FontWeight.bold),
    //                 ),
    //                 Form(
    //                     key: _formkey,
    //                     child: Column(
    //                       children: [
    //                         SizedBox(
    //                           height: 30.0,
    //                         ),
    //                         TextFormField(
    //                           validator: MultiValidator([
    //                             EmailValidator(
    //                                 errorText: 'Enter a valid email address'),
    //                             RequiredValidator(
    //                                 errorText: 'Enter your E-Mail please!')
    //                           ]),
    //                           decoration: InputDecoration(
    //                             border: OutlineInputBorder(),
    //                             labelText: 'Enter your email',
    //                             hintText: 'Enter Your email',
    //                             icon: Icon(
    //                               Icons.account_box_outlined,
    //                               size: 50.0,
    //                             ),
    //                           ),
    //                           keyboardType: TextInputType.emailAddress,
    //                           onSaved: (String? email) {
    //                             auth.email = email;
    //                           },
    //                         ),
    //                         SizedBox(
    //                           height: 30.0,
    //                         ),
    //                         TextFormField(
    //                           validator: RequiredValidator(
    //                               errorText: 'Enter your password please!'),
    //                           obscureText: true,
    //                           decoration: InputDecoration(
    //                             border: OutlineInputBorder(),
    //                             labelText: 'Enter your password',
    //                             hintText: 'Enter Your password',
    //                             icon: Icon(
    //                               Icons.lock_outline,
    //                               size: 50.0,
    //                             ),
    //                           ),
    //                           onSaved: (String? password) {
    //                             auth.password = password;
    //                           },
    //                         ),
    //                         SizedBox(
    //                           height: 10.0,
    //                         ),
    //                         SizedBox(
    //                           height: 20.0,
    //                           child: Container(
    //                             alignment: Alignment.centerRight,
    //                             child: InkWell(
    //                               child: Text(
    //                                 'Register Account.',
    //                                 style: TextStyle(
    //                                     decoration: TextDecoration.underline),
    //                               ),
    //                               onTap: () {
    //                                 Navigator.pushReplacement(context,
    //                                     MaterialPageRoute(builder: (context) {
    //                                   return RegisterScreen();
    //                                 }));
    //                               },
    //                             ),
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 20.0,
    //                         ),
    //                         Container(
    //                           height: 50.0,
    //                           child: Row(
    //                             mainAxisAlignment:
    //                                 MainAxisAlignment.spaceBetween,
    //                             children: [
    //                               Row(
    //                                 children: [
    //                                   IconButton(
    //                                     icon: Icon(remember
    //                                         ? Icons.check_box
    //                                         : Icons.check_box_outline_blank),
    //                                     onPressed: () {
    //                                       setState(() {
    //                                         if (remember) {
    //                                           remember = false;
    //                                         } else {
    //                                           remember = true;
    //                                         }
    //                                       });
    //                                     },
    //                                   ),
    //                                   Text('Remember Me.'),
    //                                 ],
    //                               ),
    //                               SizedBox(
    //                                 width: 150.0,
    //                                 height: 50.0,
    //                                 child: ElevatedButton(
    //                                   child: Text(
    //                                     'LOGIN',
    //                                     style: TextStyle(
    //                                         fontSize: 18.0,
    //                                         fontWeight: FontWeight.bold),
    //                                   ),
    //                                   onPressed: () async {
    //                                     if (_formkey.currentState!.validate()) {
    //                                       _formkey.currentState!.save();
    //                                       try {
    //                                         await FirebaseAuth.instance
    //                                             .signInWithEmailAndPassword(
    //                                                 email:
    //                                                     auth.email.toString(),
    //                                                 password: auth.password
    //                                                     .toString())
    //                                             .then((value) {
    //                                           Fluttertoast.showToast(
    //                                             msg: 'LOGIN SUCESS.!',
    //                                             gravity: ToastGravity.CENTER,
    //                                           );
    //                                           Navigator.pushReplacement(context,
    //                                               MaterialPageRoute(
    //                                                   builder: (context) {
    //                                             return HomePage();
    //                                           }));
    //                                         });
    //                                       } on FirebaseAuthException catch (e) {
    //                                         print(e.message);
    //                                         Fluttertoast.showToast(
    //                                           msg: e.message.toString(),
    //                                           gravity: ToastGravity.CENTER,
    //                                         );
    //                                       }
    //                                     } else {
    //                                       ScaffoldMessenger.of(context)
    //                                           .showSnackBar(SnackBar(
    //                                         content: Text(
    //                                             'Please check correctness !.'),
    //                                       ));
    //                                     }
    //                                   },
    //                                 ),
    //                               )
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     )),
    //                 SizedBox(
    //                   height: 20.0,
    //                 ),
    //                 SizedBox(
    //                     height: 20.0,
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Expanded(
    //                             child: Container(
    //                           child: Divider(
    //                             color: Colors.black,
    //                             height: 36,
    //                           ),
    //                         )),
    //                         Text(' OR SIGN WITH '),
    //                         Expanded(
    //                             child: Container(
    //                           child: Divider(
    //                             color: Colors.black,
    //                             height: 36,
    //                           ),
    //                         )),
    //                       ],
    //                     )),
    //                 SizedBox(
    //                   height: 30.0,
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   children: [
    //                     GestureDetector(
    //                       onTap: () {
    //                         print('Login With Facebook');
    //                         _googleSignIn.disconnect();
    //                         print('${_currentUser}');
    //                       },
    //                       child: Container(
    //                           height: 60.0,
    //                           width: 60.0,
    //                           decoration: BoxDecoration(
    //                             shape: BoxShape.circle,
    //                             color: Colors.white,
    //                             boxShadow: [
    //                               BoxShadow(
    //                                 color: Colors.black26,
    //                                 offset: Offset(0, 2),
    //                                 blurRadius: 6.0,
    //                               )
    //                             ],
    //                             image: DecorationImage(
    //                               image: NetworkImage(
    //                                   "https://facebookbrand.com/wp-content/uploads/2019/04/f_logo_RGB-Hex-Blue_512.png?w=512&h=512"),
    //                             ),
    //                           )),
    //                     ),
    //                     GestureDetector(
    //                       onTap: () {
    //                         _handleSignIn();
    //                         print('Login With Google');
    //                         print('${_currentUser}');
    //                         //push
    //                       },
    //                       child: Container(
    //                           height: 60.0,
    //                           width: 60.0,
    //                           decoration: BoxDecoration(
    //                             shape: BoxShape.circle,
    //                             color: Colors.white,
    //                             boxShadow: [
    //                               BoxShadow(
    //                                 color: Colors.black26,
    //                                 offset: Offset(0, 2),
    //                                 blurRadius: 6.0,
    //                               )
    //                             ],
    //                             image: DecorationImage(
    //                               image: NetworkImage(
    //                                   "https://www.pikpng.com/pngl/b/44-442110_jpg-black-and-white-library-google-logo-png.png"),
    //                             ),
    //                           )),
    //                     ),
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ),
    //         ));
    //       } else if (snapshot.hasError) {
    //         return Scaffold(
    //           body: Text('${snapshot.error}'),
    //         );
    //       } else {
    //         print('No Data');
    //         return Scaffold(
    //           body: Center(
    //             child: CircularProgressIndicator(),
    //           ),
    //         );
    //       }
    //     });
  }
}

Future<void> _handleSignIn() async {
  try {
    final authService = AuthService();
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final result = await authService.signInWithCrediential(credential);
    print("Access Token" + googleAuth.accessToken.toString());
    print("ID Token" + googleAuth.idToken.toString());
  } catch (error) {
    print(error);
  }
}

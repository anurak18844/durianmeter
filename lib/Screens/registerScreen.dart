import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../Models/authUser.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthUser user = AuthUser();
  var _hiddenPassword = true;
  var _hiddenPassword2 = true;
  var _chkTextBox = false;
  String? chkPassword;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _passWord = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).copyWith().size.width;
    double height = MediaQuery.of(context).copyWith().size.height;

    return Scaffold(
      //-----------------------APP BAR---------------------------------------
      appBar: AppBar(
        title: GradientText(
          'REGISTER',
          style: TextStyle(
            fontSize: 24,
          ),
          colors: [
            Colors.blue.shade900,
            Colors.blue.shade900,
            Colors.green.shade400,
            Colors.green.shade400,
          ],
          gradientType: GradientType.linear,
        ),
        backgroundColor: Colors.white,
        //-----------------------ICON ARROW---------------------------------------
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 50),
        width: width,
        height: height,
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //-----------------------E-MAIL---------------------------------------
                  _buildTextFieldEmail(
                      TextInputType.emailAddress, "EMAIL", "example@gmail.com"),
                  //-----------------------FULL NAME---------------------------------------
                  _buildTextFieldFullName(
                      TextInputType.emailAddress, "FULL NAME", "Name Lastname"),
                  //-----------------------TELEPHONE NUMBER---------------------------------------
                  _buildTextFieldTelePhone(
                      TextInputType.phone, "TELEPHONE NUMBER", "0812345678"),
                  //-----------------------PASSWORD---------------------------------------
                  _buildPasswordField("PASSWORD", "12345678"),
                  //-----------------------CONFIRM PASSWORD---------------------------------------
                  _buildPasswordField2("CONFIRM PASSWORD", "12345678"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //-----------------------ACCEPT AGREEMENT---------------------------------------
                      IconButton(
                        icon: Icon(_chkTextBox
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                        onPressed: () {
                          _setStateChkBox();
                        },
                      ),
                      Text(
                        "Accept Agreement ",
                        style: TextStyle(fontSize: 12),
                      ),
                      InkWell(
                          child: new Text(
                            'Learn more.',
                            style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            print("READ AGREEMENT.");
                          }),
                    ],
                  ),
                  //-----------------------BUTTON REGISTER---------------------------------------
                  Container(
                    padding: EdgeInsets.only(
                        top: 30, left: 10, right: 10, bottom: 10),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          print(user.username);
                          print(user.password);
                          print(user.firstname);
                          print(user.tel);
                          _formKey.currentState!.reset();
                          _passWord.text = '';
                          _confirmPass.text = '';
                        }
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF66BB6A),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                              minWidth: double.infinity,
                              minHeight:
                                  60.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'REGISTER',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildTextFieldEmail(
      TextInputType textInputType, String labelText, String hintText) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: textInputType,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
        ),
        validator: MultiValidator([
          RequiredValidator(errorText: 'Enter a some text'),
          EmailValidator(errorText: 'Enter a valid email address')
        ]),
        onSaved: (String? username) {
          user.username = username;
        },
      ),
    );
  }

  Widget _buildTextFieldFullName(
      TextInputType textInputType, String labelText, String hintText) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: textInputType,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
        ),
        validator: RequiredValidator(errorText: 'Enter a some text'),
        onSaved: (String? fullName) {
          user.firstname = fullName;
        },
      ),
    );
  }

  Widget _buildTextFieldTelePhone(
      TextInputType textInputType, String labelText, String hintText) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: textInputType,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
        ),
        validator: MultiValidator([
          RequiredValidator(errorText: 'Enter a some text'),
          MinLengthValidator(10,
              errorText: 'Telephone must be at least 10 digits long'),
          MaxLengthValidator(10,
              errorText: 'Telephone must be at More 10 digits long'),
        ]),
        onSaved: (String? telePhone) {
          user.tel = telePhone;
        },
      ),
    );
  }

  Widget _buildPasswordField(String labelText, String hintText) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: _passWord,
        obscureText: _hiddenPassword,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: _togglePasswordView,
            child:
                Icon(_hiddenPassword ? Icons.visibility_off : Icons.visibility),
          ),
          border: UnderlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
        ),
        validator: MultiValidator([
          RequiredValidator(errorText: 'Enter a some text'),
          MinLengthValidator(8,
              errorText: 'Password must be at least 8 digits long'),
        ]),
        onChanged: (val) => chkPassword = val,
        onSaved: (String? password) {
          user.password = password;
        },
      ),
    );
  }

  Widget _buildPasswordField2(String labelText, String hintText) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: _confirmPass,
        obscureText: _hiddenPassword2,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: _togglePasswordView2,
            child: Icon(
                _hiddenPassword2 ? Icons.visibility_off : Icons.visibility),
          ),
          border: UnderlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
        ),
        validator: (val) {
          if (val!.isEmpty || val == null) {
            return 'Enter a some text';
          } else if (_passWord.text != _confirmPass.text) {
            return 'Password does not math';
          } else {
            return null;
          }
        },
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _hiddenPassword = !_hiddenPassword;
    });
    print(_hiddenPassword);
  }

  void _togglePasswordView2() {
    setState(() {
      _hiddenPassword2 = !_hiddenPassword2;
    });
    print(_hiddenPassword2);
  }

  void _setStateChkBox() {
    setState(() {
      _chkTextBox = !_chkTextBox;
    });
  }
}

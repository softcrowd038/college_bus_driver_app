import 'package:flutter/material.dart';
import 'package:location_tracking_user/data/api_data.dart';
import 'package:location_tracking_user/login_and_registration/Model/user_.dart';
import 'package:location_tracking_user/login_and_registration/Services/api_service.dart';
import 'package:location_tracking_user/login_and_registration/Widgets/common_textform_field.dart';
import 'package:location_tracking_user/login_and_registration/Widgets/custom_button_.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _busIdController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _busIdController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _busIdController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  LoginApiService apiService = LoginApiService();

  Future<void> loginStudent(String busID, String password) async {
    try {
      await apiService.loginStudent(context, busID, password);
    } catch (e) {
      throw Exception('Error $e');
    }
  }

  void _updateBusId(String value) {
    Provider.of<UserCredentials>(context, listen: false).setBusId(value);
  }

  void _updatePassword(String value) {
    Provider.of<UserCredentials>(context, listen: false).setPassword(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Consumer<UserCredentials>(
          builder: (context, userCredentials, child) => Form(
            key: _formKey,
            child: Center(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: const Image(
                          image: NetworkImage(
                              'https://img.freepik.com/free-vector/double-decker-bus-concept-illustration_114360-11580.jpg'),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * 0.015),
                          child: Text(
                            "SIGNIN",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFF735C)),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * 0.015,
                              right:
                                  MediaQuery.of(context).size.height * 0.015),
                          child: Text(
                            "Login And Unlock Your  Access!",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.015,
                          right: MediaQuery.of(context).size.height * 0.015,
                          bottom: MediaQuery.of(context).size.height * 0.010,
                        ),
                        child: CommonTextFormfield(
                          onChanged: (value) {
                            _updateBusId(value);
                          },
                          label: "bus ID",
                          hint: "25",
                          obscure: false,
                          controller: _busIdController,
                          suffixIcon: const Icon(
                            Icons.bus_alert,
                            color: Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the Bus ID first!";
                            }
                            if (!regexemail.hasMatch(value)) {
                              return "Enter Valid  Bus ID  Format!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.015,
                          right: MediaQuery.of(context).size.height * 0.015,
                          bottom: MediaQuery.of(context).size.height * 0.015,
                        ),
                        child: CommonTextFormfield(
                          onChanged: (value) {
                            _updatePassword(value);
                          },
                          label: "Password",
                          hint: "MNop1234@#",
                          obscure: true,
                          controller: _passwordController,
                          suffixIcon: const Icon(
                            Icons.key,
                            color: Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the Password first!";
                            }
                            // if (value.length < 8) {
                            //   return "Password is too short, Enter up to 8 digits!";
                            // }
                            // if (!regexpassword.hasMatch(value)) {
                            //   return "Use Alphabets(capital and small), symbols and numbers in the password";
                            // }
                            return null;
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            loginStudent(_busIdController.text,
                                _passwordController.text);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * 0.015),
                          child: const CustomButton(
                            buttonText: "SignIn",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

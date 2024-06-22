import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobizapp/confg/appconfig.dart';

import '../Components/commonwidgets.dart';
import '../Models/LoginModelClass.dart';
import '../Utilities/rest_ds.dart';
import '../Utilities/sharepref.dart';
import '../confg/sizeconfig.dart';
import '../Models/appstate.dart';
import '../Pages/homepage.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: const Color(0xffFFFBFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.screenHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: SizeConfig.blockSizeVertical * 45,
                    decoration: BoxDecoration(
                      color: AppConfig.colorPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(0),
                        topRight: const Radius.circular(0),
                        bottomLeft: const Radius.circular(0),
                        bottomRight: Radius.elliptical(
                          MediaQuery.of(context).size.width,
                          160.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: SizeConfig.blockSizeVertical * 13,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        'Mobiz',
                        style: TextStyle(
                            fontSize: AppConfig.headLineSize * 2,
                            color: AppConfig.backgroundColor,
                            fontWeight: AppConfig.headLineWeight),
                      ),
                    ),
                  ),
                  Positioned(
                    top: SizeConfig.blockSizeVertical * 18,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        'Sales',
                        style: TextStyle(
                          fontSize: AppConfig.headLineSize * 1.5,
                          color: AppConfig.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: SizeConfig.blockSizeVertical * 30,
                    left: SizeConfig.blockSizeHorizontal * 10,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      elevation: 3,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        width: SizeConfig.blockSizeHorizontal * 80,
                        height: SizeConfig.blockSizeVertical * 50,
                        decoration: const BoxDecoration(
                            color: AppConfig.backgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonWidgets.verticalSpace(2),
                            Text(
                              'Log In',
                              style: TextStyle(
                                  fontSize: AppConfig.headLineSize * 1.2,
                                  fontWeight: AppConfig.headLineWeight),
                            ),
                            const Text('Please sign in with your details'),
                            const SizedBox(height: 20),
                            TextField(
                                controller: _username,
                                decoration: InputDecoration(
                                  labelText: "Username",
                                  labelStyle: const TextStyle(
                                      color: AppConfig.colorPrimary),
                                  prefixIcon: const Icon(Icons.person),
                                  border: myinputborder(),
                                  enabledBorder: myinputborder(),
                                  focusedBorder: myfocusborder(),
                                )),
                            const SizedBox(height: 20),
                            TextField(
                                controller: _password,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock),
                                  labelText: "Password",
                                  labelStyle: const TextStyle(
                                      color: AppConfig.colorPrimary),
                                  enabledBorder: myinputborder(),
                                  focusedBorder: myfocusborder(),
                                )),
                            CommonWidgets.verticalSpace(5),
                            Center(
                              child: CommonWidgets.button(
                                  bgColor: AppConfig.colorPrimary,
                                  textColor: AppConfig.backgroundColor,
                                  function: () {
                                    if (_username.text.isEmpty) {
                                      CommonWidgets.showDialogueBox(
                                          context: context,
                                          title: 'Error',
                                          msg: "Please enter valid useraname ");
                                    } else if (_password.text.isEmpty) {
                                      CommonWidgets.showDialogueBox(
                                          context: context,
                                          title: 'Error',
                                          msg: "Please enter valid password");
                                    } else {
                                      _login();
                                      // Navigator.pushNamed(
                                      //     context, HomeScreen.routeName);
                                    }
                                  },
                                  height: SizeConfig.blockSizeVertical * 7,
                                  width: SizeConfig.blockSizeHorizontal * 67,
                                  radius: 10,
                                  title: 'Log In'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return const OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 3,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: AppConfig.colorPrimary,
          width: 3,
        ));
  }

  Future<void> _login() async {
    AppState appState = AppState();
    RestDatasource api = RestDatasource();
    Map<String, String> bodyJson = {
      "email": _username.text,
      "password": _password.text
    };
    try {
      dynamic resJson = await api.sendData(
        '/api/login',
        null,
        jsonEncode(bodyJson),
      );

      LoginModel loginResp = LoginModel.fromJson(resJson);
      debugPrint('Logoin Resp $resJson ${loginResp.user!.storeId}');
      if (loginResp.status == "success") {
        if (loginResp.user != null && loginResp.authorisation != null) {
          appState.token = loginResp.authorisation!.token;
          appState.storeId = loginResp.user!.storeId;
          appState.routeId = loginResp.user!.rolId;
          appState.name = loginResp.user!.name;
          appState.userId = loginResp.user!.id;
          appState.email = loginResp.user!.email;
          appState.loginState = 'LOGGED_IN';

          //Clear the shared preference if it is already present
          bool appStateRetrieved = await sharedPref.containsKey('app_state');
          if (appStateRetrieved == true) {
            sharedPref.removeAll();
          }

          /// Save it saved preference
          sharedPref.save("app_state", appState);
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          }
        } else {
          if (mounted) {
            CommonWidgets.showDialogueBox(
                context: context, title: "Error", msg: "Something went wrong");
          }
        }
      } else {
        if (mounted) {
          CommonWidgets.showDialogueBox(
              context: context, title: "Error", msg: "Invalid Email/Password");
        }
      }
    } catch (e) {
      if (mounted) {
        CommonWidgets.showDialogueBox(
            context: context, title: "Error", msg: "Invalid Email/Password");
      }
    }
  }
}

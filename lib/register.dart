import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yieldapp/login.dart';
import 'package:yieldapp/misc.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final paswordController = TextEditingController();
  bool obsecurepassword = true;
  late String token = '';
  late List<String> allCountries = [
    'Kenya',
    'Uganda',
    'Somalia'
        'USA',
    'Pakistani',
    'Eritrea'
  ];
  String? selectedCountry;
  bool showSpinner = false;

  Future registerUser() async {
    var apiurl = "https://yieldsapp.azurewebsites.net/api/auth/register";

    Map mapRegisterDetails = {
      "fullName": fullNameController.text.trim(),
      "email": emailController.text.trim(),
      "userName": userNameController.text.trim(),
      "countryId": selectedCountry,
      "password": paswordController.text.trim(),
    };

    http.Response response = await http.post(Uri.parse(apiurl),
        body: jsonEncode(mapRegisterDetails),
        headers: {
          "Content-Type": "application/json",
        });

    if (response.body.isNotEmpty) {
      var data = json.decode(response.body);

      if (data['message'] == 'The username or password is invalid.') {
        return '';
      }

      if (data.toString().contains('went wrong')) {
        return '';
      }

      if (data['token']['accessToken'] != null) {
        return data['token']['accessToken'];
      }
    } else {
      return token;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: SvgPicture.asset('assets/leaf.svg',
                      color: Colors.green, height: 10, fit: BoxFit.fitHeight),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Yields App',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          const Center(
            child: Text(
              'Register',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(fontWeight: FontWeight.w500),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    filled: true,
                    hintText: 'Full Names',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                controller: fullNameController,
              ),
            ),
          ),
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(fontWeight: FontWeight.w500),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    filled: true,
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                controller: emailController,
              ),
            ),
          ),
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(fontWeight: FontWeight.w500),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    filled: true,
                    hintText: 'Username',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                controller: userNameController,
              ),
            ),
          ),
          SizedBox(
              width: 400,
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      border: Border.all(
                          color: const Color(0xFFD9D9D9), width: 0.5),
                      borderRadius: BorderRadius.circular(20)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      dropdownElevation: 0,
                      focusColor: Colors.transparent,
                      isExpanded: true,
                      hint: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Country',
                              style: TextStyle(
                                fontFamily: 'AvenirNext',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: allCountries
                          .map((itemd) => DropdownMenuItem<String>(
                                value: itemd,
                                child: Text(
                                  itemd,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedCountry,
                      onChanged: (valued) {
                        setState(() {
                          selectedCountry = valued as String;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_downward,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.black54,
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 40,
                      buttonWidth: 160,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      buttonElevation: 2,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 200,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(-20, 0),
                    ),
                  ),
                ),
              )),
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                style: const TextStyle(fontWeight: FontWeight.w500),
                keyboardType: TextInputType.name,
                obscureText: obsecurepassword,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    filled: true,
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                controller: paswordController,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (fullNameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  userNameController.text.isEmpty ||
                  paswordController.text.isEmpty ||
                  selectedCountry == null) {
                Fluttertoast.showToast(
                    msg: "Complete the form",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (Misc.validateEmail(emailController.text) != null) {
                Fluttertoast.showToast(
                    msg: "Email provided is not valid",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                setState(() {
                  showSpinner = true;
                });
                await registerUser();
                setState(() {
                  showSpinner = false;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                width: 400,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: showSpinner == false
                      ? const Text(
                          'Register',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        )
                      : const SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignIn()),
              );
            },
            child: const Center(
              child: Text(
                'Login',
                style: TextStyle(
                    color: Colors.green,
                    fontFamily: 'AvenirNext',
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }
}

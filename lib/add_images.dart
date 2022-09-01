// ignore_for_file: unnecessary_new

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddImages extends StatefulWidget {
  const AddImages({Key? key, this.scoutingid, required this.token})
      : super(key: key);
  final num? scoutingid;
  final String? token;
  @override
  State<AddImages> createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  bool showSpinner = false;
  String? selectedCrop;
  final List<String> allCrops = [
    'Tomatoes',
    'Corn',
    'Carrot',
  ];

  List<dynamic> selectedPhotos = List<dynamic>.filled(5, null);
  final picker = ImagePicker();

  Future getImageFromGallery(picNumber) async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    var tempImage = File(pickedImage!.path);
    if (picNumber == 0) {
      setState(() {
        selectedPhotos[0] = tempImage;
      });
    }
    if (picNumber == 1) {
      setState(() {
        selectedPhotos[1] = tempImage;
      });
    }
    if (picNumber == 2) {
      setState(() {
        selectedPhotos[2] = tempImage;
      });
    }

    if (picNumber == 3) {
      setState(() {
        selectedPhotos[3] = tempImage;
      });
    }

    if (picNumber == 4) {
      setState(() {
        selectedPhotos[4] = tempImage;
      });
    }
  }

  Future uploadPhotos() async {
//One image picked
    if (selectedPhotos[0] != null && selectedPhotos[1] == null) {
      var dio = Dio();

      var filed = await MultipartFile.fromFile(selectedPhotos[0].path);

      List imaged = [];

      imaged.add(filed);

      FormData formData = FormData.fromMap(
          {"scoutingId": widget.scoutingid, "scoutingPhotos": imaged});

      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer ${widget.token}";

      Response response = await dio.post(
          "https://yieldsapp.azurewebsites.net/api/scouting/upload-photos",
          data: formData);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }

    //Two images picked
    if (selectedPhotos[1] != null && selectedPhotos[2] == null) {
      var dio = Dio();

      var filed = await MultipartFile.fromFile(selectedPhotos[0].path);
      var filed2 = await MultipartFile.fromFile(selectedPhotos[1].path);

      List imaged = [];

      imaged.add(filed);
      imaged.add(filed2);

      FormData formData = FormData.fromMap(
          {"scoutingId": widget.scoutingid, "scoutingPhotos": imaged});

      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer ${widget.token}";

      Response response = await dio.post(
          "https://yieldsapp.azurewebsites.net/api/scouting/upload-photos",
          data: formData);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }

    //Three images picked
    if (selectedPhotos[2] != null && selectedPhotos[3] == null) {
      var dio = Dio();

      var filed = await MultipartFile.fromFile(selectedPhotos[0].path);
      var filed2 = await MultipartFile.fromFile(selectedPhotos[1].path);
      var filed3 = await MultipartFile.fromFile(selectedPhotos[2].path);

      List imaged = [];

      imaged.add(filed);
      imaged.add(filed2);
      imaged.add(filed3);

      FormData formData = FormData.fromMap(
          {"scoutingId": widget.scoutingid, "scoutingPhotos": imaged});

      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer ${widget.token}";

      Response response = await dio.post(
          "https://yieldsapp.azurewebsites.net/api/scouting/upload-photos",
          data: formData);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }

    //Four images picked
    if (selectedPhotos[3] != null && selectedPhotos[4] == null) {
      var dio = Dio();

      var filed = await MultipartFile.fromFile(selectedPhotos[0].path);
      var filed2 = await MultipartFile.fromFile(selectedPhotos[1].path);
      var filed3 = await MultipartFile.fromFile(selectedPhotos[2].path);
      var filed4 = await MultipartFile.fromFile(selectedPhotos[3].path);

      List imaged = [];

      imaged.add(filed);
      imaged.add(filed2);
      imaged.add(filed3);
      imaged.add(filed4);

      FormData formData = FormData.fromMap(
          {"scoutingId": widget.scoutingid, "scoutingPhotos": imaged});

      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer ${widget.token}";

      Response response = await dio.post(
          "https://yieldsapp.azurewebsites.net/api/scouting/upload-photos",
          data: formData);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }

    //if five images have been picked
    if (selectedPhotos[4] != null) {
      var dio = Dio();

      var filed = await MultipartFile.fromFile(selectedPhotos[0].path);
      var filed2 = await MultipartFile.fromFile(selectedPhotos[1].path);
      var filed3 = await MultipartFile.fromFile(selectedPhotos[2].path);
      var filed4 = await MultipartFile.fromFile(selectedPhotos[3].path);
      var filed5 = await MultipartFile.fromFile(selectedPhotos[3].path);

      List imaged = [];

      imaged.add(filed);
      imaged.add(filed2);
      imaged.add(filed3);
      imaged.add(filed4);
      imaged.add(filed5);

      FormData formData = FormData.fromMap(
          {"scoutingId": widget.scoutingid, "scoutingPhotos": imaged});

      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer ${widget.token}";

      Response response = await dio.post(
          "https://yieldsapp.azurewebsites.net/api/scouting/upload-photos",
          data: formData);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.black,
            height: 50,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Image.asset('assets/logo.jpeg')),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'yieldsApp',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      if (selectedPhotos.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Pick atleast one photo",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        setState(() {
                          showSpinner = true;
                        });

                        var response = await uploadPhotos();

                        if (response == true) {
                          Fluttertoast.showToast(
                              msg: "Images uploaded",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          Fluttertoast.showToast(
                              msg: "There was an issue uploading images",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: showSpinner == false
                          ? const Center(
                              child: Text(
                                'Proceed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              ),
                            ),
                    ),
                  ),
                )),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 50,
          ),
          Row(
            children: const [
              SizedBox(
                width: 10,
              ),
              Text(
                'Upload photos of the infested crops ( 5max photos )',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: selectedPhotos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    key: Key('pic$index'),
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey[300]),
                        margin: const EdgeInsets.only(right: 10),
                        width: 250,
                        height: 200,
                        child: selectedPhotos[index] == null
                            ? TextButton(
                                onPressed: () {
                                  getImageFromGallery(index);
                                },
                                child: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.green,
                                  size: 30,
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  getImageFromGallery(index);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.file(
                                    selectedPhotos[index],
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Photo ${index + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.black54),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          // Row(
          //   children: const [
          //     SizedBox(
          //       width: 10,
          //     ),
          //     Text(
          //       'I have detected leasions on leaf. I have a few questions to ask ',
          //       style: TextStyle(
          //           fontWeight: FontWeight.w600,
          //           fontSize: 12,
          //           color: Colors.black54),
          //     ),
          //   ],
          // ),
          const SizedBox(
            height: 40,
          ),
          // Row(
          //   children: [
          //     const SizedBox(
          //       width: 10,
          //     ),
          //     const Text(
          //       'Do you see target like lessions on the leaf? ',
          //       style: TextStyle(
          //           fontWeight: FontWeight.w600,
          //           fontSize: 12,
          //           color: Colors.black54),
          //     ),
          //     Container(
          //       width: 40,
          //       height: 20,
          //       decoration: const BoxDecoration(
          //         color: Colors.blue,
          //         borderRadius: BorderRadius.all(Radius.circular(5)),
          //       ),
          //       child: const Center(
          //         child: Text(
          //           'Yes',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 10,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(
          //       width: 10,
          //     ),
          //     Container(
          //       width: 40,
          //       height: 20,
          //       decoration: const BoxDecoration(
          //         color: Colors.red,
          //         borderRadius: BorderRadius.all(Radius.circular(5)),
          //       ),
          //       child: const Center(
          //         child: Text(
          //           'No',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 10,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    ));
  }
}

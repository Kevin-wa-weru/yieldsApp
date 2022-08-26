import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:yieldapp/add_images.dart';
import 'package:yieldapp/models/farms.dart';
import 'package:http/http.dart' as http;

class AddRecord extends StatefulWidget {
  const AddRecord({Key? key, required this.field, required this.token})
      : super(key: key);

  final Field field;
  final String token;
  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  bool showSpinner = false;
  bool findingIssueIsLoading = false;
  int maxLines = 5;
  final commentController = TextEditingController();
  final percentageController = TextEditingController();
  DateTime? selectedDate;
  String? selectedSection;
  String? selectedIssue;
  String? selectedFinding;
  int? selectedFindingID;
  String? severity;
  String? selectedCrop;
  num? selectedCropID;
  Section? sectionSelected;
  num? scoutingID;

  String resolveSeverity(severity) {
    if (severity == 'None') {
      return '1';
    }
    if (severity == 'Low') {
      return '2';
    }
    if (severity == 'Medium') {
      return '3';
    }
    if (severity == 'High') {
      return '4';
    }
    if (severity == 'Very High') {
      return '5';
    }

    return '';
  }

  num resolveIssue(issue) {
    if (issue == 'Pest') {
      return 0;
    }
    if (issue == 'Diseases') {
      return 1;
    }
    if (issue == 'Treatment') {
      return 2;
    }
    if (issue == 'Improvement') {
      return 3;
    } else {
      return 0;
    }
  }

  Future addRecord() async {
    var apiurl =
        "https://yieldsapp.azurewebsites.net/api/Scouting/add-scouting";

    Map mapScoutingDetails = {
      "id": 0,
      "scoutingDate": DateFormat('yyyy-MM-dd').format(selectedDate!).toString(),
      "fieldId": widget.field.id,
      "comments": commentController.text.isEmpty ? "" : commentController.text,
      "scoutingPhotos": [],
      "scoutingSections": [
        {"sectionId": sectionSelected!.id}
      ],
      "scoutingIssues": [
        {"scoutingIssueType": resolveIssue(selectedIssue)}
      ],
      "scoutingFindings": [
        {
          "value": selectedFindingID,
          "label": "$selectedFinding",
          "pestId": selectedFindingID,
          "severityType": resolveSeverity(severity),
          "infestation": percentageController.text
        }
      ],
      "scoutingFindingDevelopmentStages": [
        {"developmentStageId": 9, "pestId": selectedFindingID}
      ]
    };

    http.Response response = await http.post(Uri.parse(apiurl),
        body: jsonEncode(mapScoutingDetails),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        });

    if (response.body.isNotEmpty) {
      var data = json.decode(response.body);
      print(data);

      //success
      if (data.toString().contains('comments')) {
        setState(() {
          scoutingID = data['id'];
        });
        return true;
      }

      //Failure
      if (data.toString().contains('Something went wrong')) {
        return false;
      }
    } else {}
  }

  Future getPestsOrDiseasesOfCrop(issueid, cropid) async {
    //First get the crop id using its crop name

    setState(() {
      allFindings = [];
    });

    try {
      http.Response response = await http.get(Uri.parse(
              // ignore: unnecessary_brace_in_string_interps
              'https://yieldsapp.azurewebsites.net/api/Pest/get-pest-names-by-type?pestType=${issueid}&cropId=$cropid'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${widget.token}",
          });

      if (response.body.isNotEmpty) {
        var data = json.decode(response.body);

        if (data.toString().contains('name')) {
          for (var finding in data) {
            setState(() {
              allFindings.add({
                'id': finding['id'],
                'name': finding['name'],
              });
            });
          }
        }
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final List<String> allSections = [];

  final List<String> allIssues = [
    'Pest',
    'Diseases',
    // 'Treatment',
    // 'Improvement',
  ];

  late List<dynamic> allFindings = [];

  final List<String> allSeverities = [
    'None',
    'Low',
    'Medium',
    'High',
    'Very High'
  ];

  getCropGrownInThatSection() {
    //First get the name of section
    String section = selectedSection!.split(
      'Section ',
    )[1];

    List<Section> sections = widget.field.sections!;

    List<Section> selectedSections = sections
        .where(
          (element) => element.name == section,
        )
        .toList();

    setState(() {
      selectedCrop = selectedSections.first.crop!.name;
      selectedCropID = selectedSections.first.crop!.id;
    });

    //second set selectedselection
    sectionSelected = selectedSections[0];
  }

  bool checkBoxValue = false;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2025),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.green,
              ),
            ),
            child: child!,
          );
        });

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    List<Section> sections = widget.field.sections!;

    for (var section in sections) {
      allSections.add('Section ${section.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
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
                      // SvgPicture.asset('assets/leaf.svg',
                      //     color: Colors.green,
                      //     height: 10,
                      //     fit: BoxFit.fitHeight),
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
                        //Verify each component has been selected.

                        if (percentageController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Enter Percentage",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        if (selectedFinding == null) {
                          Fluttertoast.showToast(
                              msg: "Select Findings",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        if (severity == null) {
                          Fluttertoast.showToast(
                              msg: "Select Severity level",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        if (selectedCrop == null) {
                          Fluttertoast.showToast(
                              msg: "Select Crop",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        if (selectedIssue == null) {
                          Fluttertoast.showToast(
                              msg: "Select Issue Type",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        if (selectedSection == null) {
                          Fluttertoast.showToast(
                              msg: "Select Section",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        if (selectedDate == null) {
                          Fluttertoast.showToast(
                              msg: "Pick a date",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        if (selectedDate != null &&
                            selectedSection != null &&
                            selectedCrop != null &&
                            selectedCrop != null &&
                            selectedIssue != null &&
                            selectedFinding != null &&
                            severity != null &&
                            percentageController.text.isNotEmpty &&
                            commentController.text.isNotEmpty) {
                          setState(() {
                            showSpinner = true;
                          });
                          // ignore: unused_local_variable
                          var response = await addRecord();

                          setState(() {
                            showSpinner = false;
                          });

                          if (response = true) {
                            Fluttertoast.showToast(
                                msg: "Successfully added The record",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddImages(
                                        scoutingid: scoutingID,
                                        token: widget.token,
                                      )),
                            );
                          }

                          if (response = false) {
                            Fluttertoast.showToast(
                                msg: "There was an issue adding record",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
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
                                  'Save',
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
              height: 10,
            ),
            SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width - 20,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    const Text(
                      'New Scouting',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: Colors.black54),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      widget.field.name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: Colors.black54),
                    ),
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: const [
                SizedBox(width: 30),
                Text(
                  'Date',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                selectDate(context);
              },
              child: Row(
                children: [
                  const SizedBox(width: 30),
                  Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border(
                            left: BorderSide(width: 2.0, color: Colors.green),
                            right: BorderSide(width: 2.0, color: Colors.green),
                            top: BorderSide(width: 2.0, color: Colors.green),
                            bottom: BorderSide(width: 2.0, color: Colors.green),
                          ),
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                selectedDate == null
                                    ? ''
                                    : DateFormat('dd/MM/yyyy')
                                        .format(selectedDate!)
                                        .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: Colors.green,
                                    size: 25,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                SizedBox(width: 30),
                Text(
                  'Section',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border(
                        left: BorderSide(width: 2.0, color: Colors.green),
                        right: BorderSide(width: 2.0, color: Colors.green),
                        top: BorderSide(width: 2.0, color: Colors.green),
                        bottom: BorderSide(width: 2.0, color: Colors.green),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        dropdownElevation: 0,
                        focusColor: Colors.transparent,
                        isExpanded: true,
                        hint: Row(
                          children: const [
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                'Select',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: allSections
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: selectedSection,
                        onChanged: (value) {
                          setState(() {
                            selectedSection = value as String;
                          });

                          getCropGrownInThatSection();
                        },
                        icon: const Icon(
                          Icons.arrow_downward,
                        ),
                        iconSize: 20,
                        iconEnabledColor: Colors.green,
                        iconDisabledColor: Colors.grey,
                        buttonHeight: 40,
                        buttonWidth: 160,
                        buttonPadding:
                            const EdgeInsets.only(left: 14, right: 14),
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
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 6,
                        scrollbarAlwaysShow: true,
                        offset: const Offset(-20, 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                SizedBox(width: 30),
                Text(
                  'Crop',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border(
                        left: BorderSide(width: 2.0, color: Colors.green),
                        right: BorderSide(width: 2.0, color: Colors.green),
                        top: BorderSide(width: 2.0, color: Colors.green),
                        bottom: BorderSide(width: 2.0, color: Colors.green),
                      ),
                    ),
                    child: selectedCrop == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 15),
                            child: Text(
                              selectedCrop!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.green),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                SizedBox(width: 30),
                Text(
                  'Issue Type',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border(
                        left: BorderSide(width: 2.0, color: Colors.green),
                        right: BorderSide(width: 2.0, color: Colors.green),
                        top: BorderSide(width: 2.0, color: Colors.green),
                        bottom: BorderSide(width: 2.0, color: Colors.green),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        dropdownElevation: 0,
                        focusColor: Colors.transparent,
                        isExpanded: true,
                        hint: Row(
                          children: const [
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                'Select',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: allIssues
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: selectedIssue,
                        onChanged: (value) async {
                          if (selectedSection == null) {
                            Fluttertoast.showToast(
                                msg: "Pick a Section First",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }

                          if (sectionSelected != null) {
                            setState(() {
                              selectedIssue = value as String;
                              findingIssueIsLoading = true;
                            });

                            await getPestsOrDiseasesOfCrop(
                                resolveIssue(selectedIssue), selectedCropID);

                            setState(() {
                              findingIssueIsLoading = false;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_downward,
                        ),
                        iconSize: 20,
                        iconEnabledColor: Colors.green,
                        iconDisabledColor: Colors.grey,
                        buttonHeight: 40,
                        buttonWidth: 160,
                        buttonPadding:
                            const EdgeInsets.only(left: 14, right: 14),
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
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 6,
                        scrollbarAlwaysShow: true,
                        offset: const Offset(-20, 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                SizedBox(width: 30),
                Text(
                  'Findings',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border(
                        left: BorderSide(width: 2.0, color: Colors.green),
                        right: BorderSide(width: 2.0, color: Colors.green),
                        top: BorderSide(width: 2.0, color: Colors.green),
                        bottom: BorderSide(width: 2.0, color: Colors.green),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        dropdownElevation: 0,
                        focusColor: Colors.transparent,
                        isExpanded: true,
                        hint: Row(
                          children: const [
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                'Select',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: allFindings
                            .map((item) => DropdownMenuItem<String>(
                                  value: item['name'],
                                  child: Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: selectedFinding,
                        onChanged: (value) {
                          setState(() {
                            selectedFinding = value as String;

                            List<dynamic> specificFinding = allFindings
                                .where((element) =>
                                    element['name'] == selectedFinding)
                                .toList();

                            selectedFindingID = specificFinding[0]['id'];
                          });
                        },
                        icon: findingIssueIsLoading == true
                            ? const Center(
                                child: SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                    strokeWidth: 2.0,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.arrow_downward,
                              ),
                        iconSize: 20,
                        iconEnabledColor: Colors.green,
                        iconDisabledColor: Colors.grey,
                        buttonHeight: 40,
                        buttonWidth: 160,
                        buttonPadding:
                            const EdgeInsets.only(left: 14, right: 14),
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
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 6,
                        scrollbarAlwaysShow: true,
                        offset: const Offset(-20, 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                SizedBox(width: 30),
                Text(
                  'Severity',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border(
                        left: BorderSide(width: 2.0, color: Colors.green),
                        right: BorderSide(width: 2.0, color: Colors.green),
                        top: BorderSide(width: 2.0, color: Colors.green),
                        bottom: BorderSide(width: 2.0, color: Colors.green),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        dropdownElevation: 0,
                        focusColor: Colors.transparent,
                        isExpanded: true,
                        hint: Row(
                          children: const [
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                'Select',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: allSeverities
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: severity,
                        onChanged: (value) {
                          setState(() {
                            severity = value as String;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_downward,
                        ),
                        iconSize: 20,
                        iconEnabledColor: Colors.green,
                        iconDisabledColor: Colors.grey,
                        buttonHeight: 40,
                        buttonWidth: 160,
                        buttonPadding:
                            const EdgeInsets.only(left: 14, right: 14),
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
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 6,
                        scrollbarAlwaysShow: true,
                        offset: const Offset(-20, 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                SizedBox(width: 30),
                Text(
                  '% Area affected ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border(
                        left: BorderSide(width: 2.0, color: Colors.green),
                        right: BorderSide(width: 2.0, color: Colors.green),
                        top: BorderSide(width: 2.0, color: Colors.green),
                        bottom: BorderSide(width: 2.0, color: Colors.green),
                      ),
                    ),
                    child: TextFormField(
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: percentageController,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                SizedBox(width: 30),
                Text(
                  'Comment',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                SizedBox(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width / 1.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 35.0, right: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            border: Border(
                              left: BorderSide(width: 2.0, color: Colors.green),
                              right:
                                  BorderSide(width: 2.0, color: Colors.green),
                              top: BorderSide(width: 2.0, color: Colors.green),
                              bottom:
                                  BorderSide(width: 2.0, color: Colors.green),
                            ),
                          ),
                          child: SizedBox(
                            height: maxLines * 24.0,
                            child: TextFormField(
                              maxLines: maxLines,
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  fillColor: Colors.transparent,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent, width: 0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  filled: true,
                                  hintStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  )),
                              onChanged: (value) {
                                setState(() {});
                              },
                              controller: commentController,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 35,
                ),
                Text(
                  'Photos',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 35,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddImages(
                                token: widget.token,
                              )),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset('assets/photo.svg',
                          color: Colors.green,
                          height: 10,
                          fit: BoxFit.fitHeight),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

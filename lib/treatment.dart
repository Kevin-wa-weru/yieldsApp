import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TreatmentExpandavle extends StatefulWidget {
  const TreatmentExpandavle({Key? key, required this.alltratements, this.token})
      : super(key: key);
  final List<dynamic> alltratements;
  final String? token;
  @override
  State<TreatmentExpandavle> createState() => _TreatmentExpandavleState();
}

class _TreatmentExpandavleState extends State<TreatmentExpandavle> {
  Future changeStatusofTreatment(bool value, treatmentID) async {
    resolveStatus(bool value) {
      if (value == false) {
        return 0;
      } else {
        return 1;
      }
    }

    print(resolveStatus(value));

    print(treatmentID);
    print('WEEEEEEEEEEEEEEEEEEE');
    print(widget.token);
    Map mapdetails = {"id": 1403, "status": resolveStatus(value)};

    try {
      http.Response response = await http.post(
          Uri.parse(
              'https://yieldsapp.azurewebsites.net/api/Treatments/change-status'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${widget.token}",
          },
          body: json.encode(mapdetails));

      print('RRRRRREEEEEEEEE');
      print(jsonDecode(response.body));

      if (response.body.isNotEmpty) {
        var data = jsonDecode(response.body);
        debugPrint(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Text('Applied',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  )),
            )
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Column(
            children: widget.alltratements
                .map((treatment) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset('assets/edit.svg',
                                    color: Colors.green,
                                    height: 10,
                                    fit: BoxFit.fitHeight),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            SizedBox(
                              // color: Colors.red,
                              width: 80,
                              child: Text(
                                '${DateFormat("MMM").format(DateTime.parse(treatment['applicationDate']))} ${DateTime.parse(treatment['applicationDate']).day} ${DateTime.parse(treatment['applicationDate']).year}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            SizedBox(
                              width: 100,
                              // color: Colors.blue,
                              child: Text(treatment['product'],
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  )),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text('${treatment['applicationRate']}L/ha',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                )),
                            const SizedBox(
                              width: 2,
                            ),
                            Transform.scale(
                              scale: 0.6,
                              child: CupertinoSwitch(
                                activeColor: Colors.green,
                                trackColor: Colors.grey,
                                value: treatment['status'] == 0 ? false : true,
                                onChanged: (value) async {
                                  //first update ui before sending to server
                                  if (value == true) {
                                    setState(() {
                                      treatment['status'] = 1;
                                    });
                                  }

                                  if (value == false) {
                                    setState(() {
                                      treatment['status'] = 0;
                                    });
                                  }

                                  await changeStatusofTreatment(
                                      value, treatment['id']);
                                },
                              ),
                            ),
                          ],
                        ),
                        const Divider()
                      ],
                    ))
                .toList())
      ],
    ));
  }
}

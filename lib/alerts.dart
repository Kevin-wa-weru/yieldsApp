import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AlertExpandavle extends StatefulWidget {
  const AlertExpandavle({Key? key, required this.allalerts}) : super(key: key);
  final List<dynamic> allalerts;

  @override
  State<AlertExpandavle> createState() => _AlertExpandavleState();
}

class _AlertExpandavleState extends State<AlertExpandavle> {
  void _modalBottomSheetMenu(message, date) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            color: Colors.transparent,
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Message',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          date,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      children: [
        Column(
            children: widget.allalerts
                .map((alert) => InkWell(
                      onTap: () {
                        _modalBottomSheetMenu(alert['message'],
                            '${DateFormat("MMM").format(DateTime.parse(alert['date']))} ${DateTime.parse(alert['date']).day} ${DateTime.parse(alert['date']).year}');
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                // color: Colors.red,
                                width: 80,
                                child: Text(
                                  '${DateFormat("MMM").format(DateTime.parse(alert['date']))} ${DateTime.parse(alert['date']).day} ${DateTime.parse(alert['date']).year}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                width: 160,
                                child: Text(
                                  alert['message'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // setState(() {
                                  //   allAlerts.remove(Alerts(
                                  //       date: treatment.date,
                                  //       alertDescription:
                                  //           treatment.alertDescription));
                                  // });
                                },
                                child: Container(
                                  color: Colors.white,
                                  width: 50,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      height: 10,
                                      width: 10,
                                      child: SvgPicture.asset(
                                          'assets/cancel.svg',
                                          color: Colors.black54,
                                          height: 10,
                                          fit: BoxFit.fitHeight),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider()
                        ],
                      ),
                    ))
                .toList()),
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScoutingExpandavle extends StatefulWidget {
  const ScoutingExpandavle({Key? key, required this.scoutHistory})
      : super(key: key);
  final List<dynamic> scoutHistory;
  @override
  State<ScoutingExpandavle> createState() => _ScoutingExpandavleState();
}

class _ScoutingExpandavleState extends State<ScoutingExpandavle> {
  List<dynamic> allScoutings = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      children: [
        Column(
            children: widget.scoutHistory
                .map((scoutings) => Column(
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 120,
                              // color: Colors.yellow,
                              child: Text(
                                '${DateFormat("MMM").format(DateTime.parse(scoutings['scoutingDate']))} ${DateTime.parse(scoutings['scoutingDate']).day} ${DateTime.parse(scoutings['scoutingDate']).year}',
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              width: 120,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  scoutings['scoutingFindings'].isEmpty
                                      ? 'No finding recorder'
                                      : scoutings['scoutingFindings'][0]['pest']
                                          ['parentPest']['name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              // width: 100,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${scoutings['scoutingSections'][0]['section']['name']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider()
                      ],
                    ))
                .toList())
      ],
    ));
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yieldapp/add_record.dart';
import 'package:yieldapp/alerts.dart';
import 'package:yieldapp/models.dart';
import 'package:yieldapp/models/farms.dart';
import 'package:yieldapp/scouting.dart';
import 'package:yieldapp/treatment.dart';
import 'package:http/http.dart' as http;

class SingleField extends StatefulWidget {
  const SingleField(
      {Key? key,
      required this.position,
      required this.fieldName,
      this.polygon,
      required this.field,
      required this.token,
      required this.shape,
      this.circle,
      required this.currentLocation})
      : super(key: key);
  final LatLng position;
  final String fieldName;
  final Polygon? polygon;
  final Set<Circle>? circle;
  final Field field;
  final String token;
  final String shape;
  final LatLng currentLocation;

  @override
  // ignore: library_private_types_in_public_api
  _SingleFieldState createState() => _SingleFieldState();
}

class _SingleFieldState extends State<SingleField> {
  late GoogleMapController controller;
  List<Marker> allMarkers = [];
  late PageController pageController;
  late int prevPage = 0;
  late LatLng selectedLocation = const LatLng(0, 0);
  // late List<Notifications> allalerts = [];
  List<ExpandableWidget> expansionItems = [];
  List<dynamic> scoutHistoryData = [];
  List<dynamic> treatmentsData = [];
  List<dynamic> alertsData = [];
  // Set<Circle> _circles = HashSet<Circle>();

  handleTap(LatLng tappedPoint) {
    setState(() {
      selectedLocation = tappedPoint;
      allMarkers = [];
      allMarkers.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true,
          onDragEnd: (dragEndPosition) {}));
    });
  }

  //get all alerts
  Future getAlerts() async {
    http.Response response = await http.get(
        Uri.parse(
            'https://yieldsapp.azurewebsites.net/api/Farm/get-field-notifications/${widget.field.id}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        });

    var data = jsonDecode(response.body);

    if (response.body.isNotEmpty) {
      final oneWeekBeforeAlerts = data.where((e) {
        final mapDate = DateTime.tryParse(e['date']);

        const duration = Duration(days: 7);
        final oneWeekBefore = DateTime.now().subtract(duration);

        return mapDate?.isBefore(oneWeekBefore) ?? false;
      }).toList();

      setState(() {
        alertsData = oneWeekBeforeAlerts;
      });

      await getScoutingHistory();

      return;
    }
    return;
  }

  Future getScoutingHistory() async {
    Map mapdetails = {
      "pagination": {"page": 1, "sizePerPage": 10},
      "sorting": {"sortField": "id", "sortOrder": "asc"},
      "filters": [
        {"key": "FieldId", "value": widget.field.id}
      ]
    };

    http.Response response = await http.post(
        Uri.parse(
            'https://yieldsapp.azurewebsites.net/api/Scouting/load-scouting'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
        body: json.encode(mapdetails));

    if (response.body.isNotEmpty) {
      var data = jsonDecode(response.body);

      setState(() {
        scoutHistoryData = data['data'];
      });

      await getTreatments();
    }
  }

  Future getTreatments() async {
    Map mapdetails = {
      "pagination": {"page": 1, "sizePerPage": 10},
      "sorting": {"sortField": "id", "sortOrder": "asc"},
      "filters": [
        {"key": "FieldId", "value": widget.field.id}
      ]
    };

    http.Response response = await http.post(
        Uri.parse(
            'https://yieldsapp.azurewebsites.net/api/Treatments/load-treatments'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
        body: json.encode(mapdetails));
    print('Rffffffffffffffff');
    print(widget.token);
    print(widget.field.id);
    print(jsonDecode(response.body));

    if (response.body.isNotEmpty) {
      var data = jsonDecode(response.body);

      setState(() {
        treatmentsData = data['data'];
      });

      setState(() {
        expansionItems.add(
          ExpandableWidget(
              title: 'Treatments',
              alertCount: '${treatmentsData.length}',
              expandedContent: treatmentsData.isEmpty
                  ? const Center(
                      child: Text(
                        'No treatments availble',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    )
                  : TreatmentExpandavle(
                      alltratements: treatmentsData,
                    ),
              svgUrl: 'assets/kit.svg',
              isExpanded: false),
        );
      });

      setState(() {
        expansionItems.add(
          ExpandableWidget(
              title: 'Alerts',
              alertCount: '${alertsData.length}',
              expandedContent: alertsData.isEmpty
                  ? const Center(
                      child: Text(
                        'No Alerts availble',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    )
                  : AlertExpandavle(allalerts: alertsData),
              svgUrl: 'assets/alert2.svg',
              isExpanded: false),
        );
      });

      setState(() {
        expansionItems.add(
          ExpandableWidget(
              title: 'Scouting history',
              alertCount: '',
              expandedContent: scoutHistoryData.isEmpty
                  ? const Center(
                      child: Text(
                        'No Scoutings availble',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    )
                  : ScoutingExpandavle(
                      scoutHistory: scoutHistoryData,
                    ),
              svgUrl: 'assets/eye.svg',
              isExpanded: false),
        );
      });
    }
  }

  // filterAlertByTwoWeeks() {

  // int month = DataTime.now.

  // }

  Future removeThrottle() async {
    if (expansionItems.length == 3) {
      return alertsData;
    } else {}
  }

  @override
  void initState() {
    super.initState();
    //First get the Alerts

    getAlerts();

    allMarkers.add(Marker(
      markerId: MarkerId(widget.fieldName),
      draggable: false,
      infoWindow:
          InfoWindow(title: widget.fieldName, snippet: widget.fieldName),
      position: widget.position,
    ));

    allMarkers.add(Marker(
        markerId: const MarkerId('Current Location'),
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
            title: 'Current Location', snippet: 'Current Location'),
        position: widget.currentLocation));
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
                    // SvgPicture.asset('assets/leaf.svg',
                    //     color: Colors.green, height: 10, fit: BoxFit.fitHeight),
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
                )
              ],
            ),
          ),
          widget.shape == 'Polygon'
              ? Expanded(
                  child: SizedBox(
                    // height: height,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      polygons: {
                        widget.polygon!,
                      },
                      mapType: MapType.hybrid,
                      initialCameraPosition:
                          CameraPosition(target: widget.position, zoom: 14.0),
                      markers: Set.from(allMarkers),
                      onMapCreated: mapCreated,
                      onTap: handleTap,
                    ),
                  ),
                )
              : Expanded(
                  child: SizedBox(
                    // height: height,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      circles: widget.circle!,
                      mapType: MapType.hybrid,
                      initialCameraPosition:
                          CameraPosition(target: widget.position, zoom: 14.0),
                      markers: Set.from(allMarkers),
                      onMapCreated: mapCreated,
                      onTap: handleTap,
                    ),
                  ),
                ),
          FutureBuilder(
            future: removeThrottle(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        color: Colors.white,
                        height: 250.0,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            // color: Colors.blue,
                            // margin: const EdgeInsets.symmetric(
                            //   vertical: 20.0,
                            //   horizontal: 8,
                            // ),
                            padding: const EdgeInsets.only(left: 5.0),
                            height: 300.0,
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              child: ExpansionPanelList(
                                elevation: 3,
                                expansionCallback: (index, isExpanded) {
                                  setState(() {
                                    expansionItems[index].isExpanded =
                                        !isExpanded;
                                  });
                                },
                                animationDuration:
                                    const Duration(milliseconds: 600),
                                children: expansionItems
                                    .map(
                                      (item) => ExpansionPanel(
                                        canTapOnHeader: true,
                                        backgroundColor: item.isExpanded == true
                                            ? Colors.white
                                            : Colors.white,
                                        headerBuilder: (_, isExpanded) =>
                                            Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 20),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: SvgPicture.asset(
                                                          item.svgUrl,
                                                          color: Colors.green,
                                                          height: 10,
                                                          fit:
                                                              BoxFit.fitHeight),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      item.title,
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    item.alertCount == ''
                                                        ? Container()
                                                        : Text(
                                                            ' (${item.alertCount})',
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                  ],
                                                )),
                                        body: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: item.expandedContent,
                                        ),
                                        isExpanded: item.isExpanded!,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ))));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const SizedBox(
                  height: 250.0,
                  child: Center(child: CircularProgressIndicator()));
            },
          ),
          InkWell(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddRecord(
                              field: widget.field,
                              token: widget.token,
                            )),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  height: 40,
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Add Scouting Record',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  void mapCreated(controller) {
    setState(() {
      controller = controller;
    });
  }
}

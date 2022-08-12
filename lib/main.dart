import 'dart:convert';
import 'dart:math';
import 'dart:collection';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yieldapp/login.dart';
import 'package:yieldapp/models/farms.dart';
import 'package:yieldapp/single_field.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Maps Demo',
      home: SignIn(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.token, required this.userLocation})
      : super(key: key);
  final String? token;
  final LatLng? userLocation;

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController _controller;
  List<Marker> allMarkers = [];
  late PageController _pageController;
  late int prevPage = 0;
  Set<Polygon> allPolygons = {};
  // ignore: prefer_final_fields
  Set<Circle> _circles = HashSet<Circle>();
  String? selectedFarm;
  String? selectedField;

  late List<String> allUserFarmsNames = [];

  late List<String> allFieldNamesOfThatFarm = [];

  late List<Farm> allfarms = [];
  late List<Farm> farmSelected = [];
  late List<Field> fieldsOfFarmSelected = [];

  // LatLng? initialField;
  bool switchedToFarms = false;

  Future fetchAllUserFarms(token) async {
    try {
      http.Response response = await http.get(
          Uri.parse('https://yieldsapp.azurewebsites.net/api/Farm/get-farms'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          });
      var data = jsonDecode(response.body);

      if (response.body.isNotEmpty) {
        for (var userfarms in data) {
          allfarms.add(Farm.fromJson(userfarms));
        }

        for (var farmNames in allfarms) {
          setState(() {
            allUserFarmsNames.add(farmNames.name!);
          });
        }
      } else {}
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  getFieldsForThatFarm() async {
    setState(() {
      allFieldNamesOfThatFarm = [];
      selectedField = null;
    });

    late List<String> fieldNames = [];
    List<Farm> farm =
        allfarms.where((element) => element.name == selectedFarm).toList();
    var response = farm[0].fields;

    farmSelected = farm;

    for (var field in farm) {
      fieldsOfFarmSelected = field.fields!;
    }

    for (var field in response!) {
      fieldNames.add(field.name!);
    }

    setState(() {
      allFieldNamesOfThatFarm = fieldNames;
    });

    //get figures and add them according to index on list and figure type
    List<dynamic> jsonFigures = [];

    for (var jsonfigures in fieldsOfFarmSelected) {
      jsonFigures.add(jsonDecode(jsonfigures.jsonFigure!));
    }

    List<LatLng> resolveNumberOfSide(figure, length) {
      if (length == 3) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
        ];
      }
      if (length == 4) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
        ];
      }
      if (length == 5) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
        ];
      }
      if (length == 6) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
          LatLng(figure['figure']['coordinates'][5]['lat'],
              figure['figure']['coordinates'][5]['lng']),
        ];
      }
      if (length == 7) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
          LatLng(figure['figure']['coordinates'][5]['lat'],
              figure['figure']['coordinates'][5]['lng']),
          LatLng(figure['figure']['coordinates'][6]['lat'],
              figure['figure']['coordinates'][6]['lng']),
        ];
      }

      if (length == 8) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
          LatLng(figure['figure']['coordinates'][5]['lat'],
              figure['figure']['coordinates'][5]['lng']),
          LatLng(figure['figure']['coordinates'][6]['lat'],
              figure['figure']['coordinates'][6]['lng']),
          LatLng(figure['figure']['coordinates'][7]['lat'],
              figure['figure']['coordinates'][7]['lng']),
        ];
      }
      if (length == 9) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
          LatLng(figure['figure']['coordinates'][5]['lat'],
              figure['figure']['coordinates'][5]['lng']),
          LatLng(figure['figure']['coordinates'][6]['lat'],
              figure['figure']['coordinates'][6]['lng']),
          LatLng(figure['figure']['coordinates'][7]['lat'],
              figure['figure']['coordinates'][7]['lng']),
          LatLng(figure['figure']['coordinates'][6]['lat'],
              figure['figure']['coordinates'][6]['lng']),
        ];
      }
      if (length == 10) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
          LatLng(figure['figure']['coordinates'][5]['lat'],
              figure['figure']['coordinates'][5]['lng']),
          LatLng(figure['figure']['coordinates'][6]['lat'],
              figure['figure']['coordinates'][6]['lng']),
          LatLng(figure['figure']['coordinates'][7]['lat'],
              figure['figure']['coordinates'][7]['lng']),
          LatLng(figure['figure']['coordinates'][8]['lat'],
              figure['figure']['coordinates'][8]['lng']),
          LatLng(figure['figure']['coordinates'][9]['lat'],
              figure['figure']['coordinates'][9]['lng']),
        ];
      }
      if (length == 11) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
          LatLng(figure['figure']['coordinates'][5]['lat'],
              figure['figure']['coordinates'][5]['lng']),
          LatLng(figure['figure']['coordinates'][6]['lat'],
              figure['figure']['coordinates'][6]['lng']),
          LatLng(figure['figure']['coordinates'][7]['lat'],
              figure['figure']['coordinates'][7]['lng']),
          LatLng(figure['figure']['coordinates'][8]['lat'],
              figure['figure']['coordinates'][8]['lng']),
          LatLng(figure['figure']['coordinates'][9]['lat'],
              figure['figure']['coordinates'][9]['lng']),
          LatLng(figure['figure']['coordinates'][10]['lat'],
              figure['figure']['coordinates'][10]['lng']),
        ];
      }

      return [
        LatLng(double.parse(figure['figure']['coordinates'][0]['lat']),
            double.parse(figure['figure']['coordinates'][0]['lng'])),
      ];
    }

    for (var figure in jsonFigures) {
      if (figure['type'] == 'Polygon') {
        setState(() {
          allPolygons.add(
            Polygon(
                strokeWidth: 5,
                //produce random colors
                // strokeColor: Colors.green,
                strokeColor:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                fillColor: Colors.transparent,
                polygonId: PolygonId(
                    figure['figure']['coordinates'][0]['lat'].toString()),
                points: resolveNumberOfSide(
                    figure, figure['figure']['coordinates'].length)),
          );
        });
      }

      if (figure['type'] == 'Circle') {
        setState(() {
          _circles.add(Circle(
            circleId: const CircleId('gg'),
            center: LatLng(figure['figure']['center']['lat'],
                figure['figure']['center']['lng']),
            radius: figure['figure']['radius'],
            fillColor: Colors.transparent,
            // strokeColor: Colors.red,
            strokeColor:
                Colors.primaries[Random().nextInt(Colors.primaries.length)],
            strokeWidth: 5,
          ));
        });
      }
    }
  }

  Future removeThrottle() async {
    if (allfarms.isEmpty) {
      return;
    }

    if (allfarms.isNotEmpty) {
      return allfarms;
    }
  }

  @override
  void initState() {
    super.initState();

    fetchAllUserFarms(widget.token!.trim());
    allMarkers.add(Marker(
        markerId: const MarkerId('Current Location'),
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
            title: 'Current Location', snippet: 'Current Location'),
        position: widget.userLocation!));

    _pageController = PageController(initialPage: 0, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      moveCamera();
    }
  }

  _farmList(index) {
    List<LatLng> resolveNumberOfSide(figure, length) {
      if (length == 3) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
        ];
      }
      if (length == 4) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
        ];
      }
      if (length == 5) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
        ];
      }
      if (length == 6) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
          LatLng(figure['figure']['coordinates'][5]['lat'],
              figure['figure']['coordinates'][5]['lng']),
        ];
      }
      if (length == 7) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
          LatLng(figure['figure']['coordinates'][5]['lat'],
              figure['figure']['coordinates'][5]['lng']),
          LatLng(figure['figure']['coordinates'][6]['lat'],
              figure['figure']['coordinates'][6]['lng']),
        ];
      }

      if (length == 8) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
          LatLng(figure['figure']['coordinates'][5]['lat'],
              figure['figure']['coordinates'][5]['lng']),
          LatLng(figure['figure']['coordinates'][6]['lat'],
              figure['figure']['coordinates'][6]['lng']),
          LatLng(figure['figure']['coordinates'][7]['lat'],
              figure['figure']['coordinates'][7]['lng']),
        ];
      }
      if (length == 9) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
          LatLng(figure['figure']['coordinates'][5]['lat'],
              figure['figure']['coordinates'][5]['lng']),
          LatLng(figure['figure']['coordinates'][6]['lat'],
              figure['figure']['coordinates'][6]['lng']),
          LatLng(figure['figure']['coordinates'][7]['lat'],
              figure['figure']['coordinates'][7]['lng']),
          LatLng(figure['figure']['coordinates'][6]['lat'],
              figure['figure']['coordinates'][6]['lng']),
        ];
      }
      if (length == 10) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
          LatLng(figure['figure']['coordinates'][5]['lat'],
              figure['figure']['coordinates'][5]['lng']),
          LatLng(figure['figure']['coordinates'][6]['lat'],
              figure['figure']['coordinates'][6]['lng']),
          LatLng(figure['figure']['coordinates'][7]['lat'],
              figure['figure']['coordinates'][7]['lng']),
          LatLng(figure['figure']['coordinates'][8]['lat'],
              figure['figure']['coordinates'][8]['lng']),
          LatLng(figure['figure']['coordinates'][9]['lat'],
              figure['figure']['coordinates'][9]['lng']),
        ];
      }
      if (length == 11) {
        return [
          LatLng(figure['figure']['coordinates'][0]['lat'],
              figure['figure']['coordinates'][0]['lng']),
          LatLng(figure['figure']['coordinates'][1]['lat'],
              figure['figure']['coordinates'][1]['lng']),
          LatLng(figure['figure']['coordinates'][2]['lat'],
              figure['figure']['coordinates'][2]['lng']),
          LatLng(figure['figure']['coordinates'][3]['lat'],
              figure['figure']['coordinates'][3]['lng']),
          LatLng(figure['figure']['coordinates'][4]['lat'],
              figure['figure']['coordinates'][4]['lng']),
          LatLng(figure['figure']['coordinates'][5]['lat'],
              figure['figure']['coordinates'][5]['lng']),
          LatLng(figure['figure']['coordinates'][6]['lat'],
              figure['figure']['coordinates'][6]['lng']),
          LatLng(figure['figure']['coordinates'][7]['lat'],
              figure['figure']['coordinates'][7]['lng']),
          LatLng(figure['figure']['coordinates'][8]['lat'],
              figure['figure']['coordinates'][8]['lng']),
          LatLng(figure['figure']['coordinates'][9]['lat'],
              figure['figure']['coordinates'][9]['lng']),
          LatLng(figure['figure']['coordinates'][10]['lat'],
              figure['figure']['coordinates'][10]['lng']),
        ];
      }

      return [
        LatLng(double.parse(figure['figure']['coordinates'][0]['lat']),
            double.parse(figure['figure']['coordinates'][0]['lng'])),
      ];
    }

    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget? widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = (_pageController.page! - index);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 145.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          child: Column(
        children: [
          Expanded(
            child: Stack(children: [
              Center(
                  child: InkWell(
                onTap: () {
                  if (jsonDecode(
                          fieldsOfFarmSelected[index].jsonFigure!)['type'] ==
                      'Polygon') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SingleField(
                        field: fieldsOfFarmSelected[index],
                        fieldName: fieldsOfFarmSelected[index].name!,
                        polygon: Polygon(
                            strokeWidth: 5,
                            strokeColor: Colors.green,
                            fillColor: Colors.transparent,
                            polygonId: PolygonId(fieldsOfFarmSelected[index]
                                .latitude!
                                .toString()),
                            points: resolveNumberOfSide(
                                jsonDecode(
                                    fieldsOfFarmSelected[index].jsonFigure!),
                                jsonDecode(fieldsOfFarmSelected[index]
                                        .jsonFigure!)['figure']['coordinates']
                                    .length)),
                        position: LatLng(
                            double.parse(fieldsOfFarmSelected[index].latitude!),
                            double.parse(
                                fieldsOfFarmSelected[index].longitude!)),
                        token: widget.token!.trim(),
                        shape: 'Polygon',
                        currentLocation: widget.userLocation!,
                      );
                    }));
                  }

                  if (jsonDecode(
                          fieldsOfFarmSelected[index].jsonFigure!)['type'] ==
                      'Circle') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SingleField(
                        circle: {
                          Circle(
                            circleId: const CircleId('gg'),
                            center: LatLng(
                                jsonDecode(fieldsOfFarmSelected[index]
                                    .jsonFigure!)['figure']['center']['lat'],
                                jsonDecode(fieldsOfFarmSelected[index]
                                    .jsonFigure!)['figure']['center']['lng']),
                            radius: jsonDecode(fieldsOfFarmSelected[index]
                                .jsonFigure!)['figure']['radius'],
                            fillColor: Colors.transparent,
                            strokeColor: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                            strokeWidth: 5,
                          ),
                        },
                        field: fieldsOfFarmSelected[index],
                        fieldName: fieldsOfFarmSelected[index].name!,
                        position: LatLng(
                            double.parse(fieldsOfFarmSelected[index].latitude!),
                            double.parse(
                                fieldsOfFarmSelected[index].longitude!)),
                        token: widget.token!.trim(),
                        shape: 'Circle',
                        currentLocation: widget.userLocation!,
                      );
                    }));
                  }
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 8,
                    ),
                    padding: const EdgeInsets.only(left: 5.0),
                    height: 165.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Row(children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: SvgPicture.asset('assets/polygon.svg',
                            color: Colors.green,
                            height: 10,
                            fit: BoxFit.fitHeight),
                      ),
                      const SizedBox(width: 5.0),
                      SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fieldsOfFarmSelected[index].name!,
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'All good',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 170.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    fieldsOfFarmSelected[index]
                                        .actualArea
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ]),
                      )
                    ])),
              ))
            ]),
          ),
        ],
      )),
    );
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      fetchAllUserFarms(widget.token!.trim());
                    },
                    child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Image.asset('assets/logo.jpeg')),
                    //  SizedBox(
                    //   height: 30,
                    //   width: 30,
                    //   child: SvgPicture.asset('assets/leaf.svg',
                    //       color: Colors.green,
                    //       height: 10,
                    //       fit: BoxFit.fitHeight),
                    // ),
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
          SizedBox(
            height: 60,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Farm',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3.2,
                  height: 30,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border(
                      left: BorderSide(width: 2.0, color: Colors.black54),
                      right: BorderSide(width: 2.0, color: Colors.black54),
                      top: BorderSide(width: 2.0, color: Colors.black54),
                      bottom: BorderSide(width: 2.0, color: Colors.black54),
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
                              'Select.',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: allUserFarmsNames
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
                      value: selectedFarm,
                      onChanged: (valued) {
                        setState(() {
                          selectedFarm = valued as String;
                        });

                        List<Farm> specificFarm = allfarms
                            .where((element) => element.name == selectedFarm)
                            .toList();

                        LatLng newlatlang = LatLng(
                            double.parse(specificFarm[0].fields![0].latitude!),
                            double.parse(
                                specificFarm[0].fields![0].longitude!));
                        _controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(target: newlatlang, zoom: 16)));

                        getFieldsForThatFarm();
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
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Fields',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3.2,
                  height: 30,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border(
                      left: BorderSide(width: 2.0, color: Colors.black54),
                      right: BorderSide(width: 2.0, color: Colors.black54),
                      top: BorderSide(width: 2.0, color: Colors.black54),
                      bottom: BorderSide(width: 2.0, color: Colors.black54),
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
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: allFieldNamesOfThatFarm
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedField,
                      onChanged: (value) {
                        setState(() {
                          selectedField = value as String;
                        });

                        //get the field where name is equal to selected value

                        List<Field> specificField = fieldsOfFarmSelected
                            .where((element) => element.name == selectedField)
                            .toList();

                        LatLng newlatlang = LatLng(
                            double.parse(specificField[0].latitude!),
                            double.parse(specificField[0].longitude!));
                        _controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(target: newlatlang, zoom: 17)
                                //17 is new zoom level
                                ));
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
              ],
            ),
          ),
          FutureBuilder(
            future: removeThrottle(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        // height: height,
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          circles: _circles,
                          polygons: allPolygons,
                          mapType: MapType.satellite,
                          initialCameraPosition: CameraPosition(
                            target: widget.userLocation!,
                            zoom: 17,
                          ),
                          markers: Set.from(allMarkers),
                          onMapCreated: mapCreated,
                        ),
                      ),
                      fieldsOfFarmSelected.isEmpty
                          ? Container()
                          : Positioned(
                              bottom: 5.0,
                              child: SizedBox(
                                height: 200.0,
                                width: MediaQuery.of(context).size.width,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: fieldsOfFarmSelected.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _farmList(index);
                                  },
                                ),
                              ),
                            )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Center(
                  child: Column(
                children: const [
                  CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'If the process takes long, you may not have farms availbale in your account',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ));
            },
          )
        ],
      )),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: fieldsOfFarmSelected[_pageController.page!.toInt()].latitude ==
                null
            ? widget.userLocation!
            : LatLng(
                double.parse(fieldsOfFarmSelected[_pageController.page!.toInt()]
                    .latitude!),
                double.parse(fieldsOfFarmSelected[_pageController.page!.toInt()]
                    .longitude!)),
        zoom: 17.0,
        bearing: 45.0,
        tilt: 45.0)));
  }
}

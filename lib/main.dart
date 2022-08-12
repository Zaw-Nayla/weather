import 'package:flutter/material.dart';
import 'package:weather_api/api.dart';
import 'package:weather_api/locationapi.dart';
import 'package:geolocator/geolocator.dart';
import 'yahoormodel.dart';
import 'package:form_field_validator/form_field_validator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController userinput = TextEditingController();
  GetwithLocation? myweather;
  GetwithLocation? myplaceweather;
  double? temperature;
  double lat = 1.352083;
  double long = 103.819836;
  String? skycondition;
  String? cityname;
  String? timezone;
  double? humidity;
  double? visibility;
  int? conditioncode;
  String? image;
  Position? myposition;
  bool submit = false;

  constract() async {
    await API().getwithCoord(lat, long).then((value) {
      setState(() {
        myplaceweather = value;
        temperature = myplaceweather!.currentObservation.condition.temperature;
        skycondition = myplaceweather!.currentObservation.condition.text;
        cityname = myplaceweather!.location.city;
        conditioncode = myplaceweather!.currentObservation.condition.code;
        humidity = myplaceweather!.currentObservation.atmosphere.humidity;
        visibility = myplaceweather!.currentObservation.atmosphere.visibility;
        imageInsert(conditioncode!);
      });
    });

    API().getwithLocation(userinput.text).then((value) {
      setState(() {
        myweather = value;
        variableInsert();
        imageInsert(conditioncode!);
      });
    });
  }

  // locationconstract() {
  //
  // }

  variableInsert() {
    setState(() {
      temperature = myweather!.currentObservation.condition.temperature;
      skycondition = myweather!.currentObservation.condition.text;
      cityname = myweather!.location.city;
      conditioncode = myweather!.currentObservation.condition.code;
      humidity = myweather!.currentObservation.atmosphere.humidity;
      visibility = myweather!.currentObservation.atmosphere.visibility;
    });
  }

  stateClear() {
    setState(() {
      temperature = null;
      skycondition = null;
      cityname = null;
      conditioncode = null;
      humidity = null;
      visibility = null;
    });
  }

  imageInsert(int conditioncode) {
    setState(() {
      if (conditioncode == 4 ||
          37 <= conditioncode && conditioncode <= 39 ||
          conditioncode == 47) {
        image = 'thunder cloud';
      } else if (0 <= conditioncode && conditioncode <= 3) {
        image = 'tornado';
      } else if (conditioncode == 24) {
        image = 'windy';
      } else if (5 <= conditioncode && conditioncode <= 8) {
        image = 'snow';
      } else if (9 <= conditioncode && conditioncode <= 14 ||
          conditioncode == 40) {
        image = 'rainy';
      } else if (15 <= conditioncode && conditioncode <= 23 ||
          conditioncode == 26) {
        image = 'cloudy';
      } else if (25 <= conditioncode && conditioncode <= 36 ||
          conditioncode == 44) {
        image = 'sunny';
      } else if (41 <= conditioncode && conditioncode <= 46) {
        image = 'rainy';
      } else {
        skycondition = 'not avaliable';
      }
    });
  }

  @override
  void initState() {
    constract();
    // imageInsert(conditioncode!);
    userinput.addListener(() {
      setState(() {
        submit = userinput.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              ElevatedButton.icon(
                  icon: const Icon(
                    Icons.location_on_outlined,
                    size: 20,
                  ),
                  onPressed: () async {
                    stateClear();
                    myposition = await determinePosition();
                    setState(() {
                      lat = myposition!.latitude;
                      long = myposition!.longitude;
                      temperature = myplaceweather!
                          .currentObservation.condition.temperature;
                      skycondition =
                          myplaceweather!.currentObservation.condition.text;
                      cityname = myplaceweather!.location.city;
                      conditioncode =
                          myplaceweather!.currentObservation.condition.code;
                      humidity = myplaceweather!
                          .currentObservation.atmosphere.humidity;
                      visibility = myplaceweather!
                          .currentObservation.atmosphere.visibility;
                      imageInsert(conditioncode!);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  label: const Text(''))
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  // padding: const EdgeInsets.bo(15),
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: userinput,
                    onFieldSubmitted: (value) async {
                      print(value);
                      stateClear();
                      myweather = await API().getwithLocation(value);
                      variableInsert();
                      // print(conditioncode);
                      imageInsert(conditioncode!);
                      userinput.clear();
                    },
                    validator: RequiredValidator(errorText: 'Required'),
                    cursorColor: Colors.black,
                    // autovalidateMode: submit ?AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search City',
                        hintStyle: TextStyle(color: Colors.black)),
                  ),
                ),
                ElevatedButton.icon(
                    icon: const Icon(
                      Icons.search,
                      size: 20,
                    ),
                    onPressed: submit
                        ? () async {
                            stateClear();
                            myweather =
                                await API().getwithLocation(userinput.text);
                            variableInsert();
                            print(conditioncode);
                            imageInsert(conditioncode!);
                            userinput.clear();
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.black,
                      backgroundColor: Colors.white,
                      side: submit
                          ? const BorderSide(width: 1.0, color: Colors.white)
                          : null,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: const Text(
                      'Check',
                    ))
              ],
            )),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: myplaceweather == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(cityname == null ? '' : '$cityname',
                                    style: const TextStyle(
                                      fontFamily: 'Libre',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    )),
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  showBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(),
                                            Column(),
                                            Column(),
                                          ],
                                        );
                                      });
                                },
                                child: Text(cityname == null
                                    ? ''
                                    : ' Forcast for next three days > '))
                          ],
                        ),
                        Text(
                            '$temperature and $skycondition and $cityname and $conditioncode',
                            style: const TextStyle(
                              color: Colors.black,
                            )),
                        const SizedBox(
                          height: 50,
                        ),
                        temperature == null
                            ? const CircularProgressIndicator()
                            : Column(
                                children: [
                                  Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('images/$image.png')),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '$skycondition',
                                      style: const TextStyle(
                                        fontFamily: 'Libre',
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            'Temp',
                                            style: TextStyle(
                                                fontFamily: 'Oleo',
                                                fontSize: 15),
                                          ),
                                          Text(
                                            '$temperature',
                                            style: const TextStyle(
                                                fontFamily: 'Libre',
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            'Humid',
                                            style: TextStyle(
                                                fontFamily: 'Oleo',
                                                fontSize: 15),
                                          ),
                                          Text(
                                            '$humidity',
                                            style: const TextStyle(
                                                fontFamily: 'Libre',
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            'Visibility',
                                            style: TextStyle(
                                                fontFamily: 'Oleo',
                                                fontSize: 15),
                                          ),
                                          Text(
                                            '$visibility',
                                            style: const TextStyle(
                                                fontFamily: 'Libre',
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                      ],
                    ),
            ),
          ),
        ));
  }
}

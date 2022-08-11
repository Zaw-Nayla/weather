import 'package:flutter/material.dart';
import 'package:weather_api/api.dart';
import 'package:weather_api/locationapi.dart';
import 'package:geolocator/geolocator.dart';
import 'yahoormodel.dart';

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
  int? conditioncode;
  String? image;
  Position? myposition;
  bool submit = false;

  constract() {
    API().getwithLocation('mogok').then((value) {
      setState(() {
        myweather = value;
        // variableInsert();
      });
    });

    API().getwithCoord(lat, long).then((value) {
      setState(() {
        myplaceweather = value;
        temperature = myplaceweather!.currentObservation.condition.temperature;
        skycondition = myplaceweather!.currentObservation.condition.text;
        cityname = myplaceweather!.location.city;
        conditioncode = myplaceweather!.currentObservation.condition.code;
      });
    });
  }

  variableInsert() {
    setState(() {
      temperature = myweather!.currentObservation.condition.temperature;
      skycondition = myweather!.currentObservation.condition.text;
      cityname = myweather!.location.city;
      conditioncode = myweather!.currentObservation.condition.code;
    });
  }

  // imageInsert() {
  //   if (conditioncode == 4 && 37 <= conditioncode! ||
  //       conditioncode! <= 39 && conditioncode == 47) {
  //     image = 'thunder cloud';
  //   } else if (0 <= conditioncode! && conditioncode! <= 3) {
  //     image = 'tornado';
  //   } else if (conditioncode == 24) {
  //     image = 'windy';
  //   } else if (5 <= conditioncode! && conditioncode! <= 8 ||
  //       41 <= conditioncode! && conditioncode! <= 46) {
  //     image = 'snow';
  //   } else if (9 <= conditioncode! && conditioncode! <= 14 ||
  //       conditioncode == 40) {
  //     image == 'rainy';
  //   } else if (15 <= conditioncode! && conditioncode! <= 23) {
  //     image == 'cloudy';
  //   } else if (25 <= conditioncode! && conditioncode! <= 36 ||
  //       conditioncode == 44) {
  //     image == 'cloudy';
  //   } else {
  //     skycondition = 'not avaliable';
  //   }
  // }

  @override
  void initState() {
    constract();
    // imageInsert();
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
        backgroundColor: const Color.fromARGB(104, 121, 191, 248),
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            ElevatedButton.icon(
                icon: const Icon(
                  Icons.location_on_outlined,
                  size: 20,
                ),
                onPressed: () async {
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

                    // cityname = myplaceweather!.name;
                    // skycondition = myplaceweather!.weather[0].id;
                  });
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: const Text('At Your Location'))
          ],
          title: const Text(
            'Search for City',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 20),
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Colors.grey.withOpacity(0.3),
                              Colors.grey.withOpacity(0.3),
                            ])),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: userinput,
                          // validator: RequiredValidator(errorText: 'Required'),
                          cursorColor: Colors.white,
                          // autovalidateMode: isInput? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Set the location',
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
                                  myweather = await API()
                                      .getwithLocation(userinput.text);
                                  variableInsert();
                                }
                              : null,
                          style: OutlinedButton.styleFrom(
                            primary: Colors.black,
                            backgroundColor: Colors.white,
                            side: submit
                                ? const BorderSide(
                                    width: 1.0, color: Colors.blueGrey)
                                : null,
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          label: const Text(
                            'Check',
                          ))
                    ],
                  ),
                ),
                Text(
                    '$temperature and $skycondition and $cityname and $conditioncode',
                    style: const TextStyle(
                      color: Colors.black,
                    )),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('images/$image.png')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('$skycondition',
                  style: const TextStyle(
                    fontFamily: 'Libre',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),),
                )
              ],
            ),
          ),
        ));
  }
}

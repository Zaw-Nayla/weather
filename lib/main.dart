import 'package:flutter/material.dart';
import 'package:weather_api/api.dart';
import 'package:weather_api/locationapi.dart';
import 'package:geolocator/geolocator.dart';
import 'yahoormodel.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:dotted_line/dotted_line.dart';

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
  List<Forecast> day = [];
  String? image;
  var high;
  var low;
  Position? myposition;
  bool submit = false;

  constract() {
    API().getwithLocation('mogok').then((value) {
      setState(() {
        myweather = value;
        variableInsert();
        imageInsert(conditioncode!);
      });
    });

    // API().getwithCoord(lat, long).then((value) {
    //   myplaceweather = value;
    // });
    // temperature = myplaceweather!.currentObservation.condition.temperature;
    // skycondition = myplaceweather!.currentObservation.condition.text;
    // cityname = myplaceweather!.location.city;
    // conditioncode = myplaceweather!.currentObservation.condition.code;
    // humidity = myplaceweather!.currentObservation.atmosphere.humidity;
    // visibility = myplaceweather!.currentObservation.atmosphere.visibility;
    // // day = myplaceweather!.forecasts;
    // imageInsert(conditioncode!);
  }

  variableInsert() {
    setState(() {
      temperature = myweather!.currentObservation.condition.temperature;
      skycondition = myweather!.currentObservation.condition.text;
      cityname = myweather!.location.city;
      conditioncode = myweather!.currentObservation.condition.code;
      humidity = myweather!.currentObservation.atmosphere.humidity;
      visibility = myweather!.currentObservation.atmosphere.visibility;
      day = myweather!.forecasts;
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
                      API().getwithCoord(lat, long).then((value) {
                        myplaceweather = value;
                      });
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
                      day = myplaceweather!.forecasts;
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
                      imageInsert(conditioncode!);
                      userinput.clear();
                    },
                    validator: RequiredValidator(errorText: 'Required'),
                    cursorColor: Colors.black,
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
                            userinput.clear();
                            variableInsert();
                            print(conditioncode);
                            imageInsert(conditioncode!);
                           
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
        body: Center(
          child: SingleChildScrollView (
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: myweather == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.46,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 18,
                                        color: temperature == null
                                            ? Colors.white
                                            : Colors.black,
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
                                ],
                              ),
                              const SizedBox(
                                height: 10,
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
                                                image: AssetImage(
                                                    'images/$image.png')),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '$skycondition',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Libre',
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
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
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        temperature == null ? const SizedBox() :
                        const DottedLine(
                          direction: Axis.horizontal,
                          lineLength: double.infinity,
                          lineThickness: 1.0,
                          dashLength: 3.0,
                          dashColor: Colors.black,
                          dashRadius: 0.0,
                          dashGapLength: 4.0,
                          dashGapColor: Colors.transparent,
                          dashGapRadius: 0.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:8.0),
                          child: Text(
                            cityname == null ? '' : ' Forcast for next 10 days ',
                            style:
                                const TextStyle(fontFamily: 'Libre', fontSize: 15),
                          ),
                        ),
                        temperature == null
                            ? const SizedBox()
                            : SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.35,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: day.length,
                                  itemBuilder: (context, index) {
                                    high = day[index].high;
                                    var high_end =
                                        ((high - 32) * 5 / 9).toString();
                                    low = day[index].low;
                                    var low_end = ((low - 32) * 5 / 9).toString();
                                    return ListTile(
                                      leading: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        child: Text(
                                          "${day[index].day}",
                                        ),
                                      ),
                                      subtitle: Container(
                                        width: 20.0,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:
                                                AssetImage('images/$image.png'),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(80.0),
                                        ),
                                      ),
                                      trailing: Text(
                                        "${double.parse(high_end).toStringAsFixed(0)}°",
                                        style:
                                            const TextStyle(color: Colors.black),
                                      ),
                                    );
                                  },
                                ),
                              )
                      ],
                    ),
            ),
          ),
        ));
  }
}

import 'yahoormodel.dart';
import 'package:http/http.dart' as http;

class API {

  Future<GetwithLocation> getwithLocation(String location) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-rapidapi-host': 'yahoo-weather5.p.rapidapi.com',
      'x-rapidapi-key': '5117292c9amsh9cf6be03522c809p178e3cjsnbb113cd3b645',
    };

    var url = Uri.parse(
        'https://yahoo-weather5.p.rapidapi.com/weather?location=$location&format=json&u=f');

    http.Response response = await http.get(url, headers: requestHeaders);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = GetwithLocation.fromRawJson(response.body);
      return data;
    } else {
      print(response.statusCode);
      throw Exception('Unable to Assest API');
    }
  }

  Future<GetwithLocation> getwithCoord(double lat, double long) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-rapidapi-host': 'yahoo-weather5.p.rapidapi.com',
      'x-rapidapi-key': '5117292c9amsh9cf6be03522c809p178e3cjsnbb113cd3b645',
    };

    var url = Uri.parse(
        'https://yahoo-weather5.p.rapidapi.com/weather?lat=$lat&long=$long');

    http.Response response = await http.get(url, headers: requestHeaders);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = GetwithLocation.fromRawJson(response.body);
      return data;
    } else {
      print(response.statusCode);
      throw Exception('Unable to Assest API');
    }
  }
}

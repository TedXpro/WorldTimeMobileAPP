import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  late String time;
  String flag;
  String url;
  bool isDaytime = false;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      http.Response response = await http.get(
        Uri.parse(
          "http://api.timezonedb.com/v2.1/get-time-zone?key=9WFD25WM4QHO&format=json&by=zone&zone=$url",
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic>? data = jsonDecode(response.body);

        if (data == null || !data.containsKey("formatted")) {
          throw Exception("Invalid API response");
        }

        String datetime = data["formatted"]; // Example: "2024-03-01 12:45:00"
        DateTime now = DateTime.parse(datetime);

        // Format the time (12-hour format with AM/PM)
        isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
        time = DateFormat.jm().format(now);
      } else {
        throw Exception(
          "Failed to load data. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Caught error: $e");
      time = "Could not get time data";
    }
  }
}

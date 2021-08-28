import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/Models/weather_data.dart';

const baseUrl = 'https://www.metaweather.com';
final locationUrl = (city) => '${baseUrl}/api/location/search/?query=${city}';
final weatherUrl = (locationId) => '${baseUrl}/api/location/${locationId}';

class WeatherRepository {
  final http.Client httpClient;
  WeatherRepository({@required this.httpClient}) : assert(httpClient != null);
  Future<int> getLocationIdFromCity(String city) async {
    final response = await this.httpClient.get(locationUrl(city));
    switch (response.statusCode) {
      case 200:
        final cities = jsonDecode(response.body) as List;
        return (cities.first)['woeid'] ?? 0;
        break;
      default:
        throw Exception('Error getting locaion id of: ${city}');
        break;
    }
  }

  Future<Weather> fetchWeather(int locationId) async {
    final response = await this.httpClient.get(weatherUrl(locationId));
    switch (response.statusCode) {
      case 200:
        final weatherJson = jsonDecode(response.body);
        return Weather.fromJson(weatherJson);
        break;
      default:
        throw Exception(
            'Error getting weather from location ID: ${locationId}');
        break;
    }
  }

  Future<Weather> getWeatherFromCity(String city) async {
    final int locationId = await getLocationIdFromCity(city);
    return fetchWeather(locationId);
  }
}

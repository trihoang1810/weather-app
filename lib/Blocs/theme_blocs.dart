import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/Events/theme_events.dart';
import 'package:weatherapp/Models/weather_data.dart';
import 'package:weatherapp/States/theme_states.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeState(
            backgroundColor: Colors.lightBlue, textColor: Colors.white));
  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeEventWeatherChanged) {
      final weatherCondition = event.weatherCondition;
      ThemeState newThemeState;
      if (weatherCondition == WeatherCondition.clear ||
          weatherCondition == WeatherCondition.lightCloud ||
          weatherCondition == WeatherCondition.lightRain) {
        newThemeState = ThemeState(
            backgroundColor: Colors.yellowAccent, textColor: Colors.black26);
      } else if (weatherCondition == WeatherCondition.hail ||
          weatherCondition == WeatherCondition.snow ||
          weatherCondition == WeatherCondition.sleet) {
        newThemeState = ThemeState(
            backgroundColor: Colors.lightBlue, textColor: Colors.white38);
      } else if (weatherCondition == WeatherCondition.heavyCloud) {
        newThemeState =
            ThemeState(backgroundColor: Colors.grey, textColor: Colors.black);
      } else if (weatherCondition == WeatherCondition.heavyRain ||
          weatherCondition == WeatherCondition.lightRain ||
          weatherCondition == WeatherCondition.showers) {
        newThemeState =
            ThemeState(backgroundColor: Colors.indigo, textColor: Colors.white);
      } else if (weatherCondition == WeatherCondition.thunderstorm) {
        newThemeState = ThemeState(
            backgroundColor: Colors.deepPurpleAccent, textColor: Colors.white);
      } else {
        newThemeState = ThemeState(
            backgroundColor: Colors.lightBlue, textColor: Colors.white);
      }
      yield ThemeState(
          backgroundColor: newThemeState.backgroundColor,
          textColor: newThemeState.textColor);
    }
  }
}

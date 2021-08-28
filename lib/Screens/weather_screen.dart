import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/Blocs/theme_blocs.dart';
import 'package:weatherapp/Blocs/weather_blocs.dart';
import 'package:weatherapp/Events/theme_events.dart';
import 'package:weatherapp/Events/weather_events.dart';
import 'package:weatherapp/Models/weather_data.dart';
import 'package:weatherapp/Screens/settings_screen.dart';
import 'package:weatherapp/Screens/temperature_widget.dart';
import 'package:weatherapp/States/theme_states.dart';
import 'package:weatherapp/States/weather_states.dart';

import 'city_search_screen.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Completer<void> _completer;
  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App Using BloC By SISTRAIN"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ));
              }),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final typedCity = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CitySearchScreen()),
              );
              if (typedCity != null) {
                BlocProvider.of<WeatherBloc>(context)
                    .add(WeatherEventRequested(city: typedCity));
              }
            },
          )
        ],
      ),
      body: Center(
        child: BlocConsumer<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state is WeatherStateSuccess) {
              BlocProvider.of<ThemeBloc>(context).add(ThemeEventWeatherChanged(
                  weatherCondition: state.weather.weatherCondition));
              _completer?.complete();
              _completer = Completer();
            }
          },
          builder: (context, state) {
            if (state is WeatherStateLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WeatherStateSuccess) {
              final Weather weather = state.weather;
              return BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: () {
                      BlocProvider.of<WeatherBloc>(context)
                          .add(WeatherEventRefresh(city: weather.location));
                      return _completer.future;
                    },
                    child: Center(
                      child: Container(
                        color: state.backgroundColor,
                        child: ListView(
                          children: [
                            SizedBox(height: 100),
                            Text(
                              weather.location,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: state.textColor,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                  "Updated: ${TimeOfDay.fromDateTime(weather.lastUpdated).format(context)}"),
                            ),
                            TemperatureWidget(
                              weather: weather,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is WeatherStateFail) {
              return Center(
                  child: Text(
                "Something went wrong",
                style: TextStyle(color: Colors.redAccent),
              ));
            }
            return Center(
              child: Text(
                "Please select a location...",
                style: TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}

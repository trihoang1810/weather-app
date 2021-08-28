import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/Blocs/settings_blocs.dart';
import 'package:weatherapp/Blocs/theme_blocs.dart';
import 'package:weatherapp/Blocs/weather_bloc_observer.dart';
import 'package:weatherapp/Blocs/weather_blocs.dart';
import 'package:weatherapp/Repository/weather_repos.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/Screens/weather_screen.dart';

void main() {
  Bloc.observer = WeatherBlocObserver();
  final WeatherRepository weatherRepository =
      WeatherRepository(httpClient: http.Client());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
        BlocProvider<SettingsBloc>(create: (context) => SettingsBloc())
      ],
      child: MyApp(
        weatherRepository: weatherRepository,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final WeatherRepository weatherRepository;
  MyApp({Key key, @required this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App By SISTRAIN',
      home: BlocProvider(
        create: (context) => WeatherBloc(weatherRepository: weatherRepository),
        child: WeatherScreen(),
      ),
    );
  }
}

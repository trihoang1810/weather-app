import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/Events/weather_events.dart';
import 'package:weatherapp/Models/weather_data.dart';
import 'package:weatherapp/Repository/weather_repos.dart';
import 'package:weatherapp/States/weather_states.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc({@required this.weatherRepository})
      : assert(weatherRepository != null),
        super(WeatherStateInitial());
  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is WeatherEventRequested) {
      yield WeatherStateLoading();
      try {
        final Weather weather =
            await weatherRepository.getWeatherFromCity(event.city);
        yield WeatherStateSuccess(weather: weather);
      } catch (e) {
        yield WeatherStateFail();
      }
    } else if (event is WeatherEventRefresh) {
      try {
        final Weather weather =
            await weatherRepository.getWeatherFromCity(event.city);
        yield WeatherStateSuccess(weather: weather);
      } catch (e) {
        yield WeatherStateFail();
      }
    }
  }
}

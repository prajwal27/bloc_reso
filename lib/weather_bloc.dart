import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import './bloc.dart';
import 'model/weather.dart';

class WeatherBloc extends HydratedBloc<WeatherEvent, WeatherState> {
  @override
  WeatherState get initialState {
    return super.initialState ?? WeatherInitial();
  }
  @override
  WeatherState fromJson(Map<String,dynamic> json) {
    try{
      final weather = Weather.fromJson(json);
      return WeatherLoaded(weather);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String,dynamic> toJson(WeatherState state) {
    if(state is WeatherLoaded) {
      return state.weather.toJson();
    } else {
      return null;
    }
  }

  // Under the hood, the Bloc library works with regular Dart Streams.
  // The "async*" makes this method an async generator, which outputs a Stream
  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    // Distinguish between different events, even though this app has only one
    if (event is GetWeather) {
      // Outputting a state from the asynchronous generator
      yield WeatherLoading();
      final weather = await _fetchWeatherFromFakeApi(event.cityName);
      yield WeatherLoaded(weather);
    }
  }

  Future<Weather> _fetchWeatherFromFakeApi(String cityName) {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 1),
          () {
        return Weather(
          cityName: cityName,
          // Temperature between 20 and 35.99
          temperature: 20 + Random().nextInt(15) + Random().nextDouble(),
        );
      },
    );
  }


}
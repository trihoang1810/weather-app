  
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/Blocs/settings_blocs.dart';
import 'package:weatherapp/Events/settings_events.dart';
import 'package:weatherapp/States/settings_states.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'),),
      body: ListView(
        children: <Widget>[
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingState) {
              return ListTile(
                title: Text('Temperature Unit'),
                isThreeLine: true,
                subtitle: Text(
                  settingState.temperatureUnit == TemperatureUnit.celsius ?
                      'Celsius' : 'Fahrenheit'
                ),
                trailing: Switch(
                  value: settingState.temperatureUnit == TemperatureUnit.celsius,
                  onChanged: (_) => BlocProvider.of<SettingsBloc>(context).
                      add(SettingsEventToggleUnit())

                ),
              );
            },
          )
        ],
      ),
    );
  }
}
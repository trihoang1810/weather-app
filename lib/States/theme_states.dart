import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

 class ThemeState extends Equatable {
  final Color backgroundColor;
  final Color textColor;
  const ThemeState({@required this.backgroundColor, this.textColor})
      : assert(backgroundColor != null),
        assert(textColor != null);
  @override
  List<Object> get props => [backgroundColor, textColor];
}

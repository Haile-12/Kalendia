import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'event.g.dart'; // Generated via build_runner

@HiveType(typeId: 0)
class Event extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final DateTime eventDate;

  @HiveField(3)
  final TimeOfDay? alarmTime;

  @HiveField(4)
  final String plan;

  Event({
    required this.title,
    required this.description,
    required this.eventDate,
    this.alarmTime,
    required this.plan,
  });
}

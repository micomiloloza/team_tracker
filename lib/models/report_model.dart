import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Report {
  String id;
  String author;
  String title;
  num internalTrainingLoad;
  num muscleSoreness;
  num pain;
  num hrvMeasure;
  num energyLevel;
  num mood;
  num yesterdayDailyStress;
  num stepsMeasure;
  num sleepQuality;
  num sleepQuantity;
  Timestamp timestamp;

  Report({
    this.id,
    this.author,
    @required this.title,
    @required this.internalTrainingLoad,
    @required this.muscleSoreness,
    @required this.pain,
    @required this.hrvMeasure,
    @required this.energyLevel,
    @required this.mood,
    @required this.yesterdayDailyStress,
    @required this.stepsMeasure,
    @required this.sleepQuality,
    @required this.sleepQuantity,
    @required this.timestamp,
  });

  Report.fromMap(Map snapshot, String documentId) {
    this.id = documentId;
    this.author = snapshot["author"];
    this.title = snapshot["title"];
    this.internalTrainingLoad = snapshot["internalTrainingLoad"];
    this.muscleSoreness = snapshot["muscleSoreness"];
    this.pain = snapshot["pain"];
    this.hrvMeasure = snapshot["hrvMeasure"];
    this.energyLevel = snapshot["energyLevel"];
    this.mood = snapshot["mood"];
    this.yesterdayDailyStress = snapshot["yesterdayDailyStress"];
    this.stepsMeasure = snapshot["stepsMeasure"];
    this.sleepQuality = snapshot["sleepQuality"];
    this.sleepQuantity = snapshot["sleepQuantity"];
    this.timestamp = snapshot["timestamp"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['author'] = this.author;
    data['title'] = this.title;
    data['internalTrainingLoad'] = this.internalTrainingLoad;
    data['muscleSoreness'] = this.muscleSoreness;
    data['pain'] = this.pain;
    data['hrvMeasure'] = this.hrvMeasure;
    data['energyLevel'] = this.energyLevel;
    data['mood'] = this.mood;
    data['yesterdayDailyStress'] = this.yesterdayDailyStress;
    data['stepsMeasure'] = this.stepsMeasure;
    data['sleepQuality'] = this.sleepQuality;
    data['sleepQuantity'] = this.sleepQuantity;
    data['timestamp'] = this.timestamp;
    
    return data;
  }
}

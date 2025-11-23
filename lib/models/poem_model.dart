import 'package:cloud_firestore/cloud_firestore.dart';

class PoemModel {
  final String id;
  final String userId;
  final String imageUrl;
  final String poemText;
  final double latitude;
  final double longitude;
  final Timestamp timestamp;

  PoemModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.poemText,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory PoemModel.fromJson(Map<String, dynamic> json) {
    return PoemModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      imageUrl: json['imageUrl'] as String,
      poemText: json['poemText'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: json['timestamp'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'poemText': poemText,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
    };
  }
}

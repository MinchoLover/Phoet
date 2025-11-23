import 'package:json_annotation/json_annotation.dart';

part 'gemini_response.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.none)
class GeminiResponse {
  final List<Candidate>? candidates;

  GeminiResponse({this.candidates});

  factory GeminiResponse.fromJson(Map<String, dynamic> json) =>
      _$GeminiResponseFromJson(json);

  String? get generatedText {
    if (candidates?.isNotEmpty == true &&
        candidates!.first.content?.parts?.isNotEmpty == true) {
      return candidates!.first.content!.parts!.first.text;
    }
    return null;
  }
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.none)
class Candidate {
  final Content? content;

  Candidate({this.content});

  factory Candidate.fromJson(Map<String, dynamic> json) =>
      _$CandidateFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.none)
class Content {
  final List<Part>? parts;

  Content({this.parts});

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.none)
class Part {
  final String? text;

  Part({this.text});

  factory Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);
}

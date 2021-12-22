
import 'package:json_annotation/json_annotation.dart';

part 'flag_model.g.dart';

@JsonSerializable()
class Flag {
  const Flag({
    required this.svg,
    required this.png,
  });

  factory Flag.fromJson(Map<String, dynamic> json) => _$FlagFromJson(json);
  Map<String, dynamic> toJson() => _$FlagToJson(this);

  final String svg;
  final String png;
}
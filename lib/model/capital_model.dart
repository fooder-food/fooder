
import 'package:json_annotation/json_annotation.dart';

part 'capital_model.g.dart';

@JsonSerializable()
class Capital {
  const Capital({
    this.latlng,
});

  factory Capital.fromJson(Map<String, dynamic> json) => _$CapitalFromJson(json);
  Map<String, dynamic> toJson() => _$CapitalToJson(this);

  final List<double>? latlng;
}
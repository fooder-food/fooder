
import 'package:azlistview/azlistview.dart';
import 'package:json_annotation/json_annotation.dart';

part 'find_place_state_model.g.dart';

@JsonSerializable()
class FindPlaceState {
  FindPlaceState({
    required this.id,
    required this.name,
    required this.iso2,
  });

  factory FindPlaceState.fromJson(Map<String, dynamic> json) => _$FindPlaceStateFromJson(json);
  Map<String, dynamic> toJson() => _$FindPlaceStateToJson(this);


  final int id;
  final String name;
  final String iso2;


}
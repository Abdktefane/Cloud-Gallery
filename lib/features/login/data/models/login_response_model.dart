import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel extends Equatable {
  const LoginResponseModel({this.token, this.id});

  final String? token;
  final int? id;

  LoginResponseModel copyWith({String? token}) {
    return LoginResponseModel(token: token ?? this.token);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, token];

  static LoginResponseModel fromJson(Object? json) => _$LoginResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}

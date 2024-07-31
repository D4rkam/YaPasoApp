import 'dart:convert';

ResponseApi responseApiFromJson(String str, bool? success) =>
    ResponseApi.fromJson(json.decode(str), success);

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  dynamic data;
  bool? success;

  ResponseApi({this.data, this.success});

  factory ResponseApi.fromJson(Map<String, dynamic> json, bool? success) =>
      ResponseApi(
        data: json["user"],
        success: success,
      );

  Map<String, dynamic> toJson() => {
        "user": data,
        "success": success,
      };
}

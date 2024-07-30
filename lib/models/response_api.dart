import 'dart:convert';

ResponseApi responseApiFromJson(String str) =>
    ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  String? accessToken;
  String? tokenType;
  dynamic data;

  ResponseApi({this.data, this.accessToken, this.tokenType});

  factory ResponseApi.fromJson(Map<String, dynamic> json) => ResponseApi(
        accessToken: json["token"]["access_token"],
        tokenType: json["token"]["token_type"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "User": data,
      };
}

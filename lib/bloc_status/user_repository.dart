import 'dart:convert';
import 'package:bizapptrack/bloc_status/record_model.dart';
import 'package:bizapptrack/bloc_status/statistic_model.dart';
import 'package:bizapptrack/bloc_status/user_model.dart';
import 'package:bizapptrack/env.dart';
import 'package:http/http.dart' as http;

class StatusRepository {

  Future<Profile> loginServices({required String userid}) async {

    Map<String, dynamic> body = {
      "username": userid,
      "password": Env.cariapa,
      "DOMAIN": "BIZAPP",
      "platform" : "Android",
      "lastseenversion" : "",
      "FCM_TOKEN" : "",
      "regid": ""
    };

    final res = await http.post(Uri.parse(Env.loginurl), body: body);
    final data = json.decode(res.body);
    return Profile.fromJson(data[0]);
  }

  Future<Statistik> dedagangServices({required String pid}) async {
    Map<String, dynamic> body = {
      "pid": pid,
      "DOMAIN": "BIZAPP",
      "TOKEN": "aa",
    };

    final res = await http.post(Uri.parse(Env.statisticurl), body: body);
    final data = json.decode(res.body);
    return Statistik.fromJson(data[0]);
  }

  late TotalRekodTempahan totalRekodTempahan;
  Future<TotalRekodTempahan> recordServices({required String pid, required String sk}) async {
    Map<String, dynamic> body = {
      "pid": pid,
      "DOMAIN": "BIZAPP",
      "TOKEN": "aa",
      "sk": sk,
      "tahuntahun": "",
      "statusparcel_noorder": "",
      "jenissort": "0",
      "loadsemua": "NO",
      "start": "0",
    };

    // listrekod.clear();

    final res = await http.post(Uri.parse(Env.rekodurl), body: body);
    totalRekodTempahan = TotalRekodTempahan.fromJson(jsonDecode(res.body));
    return totalRekodTempahan;

  }

}
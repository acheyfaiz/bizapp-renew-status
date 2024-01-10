// import 'package:bizapptrack/utils/constant.dart';
// import 'package:bizapptrack/env.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class StatusController extends ChangeNotifier{
//
//   String username = "";
//   String sk = "";
//   String nama = "";
//   String roleid = "";
//   String tarikhnaiktaraf = "";
//   String tarikhtamat = "";
//   String basicplusonly = "";
//
//   String biltempahan = "-";
//   String rekodtempahan = "-";
//   String bilEjen = "-";
//   String bizappayacc = "-";
//
//   bool call = false;
//   bool callDedagang = false;
//   bool callRekod = false;
//
//   Future loginServices(BuildContext context, {required String userid}) async {
//
//     Map<String, dynamic> body = {
//       "username": userid,
//       "password": Env.cariapa,
//       "DOMAIN": "BIZAPP",
//       "platform" : "Android",
//       "lastseenversion" : "",
//       "FCM_TOKEN" : "",
//       "regid": ""
//     };
//
//     await http.post(Uri.parse(Env.loginurl), body: body).then((res) async {
//       final resJSON = json.decode(res.body);
//       call = false;
//       notifyListeners();
//
//       callDedagang = true;
//       notifyListeners();
//
//       /// check de dagang
//       _dedagang(resJSON[0]['pid']).onError((error, stackTrace) {
//         callDedagang = false;
//         notifyListeners();
//         ScaffoldMessenger.of(context).showSnackBar(snackBarBizapp("error dedagang"));
//       });
//
//       _getRekod(resJSON[0]['pid']);
//
//         var report = resJSON[0]['addon_module_rpt'];
//
//         /// to check bizapp package
//         var pakej = "";
//         resJSON[0]['roleid'] == "0" && report == "0" ? pakej = "Basic" :
//         resJSON[0]['roleid'] == "0" && report == "1" ? pakej = "Basic+" :
//         resJSON[0]['roleid'] == "1" ? pakej = "Pro" :
//         resJSON[0]['roleid'] == "2" ? pakej = "Pro" :
//         resJSON[0]['roleid'] == "3" ? pakej = "Ultimate" : pakej = resJSON[0]['roleid'];
//
//         /// to check bizappay account
//         var accbizappay = "";
//         resJSON[0]['accountBIZAPPAY'] == "Y" ? accbizappay = "Ya" : accbizappay = "Tiada";
//
//         sk = resJSON[0]['secretkey'];
//         username = resJSON[0]['penggunaid'];
//         nama = resJSON[0]['nama'];
//         roleid = pakej;
//         tarikhnaiktaraf = resJSON[0]['tarikhnaiktaraf'];
//         tarikhtamat = resJSON[0]['tarikhtamattempoh'];
//         bizappayacc = accbizappay;
//         basicplusonly = resJSON[0]['addon_module_rpt_display'];
//         basicplusonly = basicplusonly == "" || basicplusonly.isEmpty ? basicplusonly = "-" : basicplusonly.replaceAll("<br>", " ");
//         notifyListeners();
//
//       return resJSON[0];
//
//     }).onError((error, stackTrace) {
//       call = false;
//       notifyListeners();
//
//       ScaffoldMessenger.of(context).showSnackBar(snackBarBizapp("error login"));
//     });
//   }
//
//   String dedagang = "-";
//   Future _dedagang(String pid) async {
//     Map<String, dynamic> body = {
//       "pid": pid,
//       "DOMAIN": "BIZAPP",
//       "TOKEN": "aa",
//     };
//
//     await http.post(Uri.parse(Env.statisticurl), body: body).then((res) {
//       final resJSON = json.decode(res.body);
//       callDedagang = false;
//       var x = resJSON[0]['dedagang_offer'];
//       x == "0" ? dedagang = "No" : dedagang = "Yes";
//
//       biltempahan = resJSON[0]['TOTALORDER'];
//       biltempahan = biltempahan.replaceAll(",", "");
//       rekodtempahan = resJSON[0]['TOTALORDERDONE'];
//       bilEjen = resJSON[0]['COUNTAGENT'];
//       notifyListeners();
//     });
//   }
//
//   final List listrekod = [];
//   Future _getRekod(String pid) async {
//     Map<String, dynamic> body = {
//       "pid": pid,
//       "DOMAIN": "BIZAPP",
//       "TOKEN": "aa",
//       "sk": sk,
//       "tahuntahun": "",
//       "statusparcel_noorder": "",
//       "jenissort": "0",
//       "loadsemua": "NO",
//       "start": "0",
//     };
//
//     callRekod = true;
//     listrekod.clear();
//     notifyListeners();
//
//     await http.post(Uri.parse(Env.rekodurl), body: body).then((res) {
//       final resJSON = json.decode(res.body);
//       callRekod = false;
//       listrekod.addAll(resJSON);
//       notifyListeners();
//     });
//   }
//
//   check(BuildContext context, String username){
//     call = true;
//     notifyListeners();
//     loginServices(context, userid: username).then((value) {
//       call = false;
//       notifyListeners();
//     }).onError((error, stackTrace) {
//       call = false;
//       notifyListeners();
//
//       ScaffoldMessenger.of(context).showSnackBar(snackBarBizapp(""));
//
//     });
//   }
//
//
// }
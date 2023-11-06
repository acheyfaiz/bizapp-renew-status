import 'dart:convert';
import 'package:bizapptrack/button.dart';
import 'package:bizapptrack/data_user.dart';
import 'package:bizapptrack/list_to_excel.dart';
import 'package:bizapptrack/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TestRenew extends StatefulWidget {
  const TestRenew({super.key});

  @override
  State<TestRenew> createState() => _TestRenewState();
}

class _TestRenewState extends State<TestRenew> {


  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Status Renew Bizapp User", style: TextStyle(
          color: Colors.white
        )),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text('v1.1.0', style: TextStyle(
              color: Colors.white
            )),
          )
        ],
      ),

      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 20),

              Wrap(
                runSpacing: 10,
                children: [

                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * .5,
                    child: TextFormField(
                      onFieldSubmitted: (val){
                        _check();
                      },
                      style: const TextStyle(fontSize: 16),
                      keyboardType: TextInputType.emailAddress,
                      validator: (e) => e!.isEmpty ? 'user ID cannot empty' : null,
                      controller: usernameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0, style: BorderStyle.solid,
                          ),
                        ),
                        filled: true,
                        labelStyle: TextStyle(fontSize: 20),
                        labelText: 'Username',
                        fillColor: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// button
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      BizappButton(
                          color: Colors.grey[300]!,
                          title: "Enter",
                          tapCallback: ()=> _check()
                      ),

                      const SizedBox(width: 10),

                      BizappButton(
                        color: Colors.green[300]!,
                        title: "Export to Excel",
                        tapCallback: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const ListToExcel())),
                      ),

                    ],
                  ),

                ],
              ),

              const SizedBox(height: 20),

              _body2(),

              const SizedBox(height: 100),

            ],
          ),
        ),
      ),
    );
  }

  Widget _tips(){
    return tarikhtamat != "" ? const Text("* Adakah tarikh tamat backdated?\nJika ya, pakej user ni dah expired\n\n", style: TextStyle(
      fontSize: 17, fontWeight: FontWeight.w300
    ),) : const SizedBox();
  }

  Widget _body2(){
    return _call == false ? Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Wrap(
          runSpacing: 10,
          children: [

            /// data user
            DataUser(children: [
              BizappText(text: "Username:  ${username.toLowerCase()}"),
              BizappText(text: "Nama:  $nama"),
              BizappText(text: "Pakej:  $roleid"),
              BizappText(text: "Tarikh naik taraf:  $tarikhnaiktaraf"),
              Text("Tarikh tamat:  $tarikhtamat", style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red
              )),

              _tips(),
              basicplusonly != "-" && basicplusonly != "" ?
                BizappText(text: "Basic+ Add On: $basicplusonly\n") : const SizedBox(),

            ]),

            const SizedBox(width: 10),

            /// data rekod
            _callDedagang == false ? DataRekod(children: [
              BizappText(text: "Rekod Tempahan : $_rekodtempahan"),
              const SizedBox(height: 10),
              BizappText(text: "Bil. Tempahan : $_biltempahan"),
              const SizedBox(height: 10),
              BizappText(text: "Bil. Ejen : $_bilEjen"),
              BizappText(text: "Ada Bizappay : $_bizappayacc"),
            ]) : const GetLoad(text: "Load data statistics ..."),

          ],
        ),

        const SizedBox(height: 10),
        const BizappText(text: 'Senarai rekod 5 terakhir: '),

        /// data list
        _callRekod == false ?
        _listrekod.isEmpty ? const Text('Tiada Rekod', style: TextStyle(
          fontSize: 20,
        ))
            : DataList(listrekod: _listrekod)
            : const GetLoad(text: "Load data record ...")

      ],
    ) : const GetLoad(text: "Load data ...");
  }




  //////////////////////////////////////////////////
  //////////////////////////////////////////////////
  //////////////////////////////////////////////////
  //////////////////////////////////////////////////
  //////////////////////////////////////////////////
  //////////////////////////////////////////////////

  String username = "";
  String sk = "";
  String nama = "";
  String roleid = "";
  String tarikhnaiktaraf = "";
  String tarikhtamat = "";
  String basicplusonly = "";

  String _biltempahan = "-";
  String _rekodtempahan = "-";
  String _bilEjen = "-";
  String _bizappayacc = "-";

  bool _call = false;
  bool _callDedagang = false;
  bool _callRekod = false;

  Future loginServices() async {
    Map<String, dynamic> body = {
      "username": usernameController.text,
      "password": "abc280801z",
      "DOMAIN": "BIZAPP",
      "platform" : "Android",
      "lastseenversion" : "",
      "FCM_TOKEN" : "",
      "regid": ""
    };

    await http.post(Uri.parse("https://corrad.visionice.net/bizapp/apigenerator_VERSIX.php?api_name=TRACK_LOGIN"), body: body).then((res) {
      final resJSON = json.decode(res.body);

      setState(() {
        _callDedagang = true;
      });

      /// check de dagang
      _dedagang(resJSON[0]['pid']).onError((error, stackTrace) {
        setState(() {
          _callDedagang = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          onVisible: (){
            HapticFeedback.vibrate().timeout(const Duration(milliseconds: 1500));
            HapticFeedback.heavyImpact();
          },
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          content: const Text("Error. Sila panggil Faiz", style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18, color: Colors.white,
            //fontWeight: FontWeight.bold
          )),
        ));
      });

      _getRekod(resJSON[0]['pid']);

      setState(() {
        var report = resJSON[0]['addon_module_rpt'];

        /// to check bizapp package
        var pakej = "";
        resJSON[0]['roleid'] == "0" && report == "0" ? pakej = "Basic" :
        resJSON[0]['roleid'] == "0" && report == "1" ? pakej = "Basic+" :
        resJSON[0]['roleid'] == "1" ? pakej = "Pro" :
        resJSON[0]['roleid'] == "2" ? pakej = "Pro" :
        resJSON[0]['roleid'] == "3" ? pakej = "Ultimate" : pakej = resJSON[0]['roleid'];

        /// to check bizappay account
        var accbizappay = "";
        resJSON[0]['accountBIZAPPAY'] == "Y" ? accbizappay = "Ya" : accbizappay = "Tiada";

        sk = resJSON[0]['secretkey'];
        username = resJSON[0]['penggunaid'];
        nama = resJSON[0]['nama'];
        roleid = pakej;
        tarikhnaiktaraf = resJSON[0]['tarikhnaiktaraf'];
        tarikhtamat = resJSON[0]['tarikhtamattempoh'];
        _bizappayacc = accbizappay;
        basicplusonly = resJSON[0]['addon_module_rpt_display'];
        basicplusonly = basicplusonly == "" || basicplusonly.isEmpty ? basicplusonly = "-" : basicplusonly.replaceAll("<br>", " ");
      });
      return resJSON[0];

    }).onError((error, stackTrace) {
      setState(() {
        _call = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        onVisible: (){
          HapticFeedback.vibrate().timeout(const Duration(milliseconds: 1500));
          HapticFeedback.heavyImpact();
        },
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        content: const Text("Error. Sila panggil Faiz", style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18, color: Colors.white,
          //fontWeight: FontWeight.bold
        )),
      ));
    });
  }

  String dedagang = "-";
  Future _dedagang(String pid) async {
    Map<String, dynamic> body = {
      "pid": pid,
      "DOMAIN": "BIZAPP",
      "TOKEN": "aa",
    };

    await http.post(Uri.parse("https://corrad.visionice.net/bizapp/apigenerator_VERSIX.php?api_name=TRACK_GET_STATISTICS&TX="), body: body).then((res) {
      final resJSON = json.decode(res.body);
      setState(() {
        _callDedagang = false;
        var x = resJSON[0]['dedagang_offer'];
        x == "0" ? dedagang = "No" : dedagang = "Yes";

        _biltempahan = resJSON[0]['TOTALORDER'];
        _biltempahan = _biltempahan.replaceAll(",", "");
        _rekodtempahan = resJSON[0]['TOTALORDERDONE'];
        _bilEjen = resJSON[0]['COUNTAGENT'];

      });
    });
  }

  final List _listrekod = [];
  Future _getRekod(String pid) async {
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

    setState(() {
      _callRekod = true;
      _listrekod.clear();
    });

    await http.post(Uri.parse("https://corrad.visionice.net/bizapp/apigenerator_VERSIX.php?api_name=TRACK_LIST_DONETRACKINGNO&TX="), body: body).then((res) {
      final resJSON = json.decode(res.body);
      setState(() {
        _callRekod = false;
        _listrekod.addAll(resJSON);
      });
    });
  }


  _check(){
    setState(() {
      _call = true;
    });
    loginServices().then((value) {
      setState(() {
        _call = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _call = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        onVisible: (){
          HapticFeedback.vibrate().timeout(const Duration(milliseconds: 1500));
          HapticFeedback.heavyImpact();
        },
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        content: const Text("Error. Sila panggil Faiz", style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18, color: Colors.white,
        )),
      ));

    });
  }




}

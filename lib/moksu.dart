import 'dart:convert';
import 'package:bizapptrack/list_to_excel.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:html' as html;

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
        ),),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              const SizedBox(height: 20),

              SizedBox(
                width: MediaQuery.sizeOf(context).width * .6,
                child: TextFormField(
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

              const SizedBox(height: 20),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        onPressed: ()=> _check(),
                        icon: const Text("Enter")
                    ),
                  ),

                  const SizedBox(width: 20),
                  DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.green[300],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const ListToExcel())),
                        icon: const Text("Export to Excel", style: TextStyle(color: Colors.white),)
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 20),

              _body()

            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveContactInPhone() async {
    try {
      PermissionStatus permission = await Permission.contacts.status;

      if (permission != PermissionStatus.granted) {
        await Permission.contacts.request();
        PermissionStatus permission = await Permission.contacts.status;

        if (permission == PermissionStatus.granted) {
          Contact newContact = new Contact();
          newContact.givenName = "Faizx";
          newContact.familyName = "";
          newContact.emails = [
            Item(label: "email", value: "mhdxfaiz@gmail.com")
          ];
          newContact.phones = [
            Item(label: "mobile", value: "0176134058")
          ];
          await ContactsService.addContact(newContact);

        } else {
          //_handleInvalidPermissions(context);
        }
      }
      else {
        Contact newContact = new Contact();
        newContact.givenName = "Faizx";
        newContact.familyName = "";

        newContact.emails = [
          Item(label: "email", value: "mhdxfaiz@gmail.com")
        ];
        newContact.phones = [
          Item(label: "mobile", value: "0176134058")
        ];

        await ContactsService.addContact(newContact).then((value) {
          print('res ${value}');
        });
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       shape: RoundedRectangleBorder(
        //           borderRadius:
        //           BorderRadius.circular(10.0)),
        //       elevation: 0,
        //       actions: [
        //         MaterialButton(
        //           minWidth: MediaQuery.sizeOf(context).width,
        //           child: const Text("OK"),
        //           onPressed: () {
        //             Navigator.pop(context);
        //           },
        //         )
        //       ],
        //
        //       title: Container(
        //         child: Center(
        //           child: Text("Berjaya !",
        //               style: TextStyle(
        //                 fontWeight: FontWeight.bold,
        //                 fontSize: MediaQuery.sizeOf(context).height * 0.02,
        //                 color: Colors.black87,
        //               )),
        //         ),
        //       ),
        //
        //       content: Container(
        //         child: Lottie.asset("assets/images/success.json", height: 50, width: 50),
        //       ),
        //     );
        //   },
        // );
      }


    } catch (e) {
      debugPrint('aaa: $e');
    }
  }


  Widget _body(){
    return _call == false ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Username:  ${username.toLowerCase()}", style: _style()),
        Text("Nama:  $nama", style: _style()),
        Text("Pakej:  $roleid", style: _style()),
        Text("Tarikh naik taraf:  $tarikhnaiktaraf", style: _style()),
        Text("Tarikh tamat:  $tarikhtamat", style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red
        )),
        _tips(),
        basicplusonly != "-" && basicplusonly != "" ? Text("Basic+ Add On: $basicplusonly\n", style: _style()) : const SizedBox(),


        _callDedagang == false ? Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [

              Text("Rekod Tempahan (tempahan dah diproses): $_rekodtempahan", style: _style()),
              Text("Bil. Tempahan (termasuk draft, pending order) : $_biltempahan", style: _style())

            ],
          ),
        ) : _getLoad("Load data statistics ... "),


        const SizedBox(height: 20),
        Text('Senarai rekod 3 terakhir: ', style: _style()),
        _callRekod == false ?
          _listrekod.isEmpty ? const Text('Tiada Rekod', style: TextStyle(
              fontSize: 20,
          ))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _listrekod.take(3).length,
                  itemBuilder: (context, i){
                    return Center(
                      child: ListTile(
                        title: Text("${i+1} . ${_listrekod[i]['transactiondate']}"),
                      ),
                    );
                  }
              ) : _getLoad("Load data record ...")

      ],
    ) : _getLoad("Load data ...");
  }

  TextStyle _style(){
    return const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold
    );
  }

  Widget _getLoad(String text){
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      
      children: [

        Text(text),
        const SizedBox(width: 10),
        const CircularProgressIndicator(color: Colors.red)

      ],
    );
  }

  Widget _tips(){
    return tarikhtamat != "" ? const Text("* Adakah tarikh tamat backdated?\nJika ya, pakej user ni dah expired\n\n", style: TextStyle(
      fontSize: 17, fontWeight: FontWeight.w300
    ),) : const SizedBox();
  }

  String username = "";
  String sk = "";
  String nama = "";
  String roleid = "";
  String tarikhnaiktaraf = "";
  String tarikhtamat = "";
  String basicplusonly = "";

  String _biltempahan = "-";
  String _rekodtempahan = "-";

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
      // check de dagang
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

        var pakej = "";
        resJSON[0]['roleid'] == "0" && report == "0" ? pakej = "Basic" :
        resJSON[0]['roleid'] == "0" && report == "1" ? pakej = "Basic+" :
        resJSON[0]['roleid'] == "1" ? pakej = "Pro" :
        resJSON[0]['roleid'] == "2" ? pakej = "Pro" :
        resJSON[0]['roleid'] == "3" ? pakej = "Ultimate" : pakej = resJSON[0]['roleid'];

        sk = resJSON[0]['secretkey'];
        username = resJSON[0]['penggunaid'];
        nama = resJSON[0]['nama'];
        roleid = pakej;
        tarikhnaiktaraf = resJSON[0]['tarikhnaiktaraf'];
        tarikhtamat = resJSON[0]['tarikhtamattempoh'];
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

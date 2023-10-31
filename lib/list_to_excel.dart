import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListToExcel extends StatefulWidget {
  const ListToExcel({super.key});

  @override
  State<ListToExcel> createState() => _ListToExcelState();
}

class _ListToExcelState extends State<ListToExcel> {

  final List<PenggunaModel> _list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _list.clear();
      _aa.clear();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.blue,
        title: const Text("List to Excel", style: TextStyle(
            color: Colors.white
        ),),
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [

          const SizedBox(height: 20),

          _form(),

          const Text('1. Masukkan seberapa banyak data. Ikut seperti format di atas'),
          const Text('2. Tekan Export to Excel'),

          const SizedBox(height: 20),
          _button(),

          _listname(),

          const SizedBox(height: 50),

        ],
      ),
    );
  }

  final TextEditingController _controller = TextEditingController();
  final String _col1 = "PENGGUNAID";
  final String _col2 = "NAMA";
  final String _col3 = "PAKEJ";
  final String _col4 = "TARIKH EXPIRED";
  final String _col5 = "EMEL";
  final String _col6 = "NO H/P";
  final String _col7 = "ONBOARD DEDAGANG";

  final dataList = [];

  Widget _form(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .6,
      child: TextField(
        maxLines: 10,
        controller: _controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Masukkan data seperti:\n\n'
                    'PENGGUNAID : BLINGRECIPE\n'
                    'NAMA : SYAZA NUR IYLIA BINTI ZULKIFLI\n'
                    'PAKEJ : SUPERB\n'
                    'TARIKH EXPIRED : 22/08/2023\n'
                    'EMEL : admin@blingrecipe.com\n'
                    'NO H/P : 0143467400\n'
                    'ONBOARD DEDAGANG : YES\n'
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _aa = [];
  Widget _button(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        /// button enter
        MaterialButton(
          onPressed: (){

            if(_controller.text.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(_popup("Sila masukkan data"));
            }
            else{
              _checksmartEntryI();
              // _check2();
            }

          },
          color: Colors.grey[300],
          height: 60,
          child: const Text("Enter"),
        ),
        const SizedBox(width: 20),

        /// button clear list
        MaterialButton(
          onPressed: (){
            setState(() {
              _list.clear();
              _aa.clear();
            });
          },
          color: Colors.grey[300],
          height: 60,
          child: const Text("Clear List"),
        ),
        const SizedBox(width: 20),

        /// button export to excel
        MaterialButton(
          onPressed: (){

            if(_list.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(_popup("Tiada data. Masukkan data"));
            }
            else{
              _aa.clear();
              _list.map((e) {

                _aa.add({_col1: e.penggunaid, _col2: e.nama, _col3: e.pakej, _col4: e.tarikh, _col5: e.emel, _col6: e.nohp, _col7: e.dedagang});

              }).toList();

              _exportListToExcel(_aa).then((_) {
                debugPrint('Excel file exported successfully');
                ScaffoldMessenger.of(context).showSnackBar(_popup("Excel file exported successfully"));
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(_popup("Error exporting Excel file: $error"));
              });
            }

          },
          color: Colors.green[300],
          height: 60,
          child: const Text("Export to Excel", style: TextStyle(color: Colors.white)),
        ),

      ],
    );
  }

  Widget _listname(){
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _list.length,
        itemBuilder: (context, i)=>
            ListTile(
              leading: Text("${i+1}. ", style: const TextStyle(
                fontSize: 16
              ),),
              trailing: MaterialButton(
                color: Colors.red,
                onPressed: (){
                  setState(() {
                    _list.removeAt(i);
                  });
                },
                child: const Text('Remove', style: TextStyle(
                  color: Colors.white
                ),),
              ),
              title: Text("${_list[i].penggunaid}, ${_list[i].nama}, ${_list[i].pakej}, ${_list[i].tarikh}, ${_list[i].emel}, ${_list[i].nohp},  ${_list[i].dedagang}",
                style: const TextStyle(
                color: Colors.black
              ),),
            )
    );
  }

  SnackBar _popup(String text){
    return SnackBar(
      onVisible: (){
        HapticFeedback.vibrate().timeout(const Duration(milliseconds: 1500));
        HapticFeedback.heavyImpact();
      },
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      content: Text(text, style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18, color: Colors.white,
        //fontWeight: FontWeight.bold
      )),
    );
  }

  String _penggunaid = "";
  String _nama = "";
  String _pakej = "";
  String _tarikh = "";
  String _emel = "";
  String _nohp = "";
  String _dedagang = "";

  int a = 0;

  _checksmartEntryI(){

    debugPrint("${_controller.text}\n");

    var cust = _controller.text.split("\n");
    debugPrint("* ${cust[0]}");

    setState(() {
      _penggunaid = cust[0];
      _nama = cust[1];
      _pakej = cust[2];
      _tarikh = cust[3];
      _emel = cust[4];
      _nohp = cust[5];
      _dedagang = cust[6];
    });

    _list.add(
        PenggunaModel(
          penggunaid: _penggunaid.replaceAll("PENGGUNAID : ", ""),
          nama: _nama.replaceAll("NAMA : ", ""),
          pakej: _pakej.replaceAll("PAKEJ : ", ""),
          tarikh: _tarikh.replaceAll("TARIKH EXPIRED : ", ""),
          emel: _emel.replaceAll("EMEL : ", ""),
          nohp: _nohp.replaceAll("NO H/P : ", ""),
          dedagang: _dedagang.replaceAll("ONBOARD DEDAGANG : ", ""),
        ));

    _controller.clear();

  }

  // _check2(){
  //   // RegExp exp = RegExp(r"^[0-9]+$");
  //   // print(_controller.text.split("\n"));
  //
  //   // List<String> lines = _controller.text.split('\n'); // Split by line breaks
  //   //
  //   // List<Map<String, String>> userData = [];
  //   // List<Map<String, PenggunaModel>> _data = [];
  //   //
  //   // for (String line in lines) {
  //   //   if (line.trim().isEmpty) continue;
  //   //
  //   //   List<String> parts = line.split(RegExp(r'[0-9)\s]+')); // Split by ')' and whitespace
  //   //   if (parts.length >= 2) {
  //   //     String number = parts[0];
  //   //     String data = parts.sublist(1).join(' ');
  //   //     userData.add({"Number": number, "Data": data});
  //   //     _data.add({});
  //   //   }
  //   // }
  //   //
  //   // // Printing the result
  //   // for (var user in userData) {
  //   //   print("Number: ${user["Number"]}");
  //   //   print("Data: ${user["Data"]}");
  //   //   print(""); // Separate entries
  //   // }
  //
  //   ///
  //
  //   print(_controller.text.split("\n"));
  //
  //   var _a = _controller.text.split("NAMA : ");
  //   print(_a[0]);
  //
  //
  //
  // }


  /// to export list to excel
  Future<void> _exportListToExcel(List<Map<String, dynamic>> dataList) async {
    final excel = Excel.createExcel();
    final sheet = excel['Status-Renew'];

    /// Create headers for your Excel sheet
    final headers = [_col1, _col2, _col3, _col4, _col5, _col6, _col7];
    for (var i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = headers[i];
    }

    /// Populate the Excel sheet with data from your list
    for (var row = 0; row < dataList.length; row++) {
      final rowData = dataList[row];
      for (var col = 0; col < headers.length; col++) {
        final header = headers[col];
        final value = rowData[header];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1)).value = value;
      }
    }

    /// Save the Excel file
    var fileBytes = excel.save(fileName: 'status-renew.xlsx');
  }


}

class PenggunaModel {
  String penggunaid;
  String nama;
  String pakej;
  String tarikh;
  String emel;
  String nohp;
  String dedagang;

  PenggunaModel({
        required this.penggunaid,
        required this.nama,
        required this.pakej,
        required this.tarikh,
        required this.emel,
        required this.nohp,
        required this.dedagang,
      });
}

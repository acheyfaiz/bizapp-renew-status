import 'package:bizapptrack/bloc_status/status_bloc.dart';
import 'package:bizapptrack/bloc_status/user_model.dart';
import 'package:bizapptrack/env.dart';
import 'package:bizapptrack/ui/button.dart';
import 'package:bizapptrack/ui/data_user.dart';
import 'package:bizapptrack/ui/list_to_excel.dart';
import 'package:bizapptrack/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusScreen extends StatelessWidget {
  StatusScreen({super.key});

  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userbloc = BlocProvider.of<StatusBloc>(context);

    return Scaffold(
      backgroundColor: const Color(0xfff0f8ff),
      floatingActionButton:  BizappButton(
        color: Colors.black87,
        title: "Export Excel",
        tapCallback: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const ListToExcel())),
      ),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [

            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(Env.versi, style: const TextStyle(
                  color: Colors.black
              )),
            )
          ],
        ),

      body: LayoutBuilder(
        builder: (context, constraints)=> SingleChildScrollView(
          child: Center(
            child: Column(
              children: [

                const Header(),

                const SizedBox(height: 20),

                FormStatus(constraints: constraints, controller: _usernameController),

                const SizedBox(height: 10),

                /// button
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    BizappButton(
                        color: Colors.green,
                        title: "Enter",
                        tapCallback: (){
                          final username = _usernameController.text;
                          userbloc.add(FetchStatus(username));
                        }),
                    const SizedBox(width: 10),

                    BizappButton(
                        color: Colors.lightBlue[400]!,
                        title: "Paste",
                        tapCallback: () async {
                          await Clipboard.getData(Clipboard.kTextPlain).then((value){
                            _usernameController.text = value?.text ?? "";
                          });
                        }),
                    const SizedBox(width: 10),

                    BizappButton(
                        color: Colors.red[400]!,
                        title: "Clear",
                        tapCallback: () => _usernameController.clear()
                    ),

                  ],
                ),
                const SizedBox(height: 10),

                ResultStatus(constraints: constraints)


              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResultStatus extends StatelessWidget {
  final BoxConstraints constraints;
  const ResultStatus({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusBloc, StatusState>(
      builder: (context, state) {
        if (state is StatusInitial) {
          return const Text('Enter a username');

        } else if (state is StatusLoading) {
          return const CircularProgressIndicator();

        } else if (state is StatusLoaded) {
          final userData = state.profile;
          final stats = state.statistik;

          String accBizappay = "";
          userData.accountBIZAPPAY == "Y" ? accBizappay = "Ya" : accBizappay = "Tiada";

          return Wrap(
            runSpacing: 5,
            children: [

              /// display user profile
              DataUser(children: [
                BizappText(text: "Username:  ${userData.penggunaid}"),
                BizappText(text: "Nama:  ${userData.nama}"),
                BizappText(text: "Pakej:  ${userData.roleid}"),
                BizappText(text: "Tarikh naik taraf:  ${userData.tarikhnaiktaraf}"),
                Text("Tarikh tamat:  ${userData.tarikhtamattempoh}", style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red
                )),

                _tips(userData),
                userData.addonModuleRptDisplay != "-" && userData.addonModuleRptDisplay != "" ?
                BizappText(text: "Basic+ Add On: ${userData.addonModuleRptDisplay}\n") : const SizedBox(),

              ]),
              SizedBox(width: constraints.maxWidth >= 501 ? 50 : 10),

              /// display user statistic
              DataUser(children: [
                BizappText(text: "Rekod Tempahan : ${stats.tOTALORDERDONE}"),
                const SizedBox(height: 10),
                BizappText(text: "Bil. Tempahan : ${stats.tOTALORDER?.replaceAll(",", "")}"),
                const SizedBox(height: 10),
                BizappText(text: "Bil. Ejen : ${stats.cOUNTAGENT}"),
                BizappText(text: "Ada Bizappay : $accBizappay"),
              ])

            ],
          );

        } else if (state is StatusError) {
          return Text('Error: ${state.message}');
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _tips(Profile userData){
    return userData.tarikhtamattempoh != "" ? const Text("* Adakah tarikh tamat backdated?\nJika ya, pakej user ni dah expired\n\n", style: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w300
    )) : const SizedBox();
  }

}


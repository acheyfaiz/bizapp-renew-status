import 'package:bizapptrack/ui/button.dart';
import 'package:bizapptrack/ui/data_user.dart';
import 'package:bizapptrack/env.dart';
import 'package:bizapptrack/ui/list_to_excel.dart';
import 'package:bizapptrack/ui/loading_widget.dart';
import 'package:bizapptrack/viewmodel/status_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
        toolbarHeight: 100,
        title: const Text("Status Renew Bizapp User", style: TextStyle(
          color: Colors.white
        )),
        actions: [

          BizappButton(
            color: Colors.transparent,
            title: "Export to Excel",
            tapCallback: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const ListToExcel())),
          ),

          const SizedBox(width: 20),

          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(Env.versi, style: const TextStyle(
              color: Colors.white
            )),
          )
        ],
      ),

      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: LayoutBuilder(
            builder: (context, constraints){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(height: 20),

                  Wrap(
                    runSpacing: 10,
                    children: [

                      Consumer<StatusController>(
                        builder: (context, model, child)=> SizedBox(
                          width: constraints.maxWidth >= 501 ? MediaQuery.sizeOf(context).width * .5 : MediaQuery.sizeOf(context).width * .9,
                          child: TextFormField(
                            onFieldSubmitted: (val){
                              setState(() {
                                model.call = true;
                              });
                              model.loginServices(context, username: usernameController.text).then((value) {
                                setState(() {
                                  model.call = false;
                                });
                              });
                            },
                            style: const TextStyle(fontSize: 16),
                            keyboardType: TextInputType.emailAddress,
                            validator: (e) => e!.isEmpty ? 'user ID cannot empty' : null,
                            controller: usernameController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                            ],
                            decoration: InputDecoration(
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  IconButton(
                                      onPressed: (){
                                        setState(() {
                                          usernameController.clear();
                                        });
                                      },
                                      icon: const Text("Clear")),
                                  IconButton(
                                      onPressed: () async {
                                        await Clipboard.getData(Clipboard.kTextPlain).then((value){
                                          usernameController.text = value?.text ?? "";
                                        });
                                      },
                                      icon: const Text("Paste")),
                                  IconButton(
                                      onPressed: (){
                                        setState(() {
                                          model.call = true;
                                        });
                                        model.loginServices(context, username: usernameController.text).then((value) {
                                          setState(() {
                                            model.call = false;
                                          });
                                        });
                                      },
                                      icon: const Text("Enter")),

                                ],
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0, style: BorderStyle.solid,
                                ),
                              ),
                              filled: true,
                              labelStyle: const TextStyle(fontSize: 20),
                              labelText: 'Username',
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 20),

                  _body2(constraints),

                  const SizedBox(height: 100),

                ],
              );
            },
          )
        ),
      ),
    );
  }

  Widget _tips(){
    return context.read<StatusController>().tarikhtamat != "" ? const Text("* Adakah tarikh tamat backdated?\nJika ya, pakej user ni dah expired\n\n", style: TextStyle(
      fontSize: 17, fontWeight: FontWeight.w300
    ),) : const SizedBox();
  }

  Widget _body2(BoxConstraints constraints){
    return context.read<StatusController>().call == false ? Consumer<StatusController>(
      builder: (context, provider, child) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Wrap(
              runSpacing: 10,
              children: [

                /// data user
                DataUser(children: [
                  BizappText(text: "Username:  ${provider.username}"),
                  BizappText(text: "Nama:  ${provider.nama}"),
                  BizappText(text: "Pakej:  ${provider.roleid}"),
                  BizappText(text: "Tarikh naik taraf:  ${provider.tarikhnaiktaraf}"),
                  Text("Tarikh tamat:  ${provider.tarikhtamat}", style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red
                  )),

                  _tips(),
                  provider.basicplusonly != "-" && provider.basicplusonly != "" ?
                  BizappText(text: "Basic+ Add On: ${provider.basicplusonly}\n") : const SizedBox(),

                ]),

                SizedBox(width: constraints.maxWidth >= 501 ? 120 : 10),

                /// data rekod
                provider.callDedagang == false ? DataRekod(children: [
                  BizappText(text: "Rekod Tempahan : ${provider.rekodtempahan}"),
                  const SizedBox(height: 10),
                  BizappText(text: "Bil. Tempahan : ${provider.biltempahan}"),
                  const SizedBox(height: 10),
                  BizappText(text: "Bil. Ejen : ${provider.bilEjen}"),
                  BizappText(text: "Ada Bizappay : ${provider.bizappayacc}"),
                ]) : const GetLoad(text: "Load data statistics ..."),

              ],
            ),

            const SizedBox(height: 10),
            const BizappText(text: 'Senarai rekod 5 terakhir: '),

            /// data list
            provider.callRekod == false ?
            provider.listrekod.isEmpty ? const Text('Tiada Rekod', style: TextStyle(
              fontSize: 20,
            ))
                : DataList(listrekod: provider.listrekod)
                : const GetLoad(text: "Load data record ...")

          ],
        );
      },
    )
        : const GetLoad(text: "Load data ...");
  }

}

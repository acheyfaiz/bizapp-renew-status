// import 'package:bizapptrack/ui/button.dart';
// import 'package:bizapptrack/ui/data_user.dart';
// import 'package:bizapptrack/env.dart';
// import 'package:bizapptrack/ui/list_to_excel.dart';
// import 'package:bizapptrack/ui/loading_widget.dart';
// import 'package:bizapptrack/viewmodel/status_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
//
// class TestRenew extends StatefulWidget {
//   const TestRenew({super.key});
//
//   @override
//   State<TestRenew> createState() => _TestRenewState();
// }
//
// class _TestRenewState extends State<TestRenew> {
//
//   TextEditingController usernameController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff0f8ff),
//       floatingActionButton:  BizappButton(
//         color: Colors.black87,
//         title: "Export Excel",
//         tapCallback: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const ListToExcel())),
//       ),
//
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         actions: [
//
//           Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: Text(Env.versi, style: const TextStyle(
//               color: Colors.black
//             )),
//           )
//         ],
//       ),
//
//       body: LayoutBuilder(
//         builder: (context, constraints)=> Consumer<StatusController>(
//           builder: (context, model, child) {
//             return SingleChildScrollView(
//               child: Center(
//                 child: Column(
//                       children: [
//
//                         // const Header(),
//
//                         const SizedBox(height: 20),
//
//                         // FormStatus(constraints: constraints, controller: usernameController),
//                         const SizedBox(height: 10),
//
//                         /// button
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//
//                             BizappButton(
//                               color: Colors.green,
//                               title: "Enter",
//                               tapCallback: (){
//                                 setState(() {
//                                   model.call = true;
//                                 });
//                                 model.loginServices(context, userid: usernameController.text).then((value) {
//                                   setState(() {
//                                     model.call = false;
//                                   });
//                                 });
//                               }),
//                             const SizedBox(width: 10),
//
//                             BizappButton(
//                                 color: Colors.lightBlue[400]!,
//                                 title: "Paste",
//                                 tapCallback: () async {
//                                   await Clipboard.getData(Clipboard.kTextPlain).then((value){
//                                     usernameController.text = value?.text ?? "";
//                                   });
//                                 }),
//                             const SizedBox(width: 10),
//
//                             BizappButton(
//                                 color: Colors.red[400]!,
//                                 title: "Clear",
//                                 tapCallback: () => usernameController.clear()
//                             ),
//
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//
//                         _body2(constraints)
//
//                       ],
//                     ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _tips(){
//     return context.read<StatusController>().tarikhtamat != "" ? const Text("* Adakah tarikh tamat backdated?\nJika ya, pakej user ni dah expired\n\n", style: TextStyle(
//       fontSize: 14, fontWeight: FontWeight.w300
//     ),) : const SizedBox();
//   }
//
//   Widget _body2(BoxConstraints constraints){
//     return context.read<StatusController>().call == false ? Consumer<StatusController>(
//       builder: (context, provider, child) {
//       return Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//
//             Wrap(
//               runSpacing: 5,
//               children: [
//
//                 /// data user
//                 DataUser(children: [
//                   BizappText(text: "Username:  ${provider.username}"),
//                   BizappText(text: "Nama:  ${provider.nama}"),
//                   BizappText(text: "Pakej:  ${provider.roleid}"),
//                   BizappText(text: "Tarikh naik taraf:  ${provider.tarikhnaiktaraf}"),
//                   Text("Tarikh tamat:  ${provider.tarikhtamat}", style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red
//                   )),
//
//                   _tips(),
//                   provider.basicplusonly != "-" && provider.basicplusonly != "" ?
//                   BizappText(text: "Basic+ Add On: ${provider.basicplusonly}\n") : const SizedBox(),
//
//                 ]),
//
//                 SizedBox(width: constraints.maxWidth >= 501 ? 50 : 10),
//
//                 /// data rekod
//                 provider.callDedagang == false ? DataUser(children: [
//                   BizappText(text: "Rekod Tempahan : ${provider.rekodtempahan}"),
//                   const SizedBox(height: 10),
//                   BizappText(text: "Bil. Tempahan : ${provider.biltempahan}"),
//                   const SizedBox(height: 10),
//                   BizappText(text: "Bil. Ejen : ${provider.bilEjen}"),
//                   BizappText(text: "Ada Bizappay : ${provider.bizappayacc}"),
//                 ]) : const GetLoad(text: "Load data statistics ..."),
//
//               ],
//             ),
//
//             const SizedBox(height: 0),
//             const BizappText(text: 'Senarai rekod 5 terakhir: '),
//
//             /// data list
//             provider.callRekod == false ?
//             provider.listrekod.isEmpty ? const Text('Tiada Rekod', style: TextStyle(
//               fontSize: 16,
//             ))
//                 : Center(child: DataList(listrekod: provider.listrekod))
//                 : const GetLoad(text: "Load data record ...")
//
//           ],
//         );
//       },
//     )
//         : const GetLoad(text: "Load data ...");
//   }
//
// }
//
// // class Header extends StatelessWidget {
// //   const Header({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return DecoratedBox(
// //       decoration: BoxDecoration(
// //         color: Colors.grey[300],
// //         borderRadius: BorderRadius.circular(80)
// //       ),
// //       child: const Padding(
// //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //         child: Text("Status Renew Bizapp User", style: TextStyle(
// //          fontSize: 16
// //         )),
// //       ),
// //     );
// //   }
// // }
//
// ///
//
// // class FormStatus extends StatelessWidget {
// //   final BoxConstraints constraints;
// //   final TextEditingController controller;
// //   const FormStatus({super.key, required this.constraints, required this.controller});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       width: constraints.maxWidth >= 501 ? MediaQuery.sizeOf(context).width * .5 : MediaQuery.sizeOf(context).width * .9,
// //       child: TextFormField(
// //         style: const TextStyle(fontSize: 16),
// //         keyboardType: TextInputType.emailAddress,
// //         validator: (e) => e!.isEmpty ? 'username cannot empty' : null,
// //         controller: controller,
// //         autovalidateMode: AutovalidateMode.onUserInteraction,
// //         inputFormatters: <TextInputFormatter>[
// //           FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
// //         ],
// //         decoration: const InputDecoration(
// //           hoverColor: Colors.transparent,
// //           border: OutlineInputBorder(
// //             borderSide: BorderSide(
// //               width: 0, style: BorderStyle.solid,
// //             ),
// //           ),
// //           filled: true,
// //           labelStyle: TextStyle(fontSize: 14),
// //           labelText: 'Username',
// //           fillColor: Colors.white,
// //         ),
// //       ),
// //     );
// //   }
// // }
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

SnackBar snackBarBizapp(String error) {
  return SnackBar(
    onVisible: (){
      HapticFeedback.vibrate().timeout(const Duration(milliseconds: 1500));
      HapticFeedback.heavyImpact();
    },
    duration: const Duration(seconds: 4),
    behavior: SnackBarBehavior.floating,
    content: Text("Error. Sila panggil Faiz (sebelum Faiz takde :p ) : $error", style: const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18, color: Colors.white,
    )),
  );
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(80)
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text("Status Renew Bizapp User", style: TextStyle(
            fontSize: 16
        )),
      ),
    );
  }
}

class FormStatus extends StatelessWidget {
  final BoxConstraints constraints;
  final TextEditingController controller;
  const FormStatus({super.key, required this.constraints, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: constraints.maxWidth >= 501 ? MediaQuery.sizeOf(context).width * .5 : MediaQuery.sizeOf(context).width * .9,
      child: TextFormField(
        style: const TextStyle(fontSize: 16),
        keyboardType: TextInputType.emailAddress,
        validator: (e) => e!.isEmpty ? 'username cannot empty' : null,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
        ],
        decoration: const InputDecoration(
          hoverColor: Colors.transparent,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0, style: BorderStyle.solid,
            ),
          ),
          filled: true,
          labelStyle: TextStyle(fontSize: 14),
          labelText: 'Username',
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
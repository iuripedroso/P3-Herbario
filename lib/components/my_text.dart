import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyText extends StatelessWidget {
  final TextEditingController controller;
  final String textoLabel;
  final String? textoErro;
  final IconData icone;
  final bool obscureText;
  final TextInputType? tipoTeclado;
  final List<TextInputFormatter>? formatadoresEntrada;
  final int maxLinhas;
  final void Function(String)? aoMudar;

  const MyText({
    super.key,
    required this.controller,
    required this.textoLabel,
    required this.icone,
    this.textoErro,
    this.obscureText = false,
    this.tipoTeclado,
    this.formatadoresEntrada,
    this.maxLinhas = 1,
    this.aoMudar,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: aoMudar,
      obscureText: obscureText,
      keyboardType: tipoTeclado,
      inputFormatters: formatadoresEntrada,
      maxLines: maxLinhas,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: textoLabel,
        labelStyle: TextStyle(color: Colors.grey[700]),
        errorText: textoErro,
        prefixIcon: Icon(icone, color: Colors.grey[700]),
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }
}

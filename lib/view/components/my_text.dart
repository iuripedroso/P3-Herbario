import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyText extends StatelessWidget {
  final TextEditingController controlador;
  final String textoLabel;
  final String? textoErro;
  final IconData icone;
  final TextInputType? tipoTeclado;
  final List<TextInputFormatter>? formatadoresEntrada;
  final int maxLinhas;
  final void Function(String)? aoMudar;

  MyText({
    super.key,
    required this.controlador,
    required this.textoLabel,
    this.textoErro,
    required this.icone,
    this.tipoTeclado,
    this.formatadoresEntrada,
    this.maxLinhas = 1,
    this.aoMudar,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controlador,
      onChanged: aoMudar,
      keyboardType: tipoTeclado,
      inputFormatters: formatadoresEntrada,
      maxLines: maxLinhas,
      style: TextStyle(color: Colors.grey[800]),
      decoration: InputDecoration(
        labelText: textoLabel,
        labelStyle: TextStyle(color: Colors.grey[600]),
        errorText: textoErro,
        prefixIcon: Icon(icone, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green[600]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}
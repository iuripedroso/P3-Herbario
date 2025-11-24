import 'package:flutter/material.dart';

class MyDropdown extends StatelessWidget {
  final String textoLabel;
  final String? valor;
  final List<String> itens;
  final String? textoErro;
  final IconData icone;
  final void Function(String?)? aoMudar;

  MyDropdown({
    super.key,
    required this.textoLabel,
    required this.valor,
    required this.itens,
    this.textoErro,
    required this.icone,
    this.aoMudar,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: valor,
      onChanged: aoMudar,
      isExpanded: true,
      style: TextStyle(color: Colors.grey[800]),
      dropdownColor: Colors.white,
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
      items: itens.map<DropdownMenuItem<String>>((String valorItem) {
        return DropdownMenuItem<String>(
          value: valorItem,
          child: Text(valorItem),
        );
      }).toList(),
    );
  }
}
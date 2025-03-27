import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastroForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nomeController;
  final TextEditingController idadeController;
  final VoidCallback onSave;

  const CadastroForm({
    Key? key,
    required this.formKey,
    required this.nomeController,
    required this.idadeController,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: nomeController,
            decoration: InputDecoration(
              labelText: 'Nome',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: idadeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Idade',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Salvar', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/cadastro.dart';
import '../database/db_helper.dart';
import '../widgets/cadastro_form.dart';

class CadastroScreen extends StatefulWidget {
  final Cadastro? cadastro;

  const CadastroScreen({Key? key, this.cadastro}) : super(key: key);

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.cadastro != null) {
      _nomeController.text = widget.cadastro!.nome;
      _idadeController.text = widget.cadastro!.idade.toString();
    }
  }

  Future<void> _salvarCadastro() async {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text;
      final idade = int.tryParse(_idadeController.text) ?? 0;

      if (nome.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro: O campo nome não pode estar vazio.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_idadeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro: O campo idade não pode estar vazio.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (idade <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro: O campo idade deve ser maior que zero.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final novoCadastro = Cadastro(
        id: widget.cadastro?.id,
        nome: nome,
        idade: idade,
      );

      try {
        if (widget.cadastro == null) {
          await DBHelper.inserirCadastro(novoCadastro);
        } else {
          await DBHelper.atualizarCadastro(novoCadastro);
        }
        Navigator.pop(context, true);
      } catch (e) {
        if (e.toString().contains("UNIQUE constraint failed: cadastro.idade")) {
          // Exibe uma mensagem amigável para o erro de unicidade
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro: Já existe um cadastro com essa idade.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          // Exibe outros erros
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar cadastro: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cadastro == null ? 'Novo Cadastro' : 'Editar Cadastro',
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CadastroForm(
              formKey: _formKey,
              nomeController: _nomeController,
              idadeController: _idadeController,
              onSave: _salvarCadastro,
            ),
          ),
        ),
      ),
    );
  }
}

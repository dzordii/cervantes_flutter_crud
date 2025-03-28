import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/db_helper.dart';
import '../models/cadastro.dart';
import 'cadastro_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Cadastro> cadastros = [];
  bool isLoading = true; // Adicionado para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    _carregarCadastros();
  }

  Future<void> _carregarCadastros() async {
    try {
      final lista = await DBHelper.getCadastros();
      setState(() {
        cadastros = lista;
        isLoading = false; // Finaliza o carregamento
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Finaliza o carregamento mesmo em caso de erro
      });
    }
  }

  void _abrirCadastro([Cadastro? cadastro]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroScreen(cadastro: cadastro),
      ),
    );
    _carregarCadastros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Cervantes'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carregamento
          : cadastros.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum cadastro encontrado.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: cadastros.length,
                  itemBuilder: (context, index) {
                    final cadastro = cadastros[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          cadastro.nome,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Idade: ${cadastro.idade}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await DBHelper.deletarCadastro(cadastro.id!);
                              _carregarCadastros();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erro ao deletar cadastro: $e'),
                                ),
                              );
                            }
                          },
                        ),
                        onTap: () => _abrirCadastro(cadastro),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirCadastro(),
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}

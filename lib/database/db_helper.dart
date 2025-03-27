import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

import '../models/cadastro.dart';

class DBHelper {
  static DatabaseFactory _getDatabaseFactory() {
    // Apenas para Desktop
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      if (databaseFactory != databaseFactoryFfi) {
        sqfliteFfiInit(); // Inicializa corretamente
        databaseFactory = databaseFactoryFfi;
      }
      return databaseFactoryFfi;
    } else {
      throw UnsupportedError(
        "Esta aplicação é suportada apenas em plataformas desktop.",
      );
    }
  }

  static Future<Database> get database async {
    final dbFactory = _getDatabaseFactory();
    String path;

    try {
      path = join(await getDatabasesPath(), 'cadastro.db');
    } catch (e) {
      throw Exception("Erro ao obter o caminho do banco de dados: $e");
    }

    try {
      return await dbFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            print("Criando tabelas...");
            await db.execute('''
              CREATE TABLE IF NOT EXISTS cadastro (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT NOT NULL,
                idade INTEGER NOT NULL CHECK (idade > 0),
                UNIQUE(idade) ON CONFLICT FAIL
              )
            ''');
            await db.execute('''
              CREATE TABLE IF NOT EXISTS log (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                dataHora TEXT NOT NULL,
                operacao TEXT NOT NULL
              )
            ''');
          },
          onOpen: (db) async {
            print("Banco de dados aberto.");
          },
        ),
      );
    } catch (e) {
      throw Exception("Erro ao abrir o banco de dados: $e");
    }
  }

  static Future<int> inserirCadastro(Cadastro cadastro) async {
    final db = await database;
    try {
      int id = await db.insert('cadastro', cadastro.toMap());
      await db.insert('log', {
        'dataHora': DateTime.now().toIso8601String(),
        'operacao': 'Insert',
      });
      print("Cadastro inserido: ${cadastro.toMap()}");
      return id;
    } catch (e) {
      throw Exception("Erro ao inserir cadastro: $e");
    }
  }

  static Future<List<Cadastro>> getCadastros() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('cadastro');
      print("Registros encontrados: $maps");
      return List.generate(maps.length, (i) => Cadastro.fromMap(maps[i]));
    } catch (e) {
      throw Exception("Erro ao buscar cadastros: $e");
    }
  }

  static Future<int> atualizarCadastro(Cadastro cadastro) async {
    final db = await database;
    try {
      int resultado = await db.update(
        'cadastro',
        cadastro.toMap(),
        where: 'id = ?',
        whereArgs: [cadastro.id],
      );

      if (resultado > 0) {
        await db.insert('log', {
          'dataHora': DateTime.now().toIso8601String(),
          'operacao': 'Update',
        });
      }

      print("Cadastro atualizado: ${cadastro.toMap()}");
      return resultado;
    } catch (e) {
      throw Exception("Erro ao atualizar cadastro: $e");
    }
  }

  static Future<int> deletarCadastro(int id) async {
    final db = await database;
    try {
      int resultado = await db.delete(
        'cadastro',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (resultado > 0) {
        await db.insert('log', {
          'dataHora': DateTime.now().toIso8601String(),
          'operacao': 'Delete',
        });
      }

      print("Cadastro deletado: ID $id");
      return resultado;
    } catch (e) {
      throw Exception("Erro ao deletar cadastro: $e");
    }
  }
}

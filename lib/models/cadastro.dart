class Cadastro {
  final int? id;
  final String nome;
  final int idade;

  Cadastro({this.id, required this.nome, required this.idade});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'idade': idade};
  }

  factory Cadastro.fromMap(Map<String, dynamic> map) {
    return Cadastro(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      idade: map['idade'] as int,
    );
  }
}

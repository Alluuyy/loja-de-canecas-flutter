class Produto {
  final int? id;
  final String nome;
  final String descricao;
  final double preco;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'].toString(),
      descricao: json['descricao'].toString(),
      preco: double.parse(json['preco'].toString()),
    );
  }
}
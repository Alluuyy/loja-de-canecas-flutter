import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/clientes.dart';
import '../models/produtos.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:3000/api";

  // clientes get
  Future<List<Cliente>> getClientes() async {
    final response = await http.get(Uri.parse("$baseUrl/clientes"));

    print("STATUS CLIENTES: ${response.statusCode}");
    print("BODY CLIENTES: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded.map<Cliente>((e) => Cliente.fromJson(e)).toList();
      }

      if (decoded is Map && decoded['data'] is List) {
        return decoded['data']
            .map<Cliente>((e) => Cliente.fromJson(e))
            .toList();
      }

      throw Exception("Formato inesperado de JSON para clientes");
    } else {
      throw Exception("Erro ao carregar clientes");
    }
  }

  // clientes post
  Future<void> criarCliente(Cliente cliente) async {
    final response = await http.post(
      Uri.parse("$baseUrl/clientes"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": cliente.nome,
        "sobrenome": cliente.sobrenome,
        "email": cliente.email,
        "idade": cliente.idade,
        "foto": cliente.foto,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Erro ao criar cliente");
    }
  }

  // clientes put
  Future<void> atualizarCliente(Cliente cliente) async {
    final response = await http.put(
      Uri.parse("$baseUrl/clientes/${cliente.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": cliente.nome,
        "sobrenome": cliente.sobrenome,
        "email": cliente.email,
        "idade": cliente.idade,
        "foto": cliente.foto,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar cliente");
    }
  }

  // clientes delete
  Future<void> deletarCliente(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/clientes/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao deletar cliente");
    }
  }

  // produtos get
  Future<List<Produto>> getProdutos() async {
    final response = await http.get(Uri.parse("$baseUrl/produtos"));

    print("STATUS PRODUTOS: ${response.statusCode}");
    print("BODY PRODUTOS: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded.map<Produto>((e) => Produto.fromJson(e)).toList();
      }

      if (decoded is Map && decoded['data'] is List) {
        return decoded['data']
            .map<Produto>((e) => Produto.fromJson(e))
            .toList();
      }

      throw Exception("Formato inesperado de JSON para produtos");
    } else {
      throw Exception("Erro ao carregar produtos");
    }
  }

  // produtos post
  Future<void> criarProduto(Produto produto) async {
    final response = await http.post(
      Uri.parse("$baseUrl/produtos"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": produto.nome,
        "descricao": produto.descricao,
        "preco": produto.preco,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Erro ao criar produto");
    }
  }

  // produtos put
  Future<void> atualizarProduto(Produto produto) async {
    final response = await http.put(
      Uri.parse("$baseUrl/produtos/${produto.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": produto.nome,
        "descricao": produto.descricao,
        "preco": produto.preco,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar produto");
    }
  }

  // produtos delete
  Future<void> deletarProduto(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/produtos/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao deletar produto");
    }
  }
}

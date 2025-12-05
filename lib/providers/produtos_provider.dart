import 'package:flutter/material.dart';
import '../models/produtos.dart';
import '../services/api_service.dart';

class ProdutosProvider extends ChangeNotifier {
  final ApiService api = ApiService();

  List<Produto> produtos = [];
  bool loading = false;

  // get
  Future<void> carregarProdutos() async {
    loading = true;
    notifyListeners();

    try {
      produtos = await api.getProdutos();
    } catch (e) {
      print("Erro ao carregar produtos: $e");
    }

    loading = false;
    notifyListeners();
  }

  // post
  Future<void> adicionarProduto(Produto produto) async {
    await api.criarProduto(produto);
    await carregarProdutos();
  }

  // put
  Future<void> atualizarProduto(Produto produto) async {
    await api.atualizarProduto(produto);
    await carregarProdutos();
  }

  // delete
  Future<void> removerProduto(int id) async {
    await api.deletarProduto(id);
    await carregarProdutos();
  }
}

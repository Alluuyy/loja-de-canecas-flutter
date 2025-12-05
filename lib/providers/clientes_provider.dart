import 'package:flutter/material.dart';
import '../models/clientes.dart';
import '../services/api_service.dart';

class ClientesProvider extends ChangeNotifier {
  final ApiService api = ApiService();

  List<Cliente> clientes = [];
  bool loading = false;

  // get
  Future<void> carregarClientes() async {
    loading = true;
    notifyListeners();

    try {
      clientes = await api.getClientes();
    } catch (e) {
      print("Erro ao carregar clientes: $e");
    }

    loading = false;
    notifyListeners();
  }

  // post
  Future<void> adicionarCliente(Cliente cliente) async {
    try {
      await api.criarCliente(cliente);
      await carregarClientes();
    } catch (e) {
      print("Erro ao criar cliente: $e");
    }
  }

  // put
  Future<void> atualizarCliente(Cliente cliente) async {
    try {
      await api.atualizarCliente(cliente);
      await carregarClientes();
    } catch (e) {
      print("Erro ao atualizar cliente: $e");
    }
  }

  // delete
  Future<void> deletarCliente(int id) async {
    try {
      await api.deletarCliente(id);
      await carregarClientes();
    } catch (e) {
      print("Erro ao deletar cliente: $e");
    }
  }
}
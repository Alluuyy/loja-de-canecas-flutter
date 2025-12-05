import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/produtos_provider.dart';
import '../models/produtos.dart';
import 'produto_form_page.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProdutosProvider>(context, listen: false)
          .carregarProdutos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProdutosProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Produtos")),

      // botao de add
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProdutoFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.produtos.isEmpty
              ? const Center(child: Text("Nenhum produto encontrado"))
              : ListView.builder(
                  itemCount: provider.produtos.length,
                  itemBuilder: (_, index) {
                    final Produto p = provider.produtos[index];

                    return ListTile(
                      title: Text(p.nome),
                      subtitle:
                          Text("R\$ ${p.preco.toStringAsFixed(2)}"),

                      // botões editar e excluir
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // editar
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProdutoFormPage(produto: p),
                                ),
                              );
                            },
                          ),

                          // excluir
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Confirmar"),
                                  content: const Text(
                                      "Deseja realmente excluir este produto?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Excluir"),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmar == true) {
                                await provider
                                    .removerProduto(p.id!);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Produto excluído com sucesso"),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

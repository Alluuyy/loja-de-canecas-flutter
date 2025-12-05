import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import 'clientes_form_page.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClientesProvider>(context, listen: false)
          .carregarClientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClientesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Clientes")),

      // botão de add
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ClienteFormPage()),
          ).then((_) {
            Provider.of<ClientesProvider>(context, listen: false)
                .carregarClientes();
          });
        },
        child: const Icon(Icons.add),
      ),

      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.clientes.isEmpty
              ? const Center(child: Text("Nenhum cliente encontrado"))
              : ListView.builder(
                  itemCount: provider.clientes.length,
                  itemBuilder: (_, index) {
                    final c = provider.clientes[index];

                    return ListTile(
                      title: Text("${c.nome} ${c.sobrenome}"),
                      subtitle: Text(c.email),

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
                                  builder: (_) => ClienteFormPage(cliente: c),
                                ),
                              ).then((_) {
                                Provider.of<ClientesProvider>(context,
                                        listen: false)
                                    .carregarClientes();
                              });
                            },
                          ),

                          // excluir
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title:
                                      const Text("Confirmar Exclusão"),
                                  content: const Text(
                                      "Deseja realmente excluir este cliente?"),
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
                                await provider.deletarCliente(c.id!);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Cliente excluído com sucesso"),
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
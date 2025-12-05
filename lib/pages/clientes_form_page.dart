import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/clientes.dart';
import '../providers/clientes_provider.dart';

class ClienteFormPage extends StatefulWidget {
  final Cliente? cliente;

  const ClienteFormPage({super.key, this.cliente});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late TextEditingController _sobrenomeController;
  late TextEditingController _emailController;
  late TextEditingController _idadeController;
  late TextEditingController _fotoController;

  @override
  void initState() {
    super.initState();

    _nomeController =
        TextEditingController(text: widget.cliente?.nome ?? "");
    _sobrenomeController =
        TextEditingController(text: widget.cliente?.sobrenome ?? "");
    _emailController =
        TextEditingController(text: widget.cliente?.email ?? "");
    _idadeController =
        TextEditingController(text: widget.cliente?.idade?.toString() ?? "");
    _fotoController =
        TextEditingController(text: widget.cliente?.foto ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClientesProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente == null
            ? "Cadastrar Cliente"
            : "Editar Cliente"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o nome" : null,
              ),

              const SizedBox(height: 12),

              // sobrenome
              TextFormField(
                controller: _sobrenomeController,
                decoration: const InputDecoration(labelText: "Sobrenome"),
                validator: (value) => value == null || value.isEmpty
                    ? "Informe o sobrenome"
                    : null,
              ),

              const SizedBox(height: 12),

              // email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe o email";
                  }
                  if (!value.contains("@")) {
                    return "Email inválido";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // idade
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(labelText: "Idade"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return null;
                  final idade = int.tryParse(value);
                  if (idade == null || idade < 0) {
                    return "Idade inválida";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // foto url
              TextFormField(
                controller: _fotoController,
                decoration: const InputDecoration(labelText: "Foto (URL)"),
              ),

              const SizedBox(height: 24),

              // botao salvar
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final cliente = Cliente(
                      id: widget.cliente?.id,
                      nome: _nomeController.text,
                      sobrenome: _sobrenomeController.text,
                      email: _emailController.text,
                      idade: _idadeController.text.isEmpty
                          ? null
                          : int.parse(_idadeController.text),
                      foto: _fotoController.text.isEmpty
                          ? null
                          : _fotoController.text,
                    );

                    try {
                      if (widget.cliente == null) {
                        await provider.adicionarCliente(cliente);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cliente cadastrado com sucesso"),
                          ),
                        );
                      } else {
                        await provider.atualizarCliente(cliente);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cliente atualizado com sucesso"),
                          ),
                        );
                      }

                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Erro: $e")),
                      );
                    }
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
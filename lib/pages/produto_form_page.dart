import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produtos.dart';
import '../providers/produtos_provider.dart';

class ProdutoFormPage extends StatefulWidget {
  final Produto? produto;

  const ProdutoFormPage({super.key, this.produto});

  @override
  State<ProdutoFormPage> createState() => _ProdutoFormPageState();
}

class _ProdutoFormPageState extends State<ProdutoFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _precoController;

  @override
  void initState() {
    super.initState();

    _nomeController =
        TextEditingController(text: widget.produto?.nome ?? "");
    _descricaoController =
        TextEditingController(text: widget.produto?.descricao ?? "");
    _precoController = TextEditingController(
        text: widget.produto?.preco.toString() ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProdutosProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto == null
            ? "Cadastrar Produto"
            : "Editar Produto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe o nome";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // descrição
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "Descrição"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe a descrição";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // preço
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(labelText: "Preço"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe o preço";
                  }

                  final preco = double.tryParse(value.replaceAll(",", "."));
                  if (preco == null) {
                    return "Preço inválido";
                  }

                  if (preco <= 0) {
                    return "Preço deve ser maior que zero";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              // botão salvar
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final produto = Produto(
                      id: widget.produto?.id,
                      nome: _nomeController.text,
                      descricao: _descricaoController.text,
                      preco: double.parse(
                          _precoController.text.replaceAll(",", ".")),
                    );

                    try {
                      if (widget.produto == null) {
                        await provider.adicionarProduto(produto);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Produto cadastrado com sucesso")),
                        );
                      } else {
                        await provider.atualizarProduto(produto);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Produto atualizado com sucesso")),
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

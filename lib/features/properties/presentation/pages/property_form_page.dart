import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../properties/data/models/property.dart';
import '../../../properties/presentation/providers/property_provider.dart';

class PropertyFormPage extends StatefulWidget {
  const PropertyFormPage({super.key});

  @override
  State<PropertyFormPage> createState() => _PropertyFormPageState();
}

class _PropertyFormPageState extends State<PropertyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _address = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  String? _imagePath;
  Property? _editing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg is Property && _editing == null) {
      _editing = arg;
      _title.text = arg.title;
      _address.text = arg.address;
      _description.text = arg.description ?? '';
      _price.text = arg.price.toStringAsFixed(2);
      _imagePath = arg.imagePath;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _address.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final res = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1600);
    if (res != null) setState(() => _imagePath = res.path);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<PropertyProvider>();
    final price = double.tryParse(_price.text.replaceAll(',', '.')) ?? 0;
    final data = Property(
      id: _editing?.id,
      title: _title.text.trim(),
      address: _address.text.trim(),
      description: _description.text.trim().isEmpty ? null : _description.text.trim(),
      price: price,
      imagePath: _imagePath,
    );
    if (_editing == null) {
      await provider.add(data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inmueble creado')));
    } else {
      await provider.edit(data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cambios guardados')));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editing == null ? 'Nuevo inmueble' : 'Editar inmueble'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey.shade600),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _imagePath == null
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 32),
                                SizedBox(height: 8),
                                Text('Agregar imagen (opcional)')
                              ],
                            ),
                          )
                        : Image.file(File(_imagePath!), fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título *'),
                validator: (v) => v!.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(labelText: 'Dirección *'),
                validator: (v) => v!.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descripción *'),
                validator: (v) => v!.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Precio *'),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return 'Requerido';
                  final d = double.tryParse(t.replaceAll(',', '.'));
                  if (d == null || d < 0) return 'Precio inválido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

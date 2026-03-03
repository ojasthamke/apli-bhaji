import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/area_model.dart';
import '../providers/area_provider.dart';

class AddAreaScreen extends ConsumerStatefulWidget {
  final Area? area;
  const AddAreaScreen({super.key, this.area});

  @override
  ConsumerState<AddAreaScreen> createState() => _AddAreaScreenState();
}

class _AddAreaScreenState extends ConsumerState<AddAreaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.area?.name);
    _numberController = TextEditingController(text: widget.area?.areaNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final area = Area(
        id: widget.area?.id,
        name: _nameController.text.trim(),
        areaNumber: _numberController.text.trim(),
        createdAt: widget.area?.createdAt ?? DateTime.now(),
      );

      if (widget.area == null) {
        ref.read(areasProvider.notifier).addArea(area);
      } else {
        ref.read(areasProvider.notifier).updateArea(area);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.area == null ? 'Add Area' : 'Edit Area'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Area Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Area Name *',
                  hintText: 'e.g. Downtown, Sector 5',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: 'Area Number *',
                  hintText: 'e.g. 101, A-1',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Number is required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: Text(widget.area == null ? 'Save Area' : 'Update Area'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

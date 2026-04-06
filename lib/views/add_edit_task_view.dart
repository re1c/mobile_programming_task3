import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';

class AddEditTaskView extends StatefulWidget {
  final Task? task;

  const AddEditTaskView({super.key, this.task});

  @override
  State<AddEditTaskView> createState() => _AddEditTaskViewState();
}

class _AddEditTaskViewState extends State<AddEditTaskView> {
  final _controller = TaskController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Isi field secara otomatis kalau sedang dalam mode edit.
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.task != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        isEditing ? 'Ubah Tugas' : 'Tambah Tugas Baru',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => 
                  (value == null || value.isEmpty) ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (isEditing) {
                // Update data yang sudah ada.
                final task = widget.task!
                  ..title = _titleController.text
                  ..description = _descController.text;
                _controller.updateTask(task);
              } else {
                // Tambah data tugas baru.
                _controller.addTask(
                  _titleController.text, 
                  _descController.text,
                );
              }
              Navigator.pop(context);
            }
          },
          child: Text(
            isEditing ? 'Simpan Perubahan' : 'Tambah Tugas',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

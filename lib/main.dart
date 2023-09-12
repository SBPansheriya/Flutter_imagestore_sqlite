import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dbhelper.dart';
import 'item.dart';

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _imagePath;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late List<Item> _items;

  @override
  void initState() {
    super.initState();
    _imagePath = '';
    _items = [];
    _fetchItems();
  }

  Future<void> _selectImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _submitForm() async {
    // if (_formKey.currentState!.validate()) {
      final item = Item(
        id: 0,
        title: _titleController.text,
        description: _descriptionController.text,
        imagePath: _imagePath,
      );

      final dbHelper = DbHelper.instance;
      await dbHelper.insertItem(item);

      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _imagePath = '';
      });
    // }
  }

  Future<void> _fetchItems() async {
    final dbHelper = DbHelper.instance;
    final items = await dbHelper.getItems();
    setState(() {
      _items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image and Data Upload'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.description),
            leading: Image.file(File(item.imagePath)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          insertdailog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future insertdailog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Insert Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                      radius: 50,
                      // ignore: unrelated_type_equality_checks
                      child: _imagePath.isEmpty
                          ? const Icon(Icons.person)
                          : Image.file(
                              File(_imagePath),
                              fit: BoxFit.fill,
                            )),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Choose Profile Photo",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton.icon(
                                            onPressed: () {
                                              _selectImage(ImageSource.gallery);
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(Icons.image),
                                            label: const Text("Gallery")),
                                        ElevatedButton.icon(
                                            onPressed: () {
                                              _selectImage(ImageSource.camera);
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(Icons.camera_alt),
                                            label: const Text("Camera")),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          child: const Icon(Icons.camera_alt,
                              color: Colors.cyan, size: 25))),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      );
}

// Padding(
// padding: const EdgeInsets.all(16.0),
// child: Form(
// key: _formKey,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// CircleAvatar(
// radius: 50,
// child:  _imagePath.isEmpty ? const Icon(Icons.person) : Image.file(File(_imagePath),fit: BoxFit.fill,)
// ),
// ElevatedButton(
// onPressed: _selectImage,
// child: const Text('Select Image'),
// ),
// const SizedBox(height: 16.0),
// TextFormField(
// controller: _titleController,
// decoration: const InputDecoration(labelText: 'Title'),
// validator: (value) {
// if (value == null || value.isEmpty) {
// return 'Please enter a title';
// }
// return null;
// },
// ),
// TextFormField(
// controller: _descriptionController,
// decoration: const InputDecoration(labelText: 'Description'),
// validator: (value) {
// if (value == null || value.isEmpty) {
// return 'Please enter a description';
// }
// return null;
// },
// ),
// const SizedBox(height: 16.0),
// ElevatedButton(
// onPressed: _submitForm,
// child: const Text('Submit'),
// ),
// const SizedBox(height: 16.0),
// Expanded(
// child: FutureBuilder<List<Item>>(
// future: DbHelper.instance.getItems(),
// builder: (context, snapshot) {
// if (snapshot.connectionState == ConnectionState.waiting) {
// return const CircularProgressIndicator();
// } else if (snapshot.hasError) {
// return Text('Error: ${snapshot.error}');
// } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// return const Text('No data available.');
// } else {
// // final items = snapshot.data!;
// return ListView.builder(
// itemCount: _items.length,
// itemBuilder: (context, index) {
// final item = _items[index];
// return ListTile(
// title: Text(item.title),
// subtitle: Text(item.description),
// leading: Image.file(File(item.imagePath)),
// );
// },
// );
// }
// },
// ),
// ),
// ],
// ),
// ),
// ),

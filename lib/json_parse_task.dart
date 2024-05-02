import 'dart:convert';
import 'package:flutter/material.dart';

import 'androi_versions.dart';

class JsonParseTask extends StatefulWidget {
  const JsonParseTask({super.key});

  @override
  State<JsonParseTask> createState() => _JsonParseTaskState();
}

class _JsonParseTaskState extends State<JsonParseTask> {
  final String input1 = '''
    [
      {"id":1,"title":"Gingerbread"},
      {"id":2,"title":"Jellybean"},
      {"id":3,"title":"KitKat"},
      {"id":4,"title":"Lollipop"},
      {"id":5,"title":"Pie"},
      {"id":6,"title":"Oreo"},
      {"id":7,"title":"Nougat"}
    ]
  ''';

  final String input2 = '''
    [
      {"id":1,"title":"Gingerbread"},
      {"id":2,"title":"Jellybean"},
      {"id":3,"title":"KitKat"},
      {"id":8,"title":"Froyo"},
      {"id":9,"title":"Éclair"},
      {"id":10,"title":"Donut"},
      {"id":4,"title":"Lollipop"},
      {"id":5,"title":"Pie"},
      {"id":6,"title":"Oreo"},
      {"id":7,"title":"Nougat"}
    ]
  ''';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  String searchedTitle = '';
  List<AndroidVersion> dataTableData = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String searchById(int id) {
    var jsonData = parseJson(input1);
    for (var item in jsonData) {
      if (item.id == id) {
        return item.title!;
      }
    }
    return 'Not found';
  }

  List<AndroidVersion> parseJson(String jsonInput) {
    List<dynamic> data = jsonDecode(jsonInput);
    return data.map((item) => AndroidVersion.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Parse Task'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Searched Title: $searchedTitle',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _searchController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Search Id is Empty";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Search by ID',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            int id = int.parse(_searchController.text);
                            String title = searchById(id);
                            setState(() {
                              searchedTitle = title;
                            });
                          }
                        },
                        child: const Text('Search'),
                      )
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    dataTableData = parseJson(input1);
                  });
                },
                child: const Text('Parse Input 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    dataTableData = parseJson(input2);
                  });
                },
                child: const Text('Parse Input 2'),
              ),
              DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Title')),
                ],
                rows: dataTableData.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item.id.toString())),
                    DataCell(Text(item.title ?? '')),
                  ]);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
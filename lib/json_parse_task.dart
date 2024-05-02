import 'package:flutter/material.dart';
import 'dart:convert';

class JsonParseTask extends StatefulWidget {
  const JsonParseTask({super.key});

  @override
  State<JsonParseTask> createState() => _JsonParseTaskState();
}

class _JsonParseTaskState extends State<JsonParseTask> {
  final String input1 = '''
    [
      {"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},
      [{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]
    ]
  ''';

  final String input2 = '''
    [
      {"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},
      {"0":{"id":8,"title":"Froyo"},"2":{"id":9,"title":"Éclair"},"3":{"id":10,"title":"Donut"}},
      [{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]
    ]
  ''';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  String searchedTitle = '';
  List<Map<String, dynamic>> dataTableData = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
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
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    dataTableData = parseJson(input1);
                    print(dataTableData);
                  });
                },
                child: const Text('Parse Input 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    dataTableData = parseJson(input2);
                    print(dataTableData);
                  });
                },
                child: const Text('Parse Input 2'),
              ),
              DataTable(
                dividerThickness: 3,
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Title')),
                ],
                rows: dataTableData.map((item) {
                  final id = item['id'];
                  final title = item['title'];
                  return DataRow(cells: [
                    DataCell(Text(id.toString())),
                    DataCell(Text(title.toString())),
                  ]);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }


  String searchById(int id) {
    var jsonData = parseJson(input1);
    for (var item in jsonData) {
      if (item['id'] == id) {
        return item['title'];
      }
    }
    return 'Not found';
  }

  List<Map<String, dynamic>> parseJson(String jsonInput) {
    List<dynamic> data = jsonDecode(jsonInput);
    List<Map<String, dynamic>> result = [];

    for (var item in data) {
      if (item is Map<String, dynamic>) {
        result.addAll(item.values.map((e) => Map<String, dynamic>.from(e)));
      } else if (item is List<dynamic>) {
        result.addAll(item.map((e) => Map<String, dynamic>.from(e)));
      }
    }
    return result;
  }
}
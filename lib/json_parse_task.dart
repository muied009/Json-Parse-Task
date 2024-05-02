import 'dart:convert';
import 'package:flutter/material.dart';

import 'androi_versions.dart';

class JsonParseTask extends StatefulWidget {
  const JsonParseTask({super.key});

  @override
  State<JsonParseTask> createState() => _JsonParseTaskState();
}

class _JsonParseTaskState extends State<JsonParseTask> {
  final String inputJson1 = '''
    [{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},[{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]
  ''';

  final String inputJson2 = '''
    [{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},{"0":{"id":8,"title":"Froyo"},"2":{"id":9,"title":"Éclair"},"3":{"id":10,"title":"Donut"}},[{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]
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
    var jsonData = parseJson(inputJson1);
    for (var item in jsonData) {
      if (item.id == id) {
        return item.title;
      }
    }
    return 'Not found';
  }

  List<AndroidVersion> parseJson(String jsonInput) {
    List<dynamic> data = jsonDecode(jsonInput);
    List<AndroidVersion> result = [];

    // Parse the object containing nested objects
    Map<String, dynamic> objectData = Map<String, dynamic>.from(data[0]);
    int lastParsedIndex = -1;
    objectData.forEach((key, value) {
      int currentIndex = int.parse(key);
      // Insert empty items for missing indices
      for (int i = lastParsedIndex + 1; i < currentIndex; i++) {
        result.add(AndroidVersion(id: i, title: ''));
      }
      result.add(AndroidVersion.fromJson(value));
      lastParsedIndex = currentIndex;
    });

    // Parse the array of objects, if present
    if (data.length > 1) {
      dynamic secondData = data[1];
      if (secondData is List) {
        List<dynamic> arrayData = secondData;
        arrayData.forEach((value) {
          result.add(AndroidVersion.fromJson(value));
        });
      } else if (secondData is Map) {
        Map<String, dynamic> secondObject = Map<String, dynamic>.from(secondData);
        int lastParsedIndexInSecond = -1;
        secondObject.forEach((key, value) {
          int currentIndex = int.parse(key);
          // Insert empty items for missing indices
          for (int i = lastParsedIndexInSecond + 1; i < currentIndex; i++) {
            result.add(AndroidVersion(id: i, title: ''));
          }
          result.add(AndroidVersion.fromJson(value));
          lastParsedIndexInSecond = currentIndex;
        });
      }
    }

    // If there's additional data after the second item, parse it as well
    for (int i = 2; i < data.length; i++) {
      dynamic additionalData = data[i];
      if (additionalData is List) {
        List<dynamic> arrayData = additionalData;
        arrayData.forEach((value) {
          result.add(AndroidVersion.fromJson(value));
        });
      }
    }
    return result;
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
                    dataTableData = parseJson(inputJson1);
                    print(dataTableData);
                  });
                },
                child: const Text('Parse Input 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    dataTableData = parseJson(inputJson2);
                  });
                },
                child: const Text('Parse Input 2'),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                ),
                itemCount: dataTableData.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = dataTableData[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title ?? ''),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
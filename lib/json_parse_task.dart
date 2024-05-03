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

    /// This line decodes the JSON string into a list of dynamic objects. The dynamic type is used here because
    /// JSON data can contain various types of values such as maps, lists, strings, numbers, etc.
    List<dynamic> data = jsonDecode(jsonInput);

    /// this line initializes an empty list to store the parsed AndroidVersion objects.
    List<AndroidVersion> result = [];

    /// This variable keeps track of the last parsed index while iterating through the JSON data.
    int lastParsedIndex = -1;

    ///This loop iterates over each item in the JSON data.
    for (var item in data) {

      // Parse object containing nested objects
      ///This condition checks if the current item is a map (object) with string keys and dynamic values,
      /// indicating it contains nested objects.
      if (item is Map<String, dynamic>) {

        ///If the item is a map, this loop iterates over each key-value pair in the map.
        item.forEach((key, value) {

          ///This line parses the key (which represents the index) as an integer to determine the current index.
          int currentIndex = int.parse(key);

          ///This loop inserts empty AndroidVersion objects for any missing indices between the last parsed index and the current index.
          ///It ensures that the list is filled with consecutive indices.
          for (int i = lastParsedIndex + 1; i < currentIndex; i++) {
            result.add(AndroidVersion(id: i, title: ''));
          }

          ///this line constructs an AndroidVersion object from the nested object (value) and adds it to the result list.
          result.add(AndroidVersion.fromJson(value));

          ///After processing the current index, this line updates the lastParsedIndex variable.
          lastParsedIndex = currentIndex;
        });
      }

      // Parse array of objects
      ///This condition checks if the current item is a list, indicating it contains an array of objects.
      else if (item is List<dynamic>) {

        ///Inside this loop, each item in the array is processed.
        item.forEach((value) {

          ///This line constructs an AndroidVersion object from each item in the array and adds it to the result list.
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
                              _searchController.text = '';
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
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  var _entredName = '';
  var _entredQuantity = 1;
  var _selectedCtegory = categories[Categories.vegetables]!;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //url of our database
      final url = Uri.https(
        'shoppinglistapp-f1b43-default-rtdb.firebaseio.com',
        'shopping-list.json',
      );
      //Post req
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _entredName,
          'quantity': _entredQuantity,
          'category': _selectedCtegory.title,
        }),
      );

      final Map<String, dynamic> resData = jsonDecode(response.body);

      if (!context.mounted) {
        return;
      }
      Navigator.pop(
          context,
          GroceryItem(
            id: resData['name'],
            name: _entredName,
            quantity: _entredQuantity,
            category: _selectedCtegory,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar
      appBar: AppBar(
        title: const Text('Add new item'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                //Name Input
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                  ),
                  //Validation
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _entredName = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //Quantity input
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Quantity'),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _entredQuantity.toString(),
                        //Validation
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be valid, positive number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _entredQuantity = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    //DropDownButton to select the category
                    Expanded(
                      child: DropdownButtonFormField(
                        value: _selectedCtegory,
                        items: [
                          //Loop on all categories
                          for (final category in categories.entries)
                            DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    //Box color
                                    Container(
                                      width: 14,
                                      height: 14,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    //Name of the category
                                    Text(category.value.title),
                                  ],
                                ))
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCtegory = value!;
                          });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 13,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: _saveItem,
                      child: const Text('Add Item'),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

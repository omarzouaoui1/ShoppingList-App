import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
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
            child: Column(
          children: [
            //Name Input
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
              validator: (value) {
                return 'Demo...';
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
                    initialValue: '1',
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                //DropDownButton to select the category
                Expanded(
                  child: DropdownButtonFormField(
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
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            const SizedBox(height: 13,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {},
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

import 'package:flutter/material.dart';


class TemplateEditor extends StatefulWidget {
  @override
  _TemplateEditorState createState() => _TemplateEditorState();
}

class _TemplateEditorState extends State<TemplateEditor> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Save functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              // Copy functionality here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: Text('Auto'),
                selected: true,
                onSelected: (bool selected) {
                  // Handle Auto tab selection
                },
              ),
              ChoiceChip(
                label: Text('Tele-op'),
                selected: false,
                onSelected: (bool selected) {
                  // Handle Tele-op tab selection
                },
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                ComponentItem(
                  count: _counter,
                  onIncrement: () {
                    setState(() {
                      _counter++;
                    });
                  },
                  onDecrement: () {
                    setState(() {
                      _counter--;
                    });
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add item functionality
            },
            child: Text('Add item'),
          ),
        ],
      ),
    );
  }
}

class ComponentItem extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ComponentItem({
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.drag_handle),
            Spacer(),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onIncrement,
            ),
            Text('$count'),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: onDecrement,
            ),
          ],
        ),
      ),
    );
  }
}

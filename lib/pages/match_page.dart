import 'package:flutter/material.dart';


import 'components/nav.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Match'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: matchPage(),
    );
  }
}

Widget matchPage(){
  return Container(
    padding: const EdgeInsets.all(10),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: modules(),
      ),
    ),
  );
}


// Rename the function to be more descriptive of its purpose.
List<Widget> modules() {
  return [ // Use a more descriptive label and hint text.
    const TextField(
      decoration: InputDecoration(
        labelText: 'Match Event Key (e.g. 2023cmptx)',
        hintText: 'Enter the unique key for the match event',
      ),
    ),
  ];
}
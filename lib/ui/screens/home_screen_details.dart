import 'package:flutter/material.dart';
import 'package:project/models/item.dart';

class HomeScreenDetails extends StatelessWidget {
  final Item item;

  const HomeScreenDetails({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.id.toString()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text("title"),
              Text(item.title),
              SizedBox(
                height: 20,
              ),
              Text("body"),
              Text(item.body),
              SizedBox(
                height: 20,
              ),
              Text("Usesr id"),
              Text(item.userId.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

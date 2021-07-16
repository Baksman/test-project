import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/material.dart';
import 'package:project/datasources/source_response/error.dart';
import 'package:project/models/item.dart';
import 'package:project/ui/screens/home_screen_details.dart';
import 'package:project/viewmodel/items_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  ItemViewmodel itemViewmodel;
  @override
  void initState() {
    itemViewmodel = Provider.of<ItemViewmodel>(context,listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: FutureBuilder<dz.Either<AppError, List<Item>>>(
          future: itemViewmodel.getItem(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data.fold(
              (AppError error) => Center(child: Text(error.message)),
              (List<Item> items) => Items(),
            );
          },
        ),
      ),
    );
  }
}

class Items extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itemViewmodel = Provider.of<ItemViewmodel>(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _focusNode.unfocus();
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    _textEditingController.clear();
                  },
                )),
                controller: _textEditingController,
                focusNode: _focusNode,
                onChanged: (searchString) {
                  print(searchString);
                  itemViewmodel.searchItems(searchString);
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: itemViewmodel.searchItem?.length ?? 0,
              itemBuilder: (ctx, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return HomeScreenDetails(
                        item: itemViewmodel.searchItem[index],
                      );
                    }));
                  },
                  leading: Text(itemViewmodel.searchItem[index].id.toString()),
                  title: Text(itemViewmodel.searchItem[index].title),
                );
              }),
        ),
      ],
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField(this.controller, this.focusNode);

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x4437474F),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              controller.clear();
            },
          ),
          border: InputBorder.none,
          hintText: "Search here...",
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
      ),
    );
  }
}

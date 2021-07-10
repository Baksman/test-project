import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:project/datasources/source_response/error.dart';
import 'package:project/models/item.dart';
import 'package:project/ui/screens/home_screen_details.dart';
import 'package:project/viewmodel/items_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:search_widget/search_widget.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemViewmodel>(context);
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<Either<AppError, List<Item>>>(
          future: itemProvider.getItem(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data.fold(
              (AppError error) => Center(child: Text(error.message)),
              (List<Item> items) => itemsWidget(items, context),
            );
          },
        ),
      ),
    );
  }

  Widget itemsWidget(List<Item> items, BuildContext context) {
    return Column(
      children: [
        SearchWidget<Item>(
          dataList: items,
          hideSearchBoxWhenItemSelected: false,
          listContainerHeight: MediaQuery.of(context).size.height / 4,
          queryBuilder: (String query, List<Item> list) {
            return list
                .where((Item item) => item.title.contains(query.toLowerCase()))
                .toList();
          },
          popupListItemBuilder: (Item item) {
            return ListTile(
              leading: Text(item.id.toString()),
              title: Text(item.title),
            );
          },
          selectedItemBuilder:
              (Item selectedItem, VoidCallback deleteSelectedItem) {
            return Text(selectedItem.title);
          },
          // widget customization
          noItemsFoundWidget: Text("No item found"),
          textFieldBuilder:
              (TextEditingController controller, FocusNode focusNode) {
            return MyTextField(controller, focusNode);
          },
        ),
        Expanded(
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return HomeScreenDetails(
                        item: items[index],
                      );
                    }));
                  },
                  leading: Text(items[index].id.toString()),
                  title: Text(items[index].title),
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

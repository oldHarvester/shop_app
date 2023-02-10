import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({required this.title, required this.imageUrl});
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            imageUrl,
          ),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
                color: Theme.of(context).colorScheme.primary,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {},
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

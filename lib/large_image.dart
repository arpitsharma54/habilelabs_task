import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class LargeImage extends StatelessWidget {
  static const routName = '/LargeIMage';

  LargeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}

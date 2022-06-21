import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gallery/large_image.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoadData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          LargeImage.routName: (ctx) => LargeImage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    setState(() {
      isLoading = true;
    });
    Provider.of<LoadData>(context).loadData().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final allData = Provider.of<LoadData>(context).allData;
    return Scaffold(
      appBar: AppBar(title: Text('Gallery')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.only(top: 10, left: 10),
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (ctx, i) => InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(LargeImage.routName,
                              arguments: allData[i]['url']);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            children: [
                              CircleAvatar(
                                child:
                                    Image.network(allData[i]['thumbnailUrl']),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  allData[i]['title'],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
            ),
    );
  }
}

// class PhotoGallery {
//   int albumId;
//   int id;
//   String title;
//   String photoUrl;
//   String thumbUrl;

//   PhotoGallery(
//       {required this.albumId,
//       required this.id,
//       required this.photoUrl,
//       required this.thumbUrl,
//       required this.title});
// }

class LoadData with ChangeNotifier {
  List allData = [];
  Future<void> loadData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/photos');

    final response = await http.get(url);

    List data = jsonDecode(response.body);
    allData = data;
  }
}

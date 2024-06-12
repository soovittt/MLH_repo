import 'package:flutter/material.dart';
import 'package:notifyme/screens/webViewPage.dart';
import 'package:notifyme/utilities/constants/majorList.dart';

class CatalogueData extends StatefulWidget {
  final String dataType;
  const CatalogueData({super.key, required this.dataType});

  @override
  State<CatalogueData> createState() => _CatalogueDataState();
}

class _CatalogueDataState extends State<CatalogueData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                for (var alphabet in majorList.keys)
                  Card(
                      color: Colors.blueAccent[600],
                      child: ExpansionTile(
                        title: Text(alphabet),
                        children: [
                          Column(
                            children: [
                              for (var major in majorList[alphabet]!.keys)
                                ListTile(
                                  tileColor: Colors.blue,
                                  title: Text(major),
                                  trailing: IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => WebView(
                                                      name: major,
                                                      url: majorList[alphabet]![
                                                          major]!,
                                                    )));
                                      },
                                      icon:
                                          const Icon(Icons.arrow_forward_ios)),
                                )
                            ],
                          )
                        ],
                      ))
              ]),
        ));
  }
}

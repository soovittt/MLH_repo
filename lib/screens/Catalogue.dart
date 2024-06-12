import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:notifyme/providers/BottomNavigationProvider.dart';
import 'package:notifyme/screens/CatalogueData.dart';
import 'package:notifyme/screens/webViewPage.dart';
import 'package:provider/provider.dart';

class Catalogue extends StatefulWidget {
  const Catalogue({super.key});
  static String id = "catalogue_page";

  @override
  State<Catalogue> createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  @override
  Widget build(BuildContext context) {
    final bottomNavigationBarController =
        Provider.of<BottomNavigationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("UCI Catalogue"),
        leading: IconButton(
            onPressed: () {
              bottomNavigationBarController.setIndex(0);
              setState(() {});
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //This is the undergraduate portion
            Accordion(children: [
              AccordionSection(
                  header: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Undergraduate",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                  content: Column(
                    // shrinkWrap: true,
                    // physics: const ClampingScrollPhysics(),
                    children: [
                      ListTile(
                        tileColor: Colors.blue,
                        title: Text("Majors and Minors"),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CatalogueData(
                                        dataType: 'Majors and Minors',
                                      )));
                            },
                            icon: Icon(Icons.arrow_forward_ios)),
                      ),
                      ListTile(
                        tileColor: Colors.blue,
                        title: Text("School and Programs"),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WebView(
                                        name: 'Schools and Programs',
                                        url:
                                            "https://catalogue.uci.edu/schoolsandprograms/",
                                      )));
                            },
                            icon: Icon(Icons.arrow_forward_ios)),
                      ),
                      ListTile(
                        tileColor: Colors.blue,
                        title: const Text("Admissions"),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WebView(
                                        name: 'Admissions',
                                        url:
                                            "https://catalogue.uci.edu/informationforprospectivestudents/undergraduateadmissions/",
                                      )));
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      ),
                      ListTile(
                        tileColor: Colors.blue,
                        title: const Text("Requirements For Bachelors Degree"),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WebView(
                                        name: 'Requirements',
                                        url:
                                            "https://catalogue.uci.edu/informationforadmittedstudents/requirementsforabachelorsdegree/",
                                      )));
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      ),
                      ListTile(
                        tileColor: Colors.blue,
                        title: const Text("More Info"),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WebView(
                                        name: 'Undergrad Information',
                                        url:
                                            "https://catalogue.uci.edu/undergraduate/",
                                      )));
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      )
                    ],
                  )),
              AccordionSection(
                  header: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Graduate",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                  content: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      ListTile(
                        tileColor: Colors.blue,
                        title: const Text("Degrees and Graduate Programs"),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WebView(
                                        name: 'Undergrad Information',
                                        url:
                                            "https://catalogue.uci.edu/graduatedegrees/",
                                      )));
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      ),
                      ListTile(
                        tileColor: Colors.blue,
                        title: const Text("School and Programs"),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WebView(
                                        name: 'Undergrad Information',
                                        url:
                                            "https://catalogue.uci.edu/schoolsandprograms/",
                                      )));
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      ),
                      ListTile(
                        tileColor: Colors.blue,
                        title: const Text("Graduate Division"),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WebView(
                                        name: 'Undergrad Information',
                                        url:
                                            "https://catalogue.uci.edu/graduatedivision//",
                                      )));
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      ),
                      ListTile(
                        tileColor: Colors.blue,
                        title: const Text("More Info"),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WebView(
                                        name: 'Undergrad Information',
                                        url:
                                            "https://catalogue.uci.edu/graduate/",
                                      )));
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      )
                    ],
                  )),
              AccordionSection(
                  header: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Academic Calender",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                  content: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        tileColor: Colors.blue,
                        title: const Text("Academic Calender"),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WebView(
                                        name: 'Academic Calender',
                                        url:
                                            "https://catalogue.uci.edu/academiccalendar/",
                                      )));
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      )
                    ],
                  ))
            ]),
          ],
        ),
      ),
    );
  }
}

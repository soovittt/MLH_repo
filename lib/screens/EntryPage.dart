// ignore: file_names
import 'package:flutter/material.dart';
import 'package:notifyme/screens/Dashboard.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});
  static String id = "entry_page";

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  void initState() {
    super.initState();
    // ApiService.getRequest(
    //     "https://api.peterportal.org/rest/v0/schedule/soc?term=2018%20Fall&department=COMPSCI&courseNumber=161");
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.2,
            ),
            Image.asset(
              "assets/images/logo.png",
              height: height * 0.25,
            ),
            const Text(
              "NotifyMe",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Caveat',
                  fontSize: 50,
                  color: Color.fromRGBO(47, 80, 97, 1)),
            ),
            SizedBox(
              height: height * 0.25,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 150,
                height: height * 0.04,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dashboard()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(2, 84, 146, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Center(
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class WellcomePage extends StatelessWidget {
  const WellcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3C5B6F),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/truck.png",
                      scale: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.666,
                decoration: const BoxDecoration(color: Color(0xFF3C5B6F)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.666,
                padding: const EdgeInsets.only(top: 50, bottom: 40),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(70))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "MULAI PENGANTARAN",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Rajdhani",
                            color: Color(0xFF3C5B6F)),
                      ),
                      const Text(
                        "Silahkan Isi Data Berikut !!",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Rajdhani",
                            color: Color(0xFF3C5B6F)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const TextField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            contentPadding:
                                EdgeInsets.only(top: 10, right: 10, left: 10),
                            hintText: "nama driver",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Container(
                                 
                                  child: AlertDialog(
                                    insetPadding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    title: const Text("Input Stock"),
                                    content: Container(
                                      height: 300,
                                      width: 800,
                                      child: const Column(
                                        children: [
                                          Text("data"),
                                          TextField(),
                                          Text("data"),
                                          TextField(),
                                          Text("data"),
                                          TextField(),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: const Text(
                          "Mulai",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3C5B6F),
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                      )
                    ],
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

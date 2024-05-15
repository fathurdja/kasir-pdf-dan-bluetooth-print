import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kasir_app/pages/home.dart';

class WellcomePage extends StatelessWidget {
  const WellcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      child: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height / 1.6,
              color: Colors.white,
            ),
            Container(
              width: size.width,
              height: size.height / 1.6,
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size.width,
                height: size.height / 2.666,
                color: Color(0xFF3C5B6F),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size.width,
                height: size.height / 2.666,
                padding: const EdgeInsets.only(top: 50, bottom: 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(70)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "MULAI PENGANTARAN",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Rajdhani",
                          color: Color(0xFF3C5B6F),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Pastikan Semua Barang telah di hitung dengan baik",
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Stay Safe Drive",
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          height: 50,
                          width: 300,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3C5B6F),
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                CupertinoIcons.square_arrow_right_fill,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(width: 90),
                              Text(
                                "Mulai",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Rajdhani",
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
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

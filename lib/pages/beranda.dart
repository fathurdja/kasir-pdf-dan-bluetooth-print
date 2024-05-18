import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kasir_app/pages/home.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 60),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        height: 40,
                        width: 150, // Lebarkan wadah teks
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 10),
                            Flexible(
                              // Gunakan Flexible untuk memberi ruang bagi teks
                              child: Text(
                                "Femmy",
                                style: TextStyle(
                                  fontSize: 20, // Kurangi ukuran teks
                                  color: Colors.black,
                                  fontFamily: "Rajdhani",
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Tambahkan overflow handling
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.notification_important_rounded,
                            size: 35,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 179,
                    width: 330,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(
                          0.2), // Warna hitam dengan 50% transparansi
                      borderRadius: BorderRadius.circular(18),

                      // Opsional, tambahkan border radius jika diinginkan
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/fyya.jpg"),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Femmy Nurul Ahsanah")
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Rp.100.000",
                                style: TextStyle(fontSize: 40),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("Point: 10"),
                              const SizedBox(
                                width: 70,
                              ),
                              const Text("Membership"),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 80,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors.amber[600],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(child: Text("Gold")),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    width: 400,
                    height: 280,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 30, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                "Menu ----------",
                                style: const TextStyle(fontSize: 40),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home())),
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      foregroundImage: AssetImage(
                                        "assets/images/order.png",
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Order",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Rajdhani",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    foregroundImage: AssetImage(
                                      "assets/images/harian.png",
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Harian",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Rajdhani",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    foregroundImage: AssetImage(
                                      "assets/images/stock.png",
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Stock",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Rajdhani",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    foregroundImage: AssetImage(
                                      "assets/images/member.png",
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Member",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Rajdhani",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

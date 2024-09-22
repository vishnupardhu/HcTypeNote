import 'package:flutter/material.dart';

class TextTypeOrder extends StatefulWidget {
  const TextTypeOrder({super.key});

  // const TextTypeOrder({super.key});

  @override
  State<TextTypeOrder> createState() => _TextTypeOrderState();
}

class _TextTypeOrderState extends State<TextTypeOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HC type Order"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Card(
                color: Colors.blueAccent,
                child: Container(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.text_fields,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Type Order",
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            )
                          ],
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.camera,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Scan Order",
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            )
                          ],
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Gallery Scan",
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            )
                          ],
                        ),
                        onTap: () {},
                      )
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.black,
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

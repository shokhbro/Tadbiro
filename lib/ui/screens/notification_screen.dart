import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Xabarlar",
          style: TextStyle(fontFamily: 'Extrag'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return const Card(
                  elevation: 6,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://w7.pngwing.com/pngs/531/103/png-transparent-eremas-wartoto-businessperson-business-plan-management-business-people-public-relations-business-man.png"),
                        ),
                        title: Text(
                          "Botir Murodov",
                          style: TextStyle(fontFamily: 'Extrag'),
                        ),
                        subtitle: Text(
                          "22:00 19-iyul, 2024",
                          style: TextStyle(fontFamily: 'Lato'),
                        ),
                      ),
                      ListTile(
                        leading: Text(
                          "Universitetlar bo'yicha tadbirga qatnashish\nniyatim bor edi, qabul qila olaszmi?",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

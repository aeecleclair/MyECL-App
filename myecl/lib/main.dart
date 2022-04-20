import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecl/home/ui/app_drawer.dart';
import 'package:myecl/user/models/user.dart';
import 'package:myecl/user/providers/user_provider.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyECL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppDrawer()
    );
  }

  Widget getTopBar(User user) {
    return Column(
      children: [
        Container(
          height: 35,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 25,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          user.nickname,
                          style: TextStyle(
                              color: Colors.grey.shade100,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 3,
                      ),
                      SizedBox(
                          width: 200,
                          child: Text(
                            user.firstname + " " + user.name,
                            style: TextStyle(
                              color: Colors.grey.shade100,
                              fontSize: 15,
                            ),
                          ))
                    ]),
              ],
            ),
          ],
        )
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:myecl/drawer/providers/swipe_provider.dart';
import 'package:myecl/drawer/ui/bottom_bar.dart';
import 'package:myecl/drawer/ui/fake_page.dart';
import 'package:myecl/drawer/ui/list_module.dart';
import 'package:myecl/drawer/ui/top_bar.dart';

class CustomDrawer extends StatelessWidget {
  final SwipeControllerNotifier controllerNotifier;
  const CustomDrawer({Key? key, required this.controllerNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2F86C1), Color(0xFF1E557A)])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TopBar(),
            Row(
              children: [
                Expanded(
                    child: SizedBox(
                        width: 200,
                        height: MediaQuery.of(context).size.height * 4.5 / 10,
                        child: ListModule(
                            controllerNotifier: controllerNotifier))),
                const FakePage(),
              ],
            ),
            BottomBar(controllerNotifier: controllerNotifier),
          ],
        ),
      ),
    );
  }
}

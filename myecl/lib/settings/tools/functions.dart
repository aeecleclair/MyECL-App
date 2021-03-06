import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:myecl/amap/tools/constants.dart';

enum TypeMsg { msg, error }

void displayToast(BuildContext context, TypeMsg type, String text) {
  LinearGradient linearGradient;
  HeroIcons icon;

  switch (type) {
    case TypeMsg.msg:
      linearGradient = const LinearGradient(
          colors: [ColorConstants.gradient1, ColorConstants.gradient2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
      icon = HeroIcons.check;
      break;
    case TypeMsg.error:
      linearGradient = const LinearGradient(
          colors: [ColorConstants.redGradient1, ColorConstants.redGradient2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
      icon = HeroIcons.exclamation;
      break;
  }

  showFlash(
      context: context,
      duration: const Duration(milliseconds: 1500),
      builder: (context, controller) {
        return Flash.dialog(
          controller: controller,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          backgroundGradient: linearGradient,
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: HeroIcon(icon, color: ColorConstants.background),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 120,
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: ColorConstants.background),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

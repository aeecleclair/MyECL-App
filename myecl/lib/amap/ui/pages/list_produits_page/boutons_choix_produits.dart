import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:myecl/amap/class/cash.dart';
import 'package:myecl/amap/class/order.dart';
import 'package:myecl/amap/class/product.dart';
import 'package:myecl/amap/providers/amap_page_provider.dart';
import 'package:myecl/amap/providers/cash_provider.dart';
import 'package:myecl/amap/providers/collection_slot_provider.dart';
import 'package:myecl/amap/providers/delivery_id_provider.dart';
import 'package:myecl/amap/providers/delivery_list_provider.dart';
import 'package:myecl/amap/providers/delivery_product_list_provider.dart';
import 'package:myecl/amap/providers/order_index_provider.dart';
import 'package:myecl/amap/providers/order_list_provider.dart';
import 'package:myecl/amap/providers/order_price_provider.dart';
import 'package:myecl/amap/providers/user_amount_provider.dart';
import 'package:myecl/amap/tools/dialog.dart';
import 'package:myecl/amap/tools/constants.dart';
import 'package:myecl/amap/tools/functions.dart';
import 'package:myecl/amap/ui/green_btn.dart';
import 'package:myecl/auth/providers/oauth2_provider.dart';
import 'package:uuid/uuid.dart';

class Boutons extends HookConsumerWidget {
  const Boutons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryId = ref.watch(deliveryIdProvider);
    final productsList = ref.watch(deliveryProductListProvider(deliveryId));
    final cmdsNotifier = ref.watch(orderListProvider(deliveryId).notifier);
    final indexCmd = ref.watch(orderIndexProvider);
    final pageNotifier = ref.watch(amapPageProvider.notifier);
    final price = ref.watch(priceProvider);
    final delList = ref.watch(deliveryList);
    final collectionSlotNotifier = ref.watch(collectionSlotProvider.notifier);
    final userAmount = ref.watch(userAmountProvider);
    final cashNotifier = ref.watch(cashProvider.notifier);
    final userAmountNotifier = ref.watch(userAmountProvider.notifier);

    final products = [];
    productsList.when(
      data: (list) => products.addAll(list),
      error: (e, s) {},
      loading: () {},
    );

    double b = 0;
    userAmount.when(
        data: (u) {
          b = u.balance;
        },
        error: (e, s) {},
        loading: () {});

    return SizedBox(
        height: 90,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          GestureDetector(
              child: GreenBtn(
                  text: "Confirmer (" + price.toStringAsFixed(2) + "???)"),
              onTap: () {
                if (price == 0.0) {
                  displayToast(context, TypeMsg.error, "Pas de produit");
                } else if (price < b) {
                  List<Product> prod = [];
                  for (var p in products) {
                    if (p.quantity != 0) {
                      prod.add(p.copyWith());
                    }
                  }
                  if (indexCmd == -1) {
                    Order newOrder = Order(
                        products: prod,
                        deliveryDate: delList
                            .firstWhere((d) => d.id == deliveryId)
                            .deliveryDate,
                        id: const Uuid().v4(),
                        amount: price,
                        deliveryId: deliveryId,
                        productsIds: prod.map((e) => e.id).toList(),
                        collectionSlot: collectionSlotNotifier.getText());
                    cmdsNotifier.addOrder(newOrder).then((value) {
                      if (value) {
                        userAmountNotifier.updateCash(-price);
                        userAmount.when(
                            data: (u) {
                              cashNotifier.updateCash(
                                  u.copyWith(balance: u.balance - price));
                            },
                            error: (e, s) {},
                            loading: () {});
                        pageNotifier.setAmapPage(AmapPage.main);
                        displayToast(context, TypeMsg.msg, "Commande ajout??e");
                      } else {
                        pageNotifier.setAmapPage(AmapPage.main);
                        displayToast(
                            context, TypeMsg.error, "Echec de l'ajout");
                      }
                    });
                  } else {
                    cmdsNotifier.setProducts(indexCmd, prod).then((value) {
                      if (value) {
                        userAmountNotifier.updateCash(-price);
                        userAmount.when(
                            data: (u) {
                              cashNotifier.updateCash(
                                  u.copyWith(balance: u.balance - price));
                            },
                            error: (e, s) {},
                            loading: () {});
                        pageNotifier.setAmapPage(AmapPage.main);
                        displayToast(context, TypeMsg.msg, "Commande modifi??e");
                      } else {
                        pageNotifier.setAmapPage(AmapPage.main);
                        displayToast(
                            context, TypeMsg.error, "Echec de la modification");
                      }
                    });
                  }
                  clearCmd(ref);
                } else {
                  displayToast(context, TypeMsg.error, "Pas assez d'argent");
                }
              }),
          GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 70,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  ColorConstants.redGradient1,
                  ColorConstants.redGradient2
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                boxShadow: [
                  BoxShadow(
                      color: ColorConstants.redGradient2.withOpacity(0.4),
                      offset: const Offset(2, 3),
                      blurRadius: 5)
                ],
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              alignment: Alignment.center,
              child: HeroIcon(
                HeroIcons.x,
                size: 35,
                color: ColorConstants.background,
              ),
            ),
            onTap: () {
              if (price != 0.0 || indexCmd != -1) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialogBox(
                        descriptions: "Supprimer la commande ?",
                        title: "Suppression",
                        onYes: () {
                          cancelCmd(ref);
                        }));
              } else {
                pageNotifier.setAmapPage(AmapPage.main);
                ref.watch(orderIndexProvider.notifier).setIndex(-1);
              }
            },
          ),
        ]));
  }
}

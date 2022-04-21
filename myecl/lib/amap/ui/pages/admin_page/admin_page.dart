import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:myecl/amap/class/produit.dart';
import 'package:myecl/amap/providers/amap_page_provider.dart';
import 'package:myecl/amap/providers/index_produit_modifie_provider.dart';
import 'package:myecl/amap/providers/list_categorie_provider.dart';
import 'package:myecl/amap/providers/list_produit_provider.dart';
import 'package:myecl/amap/tools/constants.dart';
import 'package:myecl/amap/ui/green_btn.dart';
import 'package:myecl/amap/ui/pages/admin_page/produit_ui.dart';

class AdminPage extends HookConsumerWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final produits = ref.watch(listeProduitprovider);
    final categories = ref.watch(listeCategorieProvider);
    final pageNotifier = ref.watch(amapPageProvider.notifier);
    final produitModif = ref.read(produitModifProvider.notifier);

    Map<String, List<Widget>> dictCateListWidget = {
      for (var item in categories) item: []
    };

    for (Produit p in produits) {
      dictCateListWidget[p.categorie]!
          .add(ProduitUi(p: p, i: produits.indexOf(p)));
    }

    List<Widget> listWidget = [];

    for (String c in categories) {
      listWidget.add(Container(
          height: 70,
          alignment: Alignment.centerLeft,
          child: Container(
            height: 50,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              c,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          )));

      listWidget += dictCateListWidget[c] ?? [];
    }

    return Column(
      children: [
        const SizedBox(
          height: 60,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: ColorConstants.background2.withOpacity(0.5)),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  GestureDetector(
                      child: const GreenBtn(text: "Ajouter un produit"),
                      onTap: () {
                        produitModif.setIndexProduit(-1);
                        pageNotifier.setAmapPage(4);
                      }),
                  const SizedBox(
                    height: 40,
                  ),
                  ...listWidget
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
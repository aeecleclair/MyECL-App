import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:myecl/loan/tools/functions.dart';
import 'package:myecl/loan/class/loan.dart';
import 'package:myecl/loan/providers/loan_history_provider.dart';
import 'package:myecl/loan/providers/loan_list_provider.dart';
import 'package:myecl/loan/providers/loan_page_provider.dart';
import 'package:myecl/loan/providers/loan_provider.dart';
import 'package:myecl/loan/tools/constants.dart';
import 'package:myecl/loan/tools/dialog.dart';

class LoanUi extends ConsumerWidget {
  final Loan l;
  final bool isHistory;
  const LoanUi({Key? key, required this.l, required this.isHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageNotifier = ref.watch(loanPageProvider.notifier);
    final loanNotifier = ref.watch(loanProvider.notifier);
    final loanListNotifier = ref.watch(loanListProvider.notifier);
    final loanHistoryNotifier = ref.watch(loanHistoryProvider.notifier);
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: ColorConstant.darkGrey,
          boxShadow: const [
            BoxShadow(
              color: ColorConstant.darkGrey,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  l.borrowerId,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.orange),
                ),
              ),
              !isHistory
                  ? IconButton(
                      onPressed: () {
                        showDialog(context: context, builder: (context) {
                          return CustomDialogBox(
                            title: "Supprimer", descriptions: 'Supprimer ce pr??t', onYes: () {
                              loanListNotifier.deleteLoan(l);
                              loanHistoryNotifier.addLoan(l);
                            },
                          );
                        });
                      },
                      icon: const HeroIcon(
                        HeroIcons.x,
                        color: ColorConstant.veryLightOrange,
                        size: 20,
                      ))
                  : Container()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                processDate(l.start) + ' - ' + processDate(l.end),
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.lightOrange),
              ),
              Text(
                l.items.fold(0, (a, b) => (a as int) + b.caution).toString() +
                    '???',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.lightOrange),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                l.items.length.toString() + " objets",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.veryLightOrange),
              )),
          const SizedBox(height: 8),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              l.notes,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: ColorConstant.lightOrange),
            ),
          ),
          const SizedBox(height: 15),
        ]),
      ),
      onTap: () {
        pageNotifier.setLoanPage(isHistory ? LoanPage.historyDetail : LoanPage.detail);
        loanNotifier.setLoan(l);
      },
    );
  }
}

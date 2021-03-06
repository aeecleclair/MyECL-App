import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecl/loan/class/item.dart';
import 'package:myecl/loan/class/loan.dart';
import 'package:myecl/loan/repositories/loan_repository.dart';

class LoanHistoryNotifier extends StateNotifier<AsyncValue<List<Loan>>> {
  final LoanRepository _repository = LoanRepository();
  LoanHistoryNotifier() : super(const AsyncValue.loading());

  Future<AsyncValue<List<Loan>>> loadHistory() async {
    try {
      // final loans = await _repository.getHistory();
      final loans = [
        Loan(
          id: '1',
          borrowerId: '1',
          notes: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          start: DateTime(2020, 1, 1),
          end: DateTime(2020, 1, 31),
          association: 'Asso 1',
          caution: true,
          items: [
            Item(
              id: '1',
              name: 'Item 1',
              caution: 20,
              expiration: DateTime(2020, 1, 31),
              groupId: '',
            ),
            Item(
              id: '2',
              name: 'Item 2',
              caution: 80,
              expiration: DateTime(2020, 1, 31),
              groupId: '',
            ),
          ],
        ),
        Loan(
          id: '2',
          borrowerId: '2',
          notes: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          start: DateTime(2020, 1, 1),
          end: DateTime(2020, 1, 31),
          association: 'Asso 1',
          caution: false,
          items: [
            Item(
              id: '3',
              name: 'Item 3',
              caution: 20,
              expiration: DateTime(2020, 1, 31),
              groupId: '',
            ),
          ],
        ),
      ];
      state = AsyncValue.data(loans);
    } catch (e) {
      state = AsyncValue.error(e);
    }
    return state;
  }

  void addLoan(Loan loan) {
    state.when(data: (loans) {
      loans.add(loan);
      state = AsyncValue.data(loans);
    }, error: (e, s) {
      state = AsyncValue.error(e);
    }, loading: () {
      state = const AsyncValue.loading();
    });
  }
}

final loanHistoryProvider =
    StateNotifierProvider<LoanHistoryNotifier, AsyncValue<List<Loan>>>((ref) {
  LoanHistoryNotifier _loanHistoryNotifier = LoanHistoryNotifier();
  _loanHistoryNotifier.loadHistory();
  return _loanHistoryNotifier;
});

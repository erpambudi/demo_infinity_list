import 'package:demo_infinity_list/api_services.dart';
import 'package:demo_infinity_list/person.dart';
import 'package:flutter/cupertino.dart';

enum RequestState { empty, loading, hasData, noData, error, end }

class PersonsProvider extends ChangeNotifier {
  List<DataResponse> persons = [];
  bool hasReachedMax = false;
  RequestState state = RequestState.empty;

  Future<void> fetchData(int limit) async {
    try {
      if (state == RequestState.empty) {
        state == RequestState.loading;
        var result = await ApiServices().getData(0, limit);
        persons.addAll(result);
        state = RequestState.hasData;
        hasReachedMax = false;
        notifyListeners();
      } else {
        state == RequestState.loading;
        var result = await ApiServices().getData(persons.length, limit);
        if (result.isEmpty) {
          //Jika data dari api mengembalikan list kosong maka diubah jadi true
          hasReachedMax = true;
        } else {
          persons.addAll(result);
          hasReachedMax = false;
        }
        state = RequestState.hasData;
        notifyListeners();
      }
    } catch (e) {
      state = RequestState.error;
      notifyListeners();
    }
  }
}

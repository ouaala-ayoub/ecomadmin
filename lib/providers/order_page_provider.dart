import 'package:ecomadmin/providers/model_page_provider.dart';

class OrderPageProvider extends ModelPageProvider {
  bool firstTime = true;
  OrderPageProvider({required super.helper});

  @override
  fetshModelById(String id) async {
    await super.fetshModelById(id);
    super.model.fold((l) => null, (order) => initiStatus(order.status));
    firstTime = false;
  }

  initiStatus(String status) {
    body['status'] = status;
  }

  setStatus(String status) {
    body['status'] = status;
    notifyListeners();
  }

  final Map<String, dynamic> body = {'status': null};

  @override
  Future<Map<String, dynamic>> processData() async => body;
}

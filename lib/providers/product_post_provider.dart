import 'package:ecomadmin/providers/model_post_provider.dart';

class ProductPostProvider extends ModelPostProvider {
  ProductPostProvider({required super.helper});

  final Map<String, dynamic> _body = {};

  @override
  Map<String, dynamic> get body => _body;
}

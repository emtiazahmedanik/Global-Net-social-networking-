import 'package:flutter/foundation.dart';

class ExpandableTextController extends ChangeNotifier {
  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  void toggle() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void collapse() {
    _isExpanded = false;
    notifyListeners();
  }

  void expand() {
    _isExpanded = true;
    notifyListeners();
  }
}

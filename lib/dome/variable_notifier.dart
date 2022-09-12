import 'package:flutter/foundation.dart';

class VariableNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  VariableNotifier(this._value);

  @override
  T get get => _value;
  T _value;
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  /// Set a new value and notify listeners by default. To not notify, set notify to false
  VariableNotifier set(T newValue, {bool notify = true}) {
    if (_value == newValue) return this;
    _value = newValue;
    if (notify) notifyListeners();
    return this;
  }

  @override
  String toString() => '${describeIdentity(this)}($get)';
}

abstract class ValueListenable<T> extends Listenable {
  const ValueListenable();
  T get get;
}

abstract class Listenable {
  const Listenable();

  factory Listenable.merge(List<Listenable?> listenables) = _MergingListenable;

  void addListener(VoidCallback listener);

  void removeListener(VoidCallback listener);
}

class _MergingListenable extends Listenable {
  _MergingListenable(this._children);

  final List<Listenable?> _children;

  @override
  void addListener(VoidCallback listener) {
    for (final Listenable? child in _children) {
      child?.addListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    for (final Listenable? child in _children) {
      child?.removeListener(listener);
    }
  }

  @override
  String toString() {
    return 'Listenable.merge([${_children.join(", ")}])';
  }
}

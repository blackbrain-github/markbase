import 'package:Markbase/dome/variable_notifier.dart';
import 'package:flutter/material.dart';

class Listen<T> extends StatefulWidget {
  const Listen({
    Key? key,
    required this.to,
    required this.builder,
    this.child,
  }) : super(key: key);

  final VariableNotifier<T> to;

  final ValueWidgetBuilder<T> builder;

  final Widget? child;

  @override
  State<StatefulWidget> createState() => _ListenState<T>();
}

class _ListenState<T> extends State<Listen<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.to.get;
    widget.to.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(Listen<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.to != widget.to) {
      oldWidget.to.removeListener(_valueChanged);
      value = widget.to.get;
      widget.to.addListener(_valueChanged);
    }
  }

  @override
  void dispose() {
    widget.to.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      value = widget.to.get;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(value);
  }
}

typedef ValueWidgetBuilder<T> = Widget Function(T value);

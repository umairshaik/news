import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_bloc.dart';
export 'package:news/src/blocs/stories_bloc.dart';

class StoriesProvider extends InheritedWidget {
  late final StoriesBloc bloc;

  StoriesProvider({super.key, required super.child}) : bloc = StoriesBloc();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static StoriesBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoriesProvider>()!.bloc;
  }
}

import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_provider.dart';

class Refresh extends StatelessWidget {
  final Widget child;

  const Refresh({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return RefreshIndicator(
        onRefresh: () async {
          await bloc.clearCache();
          await bloc.fetchTopIds();
        },
        child: child);
  }
}

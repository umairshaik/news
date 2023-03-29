import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_provider.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/screen/news_details.dart';
import 'package:news/src/screen/news_list.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: "News!",
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          final bloc = StoriesProvider.of(context);
          bloc.fetchTopIds();
          return const NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final bloc = CommentsProvider.of(context);
          final itemId = int.parse(settings.name!.replaceFirst('/', ''));
          bloc.fetchItemWithComments(itemId);
          return NewsDetails(itemId: itemId);
        },
      );
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_music/app.dart';
import 'package:flutter_music/launch_page.dart';
import 'package:flutter_music/views/home/home.dart';
import 'package:flutter_music/views/search/search.dart';
import 'package:go_router/go_router.dart';

routeTransition(BuildContext context, GoRouterState state, Widget widget) {
  return CustomTransitionPage(
    child: widget,
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

routes() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LaunchPage(),
      ),
      GoRoute(
        path: '/bootstrap',
        builder: (context, state) => const AppPage(),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return routeTransition(context, state, const Home());
        },
      ),
      GoRoute(
        path: '/search',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return routeTransition(context, state, const Search());
        },
      ),
    ],
  );
}

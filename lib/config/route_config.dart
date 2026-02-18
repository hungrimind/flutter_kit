import 'package:flutter_kit/home/home_view.dart';
import 'package:flutter_kit/not_found/not_found_view.dart';
import 'package:go_router/go_router.dart';

final routes = [
  GoRoute(path: '/', builder: (context, state) => const HomeView()),
  GoRoute(path: '/404', builder: (context, state) => const NotFoundView()),
];

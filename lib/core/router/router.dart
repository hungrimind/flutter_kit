import 'package:flutter_kit/home/home_view.dart';
import 'package:flutter_kit/navigation/route_data.dart';
import 'package:flutter_kit/not_found/not_found_view.dart';

final routes = [
  RouteEntry(path: '/', builder: (key, routeData) => const HomeView()),
  RouteEntry(path: '/404', builder: (key, routeData) => const NotFoundView()),
];
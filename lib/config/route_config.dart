import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kit/home/home_view.dart';
import 'package:flutter_kit/not_found/not_found_view.dart';
import 'package:go_router/go_router.dart';

Page<void> _buildPage(Widget child, GoRouterState state) {
  if (kIsWeb) {
    return NoTransitionPage(key: state.pageKey, child: child);
  }
  return MaterialPage(key: state.pageKey, child: child);
}

final routes = [
  GoRoute(
    path: '/',
    pageBuilder: (context, state) => _buildPage(const HomeView(), state),
  ),
  GoRoute(
    path: '/404',
    pageBuilder: (context, state) => _buildPage(const NotFoundView(), state),
  ),
];

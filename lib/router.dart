import 'package:flutter/material.dart';
import 'package:task_rahmanda_one/arguments/arguments_user_post.dart';
import 'package:task_rahmanda_one/feature/screens/detail_post_screen.dart';
import 'package:task_rahmanda_one/feature/screens/profile_screen.dart';
import 'feature/screens/post_list_screen.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/post-list-screen':
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => PostListScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case '/profile-screen':
        final String userId = settings.arguments;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => ProfileScreen(userId),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case '/detai-post-screen':
        final ArgumentsUserPost argumentsUserPost = settings.arguments as ArgumentsUserPost;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => DetailPostScreen(argumentsUserPost),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));
      default:
        return MaterialPageRoute<dynamic>(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}

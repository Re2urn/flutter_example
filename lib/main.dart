import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_example/blocs/github_user_details/github_user_details_bloc.dart';
import 'package:flutter_example/blocs/github_users/github_users_bloc.dart';
import 'package:flutter_example/screens/github_users_screen.dart';
import 'package:flutter_example/services/github_service.dart';
import 'package:flutter_example/services/network_service.dart';
import 'package:flutter_example/widgets/network_status_widget.dart';
import 'package:flutter_example/widgets/offline_banner.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final gitHubService = GitHubService();
    final networkService = NetworkService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NetworkService>(
          create: (_) => networkService,
        ),
        BlocProvider<GitHubUsersBloc>(
          create: (context) => GitHubUsersBloc(gitHubService: gitHubService),
        ),
        BlocProvider<GitHubUserDetailsBloc>(
          create: (context) =>
              GitHubUserDetailsBloc(gitHubService: gitHubService),
        ),
      ],
      child: MaterialApp(
        title: 'GitHub Users Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        home: const GitHubUsersScreen(),
      ),
    );
  }
}

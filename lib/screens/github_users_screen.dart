import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_example/blocs/github_users/github_users_bloc.dart';
import 'package:flutter_example/models/github_user.dart';
import 'package:flutter_example/screens/github_user_details_screen.dart';
import 'package:flutter_example/widgets/user_list_item.dart';
import 'package:flutter_example/widgets/adaptive_loader.dart';
import 'package:flutter_example/utils/platform_util.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GitHubUsersScreen extends StatefulWidget {
  const GitHubUsersScreen({Key? key}) : super(key: key);

  @override
  State<GitHubUsersScreen> createState() => _GitHubUsersScreenState();
}

class _GitHubUsersScreenState extends State<GitHubUsersScreen> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<GitHubUsersBloc>().add(LoadGitHubUsers());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final state = context.read<GitHubUsersBloc>().state;

    if (currentScroll >= maxScroll * 0.9 &&
        state is GitHubUsersLoaded &&
        !state.hasReachedMax &&
        !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      context.read<GitHubUsersBloc>().add(LoadMoreGitHubUsers());
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    int columns;
    if (kIsWeb) {
      columns = width < 800
          ? 2
          : width < 1200
              ? 3
              : width < 1600
                  ? 4
                  : 5;
    } else {
      columns = width > 600 ? 3 : 2;
    }

    double aspectRatio = kIsWeb ? 0.8 : (width > 600 ? 1.2 : 0.8);

    double padding = kIsWeb ? 24.0 : 16.0;
    double spacing = kIsWeb ? 24.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Пользователи GitHub'),
        titleTextStyle: kIsWeb
            ? const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            iconSize: kIsWeb ? 28 : 24,
            onPressed: () {
              context.read<GitHubUsersBloc>().add(RefreshGitHubUsers());
            },
          ),
        ],
      ),
      body: BlocBuilder<GitHubUsersBloc, GitHubUsersState>(
        builder: (context, state) {
          if (state is GitHubUsersInitial || state is GitHubUsersLoading) {
            return const Center(
              child: AdaptiveLoader(),
            );
          }

          if (state is GitHubUsersLoaded) {
            if (state.users.isEmpty) {
              return const Center(
                child: Text(
                  'Пользователей нема',
                  style: TextStyle(
                    fontSize: kIsWeb ? 20 : 16,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<GitHubUsersBloc>().add(RefreshGitHubUsers());
                return Future.delayed(const Duration(milliseconds: 500));
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(padding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                ),
                itemCount: state.hasReachedMax
                    ? state.users.length
                    : state.users.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.users.length) {
                    return const Center(
                      child: AdaptiveLoader(),
                    );
                  }

                  final user = state.users[index];
                  return UserListItem(
                    user: user,
                    onTap: () => _navigateToUserDetails(user),
                  );
                },
              ),
            );
          }

          if (state is GitHubUsersError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GitHubUsersBloc>().add(LoadGitHubUsers());
                    },
                    child: const Text('Попробовать снова'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _navigateToUserDetails(GitHubUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GitHubUserDetailsScreen(username: user.nickname),
      ),
    );
  }
}

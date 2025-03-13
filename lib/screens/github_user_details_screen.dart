import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_example/blocs/github_user_details/github_user_details_bloc.dart';
import 'package:flutter_example/models/github_user.dart';
import 'package:flutter_example/widgets/adaptive_loader.dart';
import 'package:flutter_example/widgets/info_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_example/utils/screen_util.dart';

class GitHubUserDetailsScreen extends StatefulWidget {
  final String username;

  const GitHubUserDetailsScreen({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<GitHubUserDetailsScreen> createState() =>
      _GitHubUserDetailsScreenState();
}

class _GitHubUserDetailsScreenState extends State<GitHubUserDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<GitHubUserDetailsBloc>()
        .add(LoadGitHubUserDetails(widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: BlocBuilder<GitHubUserDetailsBloc, GitHubUserDetailsState>(
        builder: (context, state) {
          if (state is GitHubUserDetailsInitial ||
              state is GitHubUserDetailsLoading) {
            return const Center(
              child: AdaptiveLoader(),
            );
          }

          if (state is GitHubUserDetailsLoaded) {
            final user = state.userDetails;

            return SingleChildScrollView(
              padding: EdgeInsets.all(ScreenUtil.getAdaptivePadding(context)),
              child: ScreenUtil.isMobile(context)
                  ? _buildMobileLayout(user)
                  : _buildDesktopLayout(user),
            );
          }

          if (state is GitHubUserDetailsError) {
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
                      context.read<GitHubUserDetailsBloc>().add(
                            LoadGitHubUserDetails(widget.username),
                          );
                    },
                    child: const Text('Попробоваь снова'),
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

  Widget _buildDesktopLayout(GitHubUserDetails user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildUserAvatar(user),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: _buildUserInfo(user),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(GitHubUserDetails user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: _buildUserAvatar(user)),
        const SizedBox(height: 24),
        _buildUserInfo(user),
      ],
    );
  }

  Widget _buildUserAvatar(GitHubUserDetails user) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            user.avatarUrl,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name.isNotEmpty ? user.name : user.login,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        if (user.bio != null && user.bio!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            user.bio!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.open_in_new),
          label: const Text('Перейти на GitHub'),
          onPressed: () => _launchUrl(user.htmlUrl),
        ),
      ],
    );
  }

  Widget _buildUserInfo(GitHubUserDetails user) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Информация о профиле',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            InfoTile(
              label: 'Имя пользователя',
              value: user.login,
              icon: Icons.account_circle,
            ),
            if (user.location != null && user.location!.isNotEmpty)
              InfoTile(
                label: 'Местоположение',
                value: user.location!,
                icon: Icons.location_on,
              ),
            if (user.company != null && user.company!.isNotEmpty)
              InfoTile(
                label: 'Компания',
                value: user.company!,
                icon: Icons.business,
              ),
            InfoTile(
              label: 'Репозитории',
              value: user.publicRepos.toString(),
              icon: Icons.book,
            ),
            InfoTile(
              label: 'Подписчики',
              value: user.followers.toString(),
              icon: Icons.people,
            ),
            InfoTile(
              label: 'Подписки',
              value: user.following.toString(),
              icon: Icons.person_add,
            ),
            if (user.blog != null && user.blog!.isNotEmpty)
              InkWell(
                onTap: () => _launchUrl(user.blog!),
                child: InfoTile(
                  label: 'Сайт',
                  value: user.blog!,
                  icon: Icons.language,
                  isLink: true,
                ),
              ),
            if (user.email != null && user.email!.isNotEmpty)
              InfoTile(
                label: 'Email',
                value: user.email!,
                icon: Icons.email,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось открыть $urlString')),
        );
      }
    }
  }
}

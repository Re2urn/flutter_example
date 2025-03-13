part of 'github_users_bloc.dart';

abstract class GitHubUsersEvent extends Equatable {
  const GitHubUsersEvent();

  @override
  List<Object> get props => [];
}

class LoadGitHubUsers extends GitHubUsersEvent {}

class LoadMoreGitHubUsers extends GitHubUsersEvent {}

class RefreshGitHubUsers extends GitHubUsersEvent {}

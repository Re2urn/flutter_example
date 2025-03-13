part of 'github_user_details_bloc.dart';

abstract class GitHubUserDetailsEvent extends Equatable {
  const GitHubUserDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadGitHubUserDetails extends GitHubUserDetailsEvent {
  final String username;

  const LoadGitHubUserDetails(this.username);

  @override
  List<Object> get props => [username];
}

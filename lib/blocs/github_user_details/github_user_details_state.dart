part of 'github_user_details_bloc.dart';

abstract class GitHubUserDetailsState extends Equatable {
  const GitHubUserDetailsState();

  @override
  List<Object> get props => [];
}

class GitHubUserDetailsInitial extends GitHubUserDetailsState {}

class GitHubUserDetailsLoading extends GitHubUserDetailsState {}

class GitHubUserDetailsLoaded extends GitHubUserDetailsState {
  final GitHubUserDetails userDetails;

  const GitHubUserDetailsLoaded({required this.userDetails});

  @override
  List<Object> get props => [userDetails];
}

class GitHubUserDetailsError extends GitHubUserDetailsState {
  final String message;

  const GitHubUserDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}

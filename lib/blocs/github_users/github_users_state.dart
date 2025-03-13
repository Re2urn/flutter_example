part of 'github_users_bloc.dart';

abstract class GitHubUsersState extends Equatable {
  const GitHubUsersState();

  @override
  List<Object> get props => [];
}

class GitHubUsersInitial extends GitHubUsersState {}

class GitHubUsersLoading extends GitHubUsersState {}

class GitHubUsersLoaded extends GitHubUsersState {
  final List<GitHubUser> users;
  final bool hasReachedMax;
  final int lastId;

  const GitHubUsersLoaded({
    required this.users,
    required this.hasReachedMax,
    required this.lastId,
  });

  GitHubUsersLoaded copyWith({
    List<GitHubUser>? users,
    bool? hasReachedMax,
    int? lastId,
  }) {
    return GitHubUsersLoaded(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastId: lastId ?? this.lastId,
    );
  }

  @override
  List<Object> get props => [users, hasReachedMax, lastId];
}

class GitHubUsersError extends GitHubUsersState {
  final String message;

  const GitHubUsersError({required this.message});

  @override
  List<Object> get props => [message];
}

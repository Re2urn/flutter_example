import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_example/models/github_user.dart';
import 'package:flutter_example/services/github_service.dart';

part 'github_users_event.dart';
part 'github_users_state.dart';

class GitHubUsersBloc extends Bloc<GitHubUsersEvent, GitHubUsersState> {
  final GitHubService _gitHubService;

  GitHubUsersBloc({required GitHubService gitHubService})
      : _gitHubService = gitHubService,
        super(GitHubUsersInitial()) {
    on<LoadGitHubUsers>(_onLoadGitHubUsers);
    on<LoadMoreGitHubUsers>(_onLoadMoreGitHubUsers);
    on<RefreshGitHubUsers>(_onRefreshGitHubUsers);
  }

  Future<void> _onLoadGitHubUsers(
      LoadGitHubUsers event, Emitter<GitHubUsersState> emit) async {
    emit(GitHubUsersLoading());
    try {
      final users = await _gitHubService.fetchUsers(perPage: 20, since: 0);
      if (users.isEmpty) {
        emit(
            const GitHubUsersLoaded(users: [], hasReachedMax: true, lastId: 0));
      } else {
        emit(GitHubUsersLoaded(
            users: users, hasReachedMax: false, lastId: users.last.unit));
      }
    } catch (e) {
      emit(GitHubUsersError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreGitHubUsers(
      LoadMoreGitHubUsers event, Emitter<GitHubUsersState> emit) async {
    final currentState = state;
    if (currentState is GitHubUsersLoaded) {
      if (currentState.hasReachedMax) return;

      try {
        final moreUsers = await _gitHubService.fetchUsers(
          perPage: 20,
          since: currentState.lastId,
        );

        if (moreUsers.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          final updatedUsers = List<GitHubUser>.from(currentState.users)
            ..addAll(moreUsers);
          emit(
            GitHubUsersLoaded(
              users: updatedUsers,
              hasReachedMax: false,
              lastId: moreUsers.last.unit,
            ),
          );
        }
      } catch (e) {
        emit(GitHubUsersError(message: e.toString()));
      }
    }
  }

  Future<void> _onRefreshGitHubUsers(
      RefreshGitHubUsers event, Emitter<GitHubUsersState> emit) async {
    try {
      final users = await _gitHubService.fetchUsers(perPage: 20, since: 0);
      if (users.isEmpty) {
        emit(
            const GitHubUsersLoaded(users: [], hasReachedMax: true, lastId: 0));
      } else {
        emit(GitHubUsersLoaded(
            users: users, hasReachedMax: false, lastId: users.last.unit));
      }
    } catch (e) {
      emit(GitHubUsersError(message: e.toString()));
    }
  }
}

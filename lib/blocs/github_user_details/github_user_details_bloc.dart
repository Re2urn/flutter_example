import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_example/models/github_user.dart';
import 'package:flutter_example/services/github_service.dart';

part 'github_user_details_event.dart';
part 'github_user_details_state.dart';

class GitHubUserDetailsBloc
    extends Bloc<GitHubUserDetailsEvent, GitHubUserDetailsState> {
  final GitHubService _gitHubService;

  GitHubUserDetailsBloc({required GitHubService gitHubService})
      : _gitHubService = gitHubService,
        super(GitHubUserDetailsInitial()) {
    on<LoadGitHubUserDetails>(_onLoadGitHubUserDetails);
  }

  Future<void> _onLoadGitHubUserDetails(
      LoadGitHubUserDetails event, Emitter<GitHubUserDetailsState> emit) async {
    emit(GitHubUserDetailsLoading());
    try {
      final userDetails = await _gitHubService.fetchUserDetails(event.username);
      emit(GitHubUserDetailsLoaded(userDetails: userDetails));
    } catch (e) {
      emit(GitHubUserDetailsError(message: e.toString()));
    }
  }
}

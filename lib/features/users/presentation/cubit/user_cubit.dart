import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:codebase_assignment/features/users/domain/entity/user.dart';
import 'package:codebase_assignment/features/users/domain/usecases/fetch_users_usecase.dart';
import 'package:codebase_assignment/features/users/presentation/cubit/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final FetchUsersUseCase usecase;
  bool _hasMore = true;

  UserCubit({required this.usecase}) : super(UserDataInitialState()) {
    fetchInitialUsers();
  }

  Future<void> fetchInitialUsers() async {
    _hasMore = true;
    emit(UserDataLoadingState());
    await _fetchUserList(page: 1);
  }

  Future<void> refresh() async {
    fetchInitialUsers();
  }

  void loadmore() {
    if (state is! UserDataSuccessState || !_hasMore) return;
    final currentState = state as UserDataSuccessState;
    final nextPage = currentState.page + 1;
    emit(UserDataLoadingMoreState(page: nextPage, users: currentState.users));
    _fetchUserList(page: nextPage);
  }

  Future<void> _fetchUserList({required int page, int limit = 20}) async {
    final response =
        await usecase(params: UsersParams(page: page, limit: limit));
    response.fold((error) {
      emit(UserDataFailureState(error.message));
    }, (result) {
      List<User> allUsers = [];
      if (state is UserDataLoadingMoreState) {
        final currentState = state as UserDataLoadingMoreState;
        allUsers = [...currentState.users, ...result];
      } else {
        allUsers = result;
      }
      if (result.isEmpty) {
        _hasMore = false;
      }
      emit(UserDataSuccessState(users: allUsers, page: page, limit: limit));
    });
  }

  void search(String query) {
    if (state is! UserDataSuccessState) return;

    UserDataSuccessState currentState = state as UserDataSuccessState;
    final allUsers = currentState.users;
    if (query.isEmpty) {
      emit(
        UserDataSuccessState(
          users: allUsers,
          page: currentState.page,
          limit: currentState.limit,
        ),
      );
    } else {
      final regex = RegExp('^$query', caseSensitive: false);

      final filteredUsers = allUsers.where((user) {
        final firstNameMatch = regex.hasMatch(user.firstName);
        final lastNameMatch = regex.hasMatch(user.lastName);
        final emailMatch = regex.hasMatch(user.email);

        return firstNameMatch || lastNameMatch || emailMatch;
      }).toList();
      emit(
        UserDataSearchSuccessState(
          users: currentState.users,
          page: currentState.page,
          limit: currentState.limit,
          results: filteredUsers,
        ),
      );
    }
  }
}

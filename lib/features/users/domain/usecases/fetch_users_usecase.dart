import 'package:codebase_assignment/core/error/base_error.dart';
import 'package:codebase_assignment/core/utils/usecase.dart';
import 'package:codebase_assignment/features/users/domain/entity/user.dart';
import 'package:codebase_assignment/features/users/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';

class FetchUsersUseCase
    extends Usecase<Future<Either<BaseError, List<User>>>, UsersParams> {
  final UserRepository _repository;

  FetchUsersUseCase(this._repository);

  @override
  Future<Either<BaseError, List<User>>> call(
      {required UsersParams params}) async {
    return await _repository.fetchUsers(params.page, params.limit);
  }
}

class UsersParams {
  int page;
  int limit;
  UsersParams({required this.page, required this.limit});
}

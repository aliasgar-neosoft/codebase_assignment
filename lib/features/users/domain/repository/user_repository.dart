import 'package:codebase_assignment/core/error/base_error.dart';
import 'package:codebase_assignment/features/users/domain/entity/user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<BaseError, List<User>>> fetchUsers(int page, int limit);
}

import 'package:codebase_assignment/core/error/base_error.dart';
import 'package:codebase_assignment/core/services/network_connectivity/network_connectitvity.dart';
import 'package:codebase_assignment/features/users/data/datasource/user_data_source.dart';
import 'package:codebase_assignment/features/users/data/mapper/user_mapper.dart';
import 'package:codebase_assignment/features/users/data/model/users_response.dart';
import 'package:codebase_assignment/features/users/domain/entity/user.dart';
import 'package:codebase_assignment/features/users/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource local;
  final UserDatasource remote;
  final NetworkConnectivityService network;

  UserRepositoryImpl({
    required this.local,
    required this.remote,
    required this.network,
  });

  @override
  Future<Either<BaseError, List<User>>> fetchUsers(int page, int limit) async {
    final Either<BaseError, UsersResponse> response;
    final isConnected = await network.isConnected;
    if (isConnected) {
      response = await remote.fetchUsers(page, limit);
    } else {
      response = await local.fetchUsers(page, limit);
    }
    return response.fold(
      (error) => Left(error),
      (result) => Right(result.users.map(UserMapper.toDomain).toList()),
    );
  }
}

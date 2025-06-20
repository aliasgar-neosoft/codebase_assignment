import 'package:codebase_assignment/features/users/data/model/user.dart';
import 'package:codebase_assignment/features/users/domain/entity/user.dart';

class UserMapper {
  static User toDomain(UserModel model) {
    return User(
      id: model.id,
      avatar: model.avatar,
      email: model.email,
      lastName: model.lastName,
      firstName: model.firstName,
    );
  }
}

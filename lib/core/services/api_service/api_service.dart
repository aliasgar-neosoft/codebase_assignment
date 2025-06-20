import 'package:codebase_assignment/features/users/data/model/users_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio) {
    final baseUrl = dotenv.env['BASE_URL'];
    return _ApiService(dio, baseUrl: baseUrl);
  }

  @GET("/users")
  Future<UsersResponse> fetchUsers(
    @Query("per_page") int perPage,
    @Query("page") int page,
  );
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsersResponseImpl _$$UsersResponseImplFromJson(Map<String, dynamic> json) =>
    _$UsersResponseImpl(
      page: (json['page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
      users: (json['data'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UsersResponseImplToJson(_$UsersResponseImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total': instance.total,
      'per_page': instance.perPage,
      'total_pages': instance.totalPages,
      'data': instance.users,
    };

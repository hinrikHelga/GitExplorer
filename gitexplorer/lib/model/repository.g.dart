// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repository _$RepositoryFromJson(Map<String, dynamic> json) => Repository(
      owner: json['owner'] == null
          ? null
          : Owner.fromJson(json['owner'] as Map<String, dynamic>),
      fullName: json['full_name'] as String?,
      language: json['language'] as String?,
      description: json['description'] as String?,
      forksCount: json['forks_count'] as int?,
      openIssuesCount: json['open_issues_count'] as int?,
      watchersCount: json['watchers_count'] as int?,
      stargazersCount: json['stargazers_count'] as int?,
      latestRelease: json['latest_release'] as String?,
    );

Map<String, dynamic> _$RepositoryToJson(Repository instance) =>
    <String, dynamic>{
      'owner': instance.owner,
      'full_name': instance.fullName,
      'language': instance.language,
      'description': instance.description,
      'forks_count': instance.forksCount,
      'open_issues_count': instance.openIssuesCount,
      'watchers_count': instance.watchersCount,
      'stargazers_count': instance.stargazersCount,
      'latest_release': instance.latestRelease,
    };

Repositories _$RepositoriesFromJson(Map<String, dynamic> json) => Repositories(
      totalCount: json['total_count'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Repository.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RepositoriesToJson(Repositories instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'items': instance.items,
    };

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      'avatar_url': instance.avatarUrl,
    };

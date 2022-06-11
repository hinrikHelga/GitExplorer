
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'repository.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Repository extends Equatable {
  final String? imgUrl;
  final String? fullName;
  final String? language;
  final int? forksCount;
  final int? openIssuesCount;
  final int? watchersCount;
  final int? stargazersCount;
  final String? latestRelease;


  const Repository({
    this.imgUrl,
    this.fullName,
    this.language,
    this.forksCount,
    this.openIssuesCount,
    this.watchersCount,
    this.stargazersCount,
    this.latestRelease
  });

  factory Repository.fromJson(Map<String, dynamic> json) => _$RepositoryFromJson(json);

  Map<String, dynamic> toJson() => _$RepositoryToJson(this);

  @override
  List<Object?> get props => [];
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Repositories extends Equatable {
  final int? totalCount;
  final List<Repository>? items; 

  const Repositories({
    this.totalCount,
    this.items
  });

  factory Repositories.fromJson(Map<String, dynamic> json) => _$RepositoriesFromJson(json);

  Map<String, dynamic> toJson() => _$RepositoriesToJson(this);

  @override
  List<Object?> get props => [];
}

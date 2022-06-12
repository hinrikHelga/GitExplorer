
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'repository.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Repository extends Equatable {
  final Owner? owner;
  final String? fullName;
  final String? language;
  final String? description;
  final int? forksCount;
  final int? openIssuesCount;
  final int? watchersCount;
  final int? stargazersCount;
  final String? latestRelease;


  const Repository({
    this.owner,
    this.fullName,
    this.language,
    this.description,
    this.forksCount,
    this.openIssuesCount,
    this.watchersCount,
    this.stargazersCount,
    this.latestRelease
  });

  factory Repository.fromJson(Map<String, dynamic> json) => _$RepositoryFromJson(json);

  Map<String, dynamic> toJson() => _$RepositoryToJson(this);

  @override
  List<Object?> get props => [
    owner, 
    fullName, 
    language,
    description,
    forksCount,
    openIssuesCount,
    watchersCount,
    stargazersCount,
    latestRelease];
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
  List<Object?> get props => [totalCount, items];
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Owner extends Equatable {
  final String? avatarUrl;

  const Owner({
    this.avatarUrl
  });

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerToJson(this);

  @override
  List<Object?> get props => [avatarUrl];
}

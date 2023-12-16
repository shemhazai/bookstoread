import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'paged.g.dart';

/// Holds results from a paginated response.
@JsonSerializable(genericArgumentFactories: true)
@immutable
class Paged<T> {
  @JsonKey(name: 'numFound')
  final int numFound;

  @JsonKey(name: 'docs')
  final List<T> docs;

  const Paged({
    required this.numFound,
    required this.docs,
  });

  factory Paged.empty() {
    return Paged<T>(
      numFound: 0,
      docs: const [],
    );
  }

  factory Paged.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return _$PagedFromJson(json, fromJsonT);
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return _$PagedToJson<T>(this, toJsonT);
  }

  bool get isEmpty => docs.isEmpty;

  bool get isNotEmpty => !isEmpty;

  @override
  String toString() => 'Paged(numFound=$numFound,docs=$docs)';

  @override
  int get hashCode => Object.hash(numFound, docs);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Paged<T>) return false;
    return numFound == other.numFound && listEquals(docs, other.docs);
  }
}

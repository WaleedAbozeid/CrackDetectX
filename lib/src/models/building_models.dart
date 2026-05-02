import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Represents a physical building being inspected
class Building {
  final String id;
  final String name;
  final String address;
  final int? yearBuilt;
  final String ownerId;
  final String? projectId;
  final DateTime createdAt;

  const Building({
    required this.id,
    required this.name,
    required this.address,
    this.yearBuilt,
    required this.ownerId,
    this.projectId,
    required this.createdAt,
  });

  /// Factory constructor to create a new Building with auto-generated id/createdAt
  factory Building.create({
    required String name,
    required String address,
    int? yearBuilt,
    required String ownerId,
    String? projectId,
  }) {
    return Building(
      id: _uuid.v4(),
      name: name,
      address: address,
      yearBuilt: yearBuilt,
      ownerId: ownerId,
      projectId: projectId,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'yearBuilt': yearBuilt,
        'ownerId': ownerId,
        'projectId': projectId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Building.fromJson(Map<String, dynamic> json) => Building(
        id: json['id'] as String,
        name: json['name'] as String,
        address: json['address'] as String,
        yearBuilt: json['yearBuilt'] as int?,
        ownerId: json['ownerId'] as String,
        projectId: json['projectId'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Building copyWith({
    String? name,
    String? address,
    int? yearBuilt,
    String? projectId,
  }) {
    return Building(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      yearBuilt: yearBuilt ?? this.yearBuilt,
      ownerId: ownerId,
      projectId: projectId ?? this.projectId,
      createdAt: createdAt,
    );
  }
}

/// Represents a project that groups multiple buildings
class Project {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final List<String> buildingIds;
  final DateTime createdAt;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.buildingIds,
    required this.createdAt,
  });

  factory Project.create({
    required String name,
    required String description,
    required String ownerId,
  }) {
    return Project(
      id: _uuid.v4(),
      name: name,
      description: description,
      ownerId: ownerId,
      buildingIds: [],
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'ownerId': ownerId,
        'buildingIds': buildingIds,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        ownerId: json['ownerId'] as String,
        buildingIds: List<String>.from(json['buildingIds'] as List),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// An engineer's annotation on a detected crack
class Annotation {
  final String id;
  final String scanId;    // FK to Report id
  final String coords;    // JSON stringified coordinates on the image
  final String crackType; // e.g. 'structural', 'surface', 'hairline'
  final String? notes;
  final DateTime createdAt;

  const Annotation({
    required this.id,
    required this.scanId,
    required this.coords,
    required this.crackType,
    this.notes,
    required this.createdAt,
  });

  factory Annotation.create({
    required String scanId,
    required String coords,
    required String crackType,
    String? notes,
  }) {
    return Annotation(
      id: _uuid.v4(),
      scanId: scanId,
      coords: coords,
      crackType: crackType,
      notes: notes,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'scanId': scanId,
        'coords': coords,
        'crackType': crackType,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Annotation.fromJson(Map<String, dynamic> json) => Annotation(
        id: json['id'] as String,
        scanId: json['scanId'] as String,
        coords: json['coords'] as String,
        crackType: json['crackType'] as String,
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

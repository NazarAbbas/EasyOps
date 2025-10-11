// lib/models/suggestions_response.dart

class SuggestionsResponse {
  final List<Suggestion> content;
  final Pageable pageable;
  final int totalElements;
  final int totalPages;
  final bool last;
  final bool first;
  final int numberOfElements;
  final int size;
  final int number;
  final Sort sort;
  final bool empty;

  SuggestionsResponse({
    required this.content,
    required this.pageable,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.first,
    required this.numberOfElements,
    required this.size,
    required this.number,
    required this.sort,
    required this.empty,
  });

  factory SuggestionsResponse.fromJson(Map<String, dynamic> json) {
    return SuggestionsResponse(
      content: (json['content'] as List<dynamic>)
          .map((e) => Suggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageable: Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      last: json['last'] as bool,
      first: json['first'] as bool,
      numberOfElements: json['numberOfElements'] as int,
      size: json['size'] as int,
      number: json['number'] as int,
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>),
      empty: json['empty'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content.map((e) => e.toJson()).toList(),
      'pageable': pageable.toJson(),
      'totalElements': totalElements,
      'totalPages': totalPages,
      'last': last,
      'first': first,
      'numberOfElements': numberOfElements,
      'size': size,
      'number': number,
      'sort': sort.toJson(),
      'empty': empty,
    };
  }
}

class Suggestion {
  final String id;
  final String plantId;
  final String suggestionTypeId;
  final String name;
  final String description;
  final String status;
  final double impactEstimate;
  final String comment;
  final int recordStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdById;
  final String updatedById;

  Suggestion({
    required this.id,
    required this.plantId,
    required this.suggestionTypeId,
    required this.name,
    required this.description,
    required this.status,
    required this.impactEstimate,
    required this.comment,
    required this.recordStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.createdById,
    required this.updatedById,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      id: json['id'] as String,
      plantId: json['plantId'] as String,
      suggestionTypeId: json['suggestionTypeId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      impactEstimate: (json['impactEstimate'] as num).toDouble(),
      comment: json['comment'] as String,
      recordStatus: json['recordStatus'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdById: json['createdById'] as String,
      updatedById: json['updatedById'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'suggestionTypeId': suggestionTypeId,
      'name': name,
      'description': description,
      'status': status,
      'impactEstimate': impactEstimate,
      'comment': comment,
      'recordStatus': recordStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdById': createdById,
      'updatedById': updatedById,
    };
  }
}

class Pageable {
  final Sort sort;
  final int pageNumber;
  final int pageSize;
  final int offset;
  final bool paged;
  final bool unpaged;

  Pageable({
    required this.sort,
    required this.pageNumber,
    required this.pageSize,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>),
      pageNumber: json['pageNumber'] as int,
      pageSize: json['pageSize'] as int,
      offset: json['offset'] as int,
      paged: json['paged'] as bool,
      unpaged: json['unpaged'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sort': sort.toJson(),
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'offset': offset,
      'paged': paged,
      'unpaged': unpaged,
    };
  }
}

class Sort {
  final bool sorted;
  final bool unsorted;
  final bool empty;

  Sort({
    required this.sorted,
    required this.unsorted,
    required this.empty,
  });

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      sorted: json['sorted'] as bool,
      unsorted: json['unsorted'] as bool,
      empty: json['empty'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sorted': sorted,
      'unsorted': unsorted,
      'empty': empty,
    };
  }
}

final items = SuggestionsResponse(
  content: [
    Suggestion(
      id: 'SUG-123456',
      plantId: 'PLT-0001',
      suggestionTypeId: 'TYPE-001',
      name: 'Equipment Upgrade',
      description: 'Upgrade the main pump to improve efficiency.',
      status: 'Pending',
      impactEstimate: 5000.0,
      comment: 'This upgrade will reduce energy consumption by 15%',
      recordStatus: 1,
      createdAt: DateTime.parse('2025-01-15T10:30:00Z'),
      updatedAt: DateTime.parse('2025-01-15T10:30:00Z'),
      createdById: 'USR-0001',
      updatedById: 'USR-0001',
    ),
    Suggestion(
      id: 'SUG-654321',
      plantId: 'PLT-0002',
      suggestionTypeId: 'TYPE-002',
      name: 'Safety Rail Installation',
      description: 'Install safety rails near the assembly line.',
      status: 'Approved',
      impactEstimate: 2500.0,
      comment: 'This will improve operator safety significantly.',
      recordStatus: 1,
      createdAt: DateTime.parse('2025-02-10T09:00:00Z'),
      updatedAt: DateTime.parse('2025-02-15T14:20:00Z'),
      createdById: 'USR-0002',
      updatedById: 'USR-0003',
    ),
    Suggestion(
      id: 'SUG-789012',
      plantId: 'PLT-0003',
      suggestionTypeId: 'TYPE-003',
      name: 'LED Lighting Replacement',
      description: 'Replace old lighting with energy-efficient LED bulbs.',
      status: 'Implemented',
      impactEstimate: 12000.0,
      comment: 'Energy consumption reduced by 25% after implementation.',
      recordStatus: 1,
      createdAt: DateTime.parse('2025-03-05T11:45:00Z'),
      updatedAt: DateTime.parse('2025-03-20T16:30:00Z'),
      createdById: 'USR-0004',
      updatedById: 'USR-0004',
    ),
    Suggestion(
      id: 'SUG-789012',
      plantId: 'PLT-0003',
      suggestionTypeId: 'TYPE-003',
      name: 'LED Lighting Replacement',
      description: 'Replace old lighting with energy-efficient LED bulbs.',
      status: 'Open',
      impactEstimate: 12000.0,
      comment: 'Energy consumption reduced by 25% after implementation.',
      recordStatus: 1,
      createdAt: DateTime.parse('2025-03-05T11:45:00Z'),
      updatedAt: DateTime.parse('2025-03-20T16:30:00Z'),
      createdById: 'USR-0004',
      updatedById: 'USR-0004',
    ),
  ],
  pageable: Pageable(
    pageNumber: 0,
    pageSize: 200,
    offset: 0,
    paged: true,
    unpaged: false,
    sort: Sort(sorted: true, unsorted: false, empty: false),
  ),
  totalElements: 3,
  totalPages: 1,
  last: true,
  first: true,
  numberOfElements: 3,
  size: 200,
  number: 0,
  sort: Sort(sorted: true, unsorted: false, empty: false),
  empty: false,
);

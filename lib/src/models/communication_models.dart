enum SupportTicketStatus {
  open,
  resolved,
  closed,
}

enum NotificationPriority {
  low,
  medium,
  high,
}

class SupportTicket {
  final String id;
  final String userId;
  final String userName;
  final String subject;
  final String description;
  final SupportTicketStatus status;
  final NotificationPriority priority;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolutionNote;

  const SupportTicket({
    required this.id,
    required this.userId,
    required this.userName,
    required this.subject,
    required this.description,
    this.status = SupportTicketStatus.open,
    this.priority = NotificationPriority.medium,
    required this.createdAt,
    this.resolvedAt,
    this.resolutionNote,
  });

  SupportTicket copyWith({
    SupportTicketStatus? status,
    NotificationPriority? priority,
    DateTime? resolvedAt,
    String? resolutionNote,
  }) {
    return SupportTicket(
      id: id,
      userId: userId,
      userName: userName,
      subject: subject,
      description: description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolutionNote: resolutionNote ?? this.resolutionNote,
    );
  }

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: (json['id'] ?? json['_id'] ?? json['ticket_id'] ?? '').toString(),
      userId: (json['user_id'] ?? json['userId'] ?? '').toString(),
      userName: (json['user_name'] ?? json['userName'] ?? '').toString(),
      subject: (json['subject'] ?? '').toString(),
      description: (json['description'] ?? json['message'] ?? '').toString(),
      status: SupportTicketStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? 'open'),
        orElse: () => SupportTicketStatus.open,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.name == (json['priority'] ?? 'medium'),
        orElse: () => NotificationPriority.medium,
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'].toString())
              : DateTime.now(),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'].toString())
          : null,
      resolutionNote: json['resolution_note']?.toString(),
    );
  }
}

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final NotificationPriority priority;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isRead = false,
    required this.createdAt,
    this.priority = NotificationPriority.medium,
  });

  AppNotification copyWith({
    bool? isRead,
  }) {
    return AppNotification(
      id: id,
      userId: userId,
      title: title,
      body: body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      priority: priority,
    );
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json['id'] ?? json['_id'] ?? json['notification_id'] ?? '').toString(),
      userId: (json['user_id'] ?? json['userId'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? json['message'] ?? json['content'] ?? '').toString(),
      isRead: json['is_read'] ?? json['isRead'] ?? json['read'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'].toString())
              : DateTime.now(),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.name == (json['priority'] ?? 'medium'),
        orElse: () => NotificationPriority.medium,
      ),
    );
  }
}


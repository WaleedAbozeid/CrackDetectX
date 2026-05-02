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
}


import 'dart:convert';

class AuthTokens {
  final String accessToken;
  final String? refreshToken;

  const AuthTokens({
    required this.accessToken,
    this.refreshToken,
  });

  factory AuthTokens.fromLoginResponse(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? const {};
    return AuthTokens(
      accessToken: (data['accessToken'] ?? '').toString(),
      refreshToken: data['refreshToken']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };

  String encode() => jsonEncode(toJson());

  static AuthTokens? decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return AuthTokens(
      accessToken: (decoded['accessToken'] ?? '').toString(),
      refreshToken: decoded['refreshToken']?.toString(),
    );
  }
}


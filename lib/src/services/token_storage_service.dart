import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../models/auth_tokens.dart';

class TokenStorageService {
  TokenStorageService._();
  static final TokenStorageService instance = TokenStorageService._();

  Future<void> save(AuthTokens tokens) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.authTokensStorageKey, tokens.encode());
  }

  Future<AuthTokens?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.authTokensStorageKey);
    return AuthTokens.decode(raw);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.authTokensStorageKey);
  }

  Future<String?> accessToken() async {
    final tokens = await load();
    return tokens?.accessToken;
  }

  Future<String?> refreshToken() async {
    final tokens = await load();
    return tokens?.refreshToken;
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import '../models/marketplace_full_models.dart';

/// Service wrapper around FirebaseAuth handling roles and profile data
///
/// Note: In a real backend, profile data (AppUser, Company, etc.) would be
/// stored in Firestore/SQL. Here we mock local storage for demonstration.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mock in-memory storage for profiles (would be DB call)
  AppUser? _currentUserProfile;
  EngineerProfile? _currentEngineerProfile;
  Company? _currentCompany;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;
  AppUser? get currentUserProfile => _currentUserProfile;
  EngineerProfile? get engineerProfile => _currentEngineerProfile;
  bool get isCompany => _currentCompany != null;

  /// Sign up a standard user (Owner)
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    UserRole role = UserRole.owner,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    if (credential.user != null) {
      await credential.user!.updateDisplayName(displayName.trim());
      await credential.user!.reload();

      // Create local profile
      _currentUserProfile = AppUser(
        id: credential.user!.uid,
        email: email,
        fullName: displayName,
        role: role,
        createdAt: DateTime.now(),
      );
    }

    return _auth.currentUser;
  }

  /// Sign up an Engineer with professional details
  Future<User?> signUpEngineer({
    required String email,
    required String password,
    required String displayName,
    required String syndicateNumber,
    required int yearsOfExperience,
    required List<String> specializations,
  }) async {
    final user = await signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
      role: UserRole.engineer,
    );

    if (user != null) {
      _currentEngineerProfile = EngineerProfile(
        userId: user.uid,
        syndicateCardNumber: syndicateNumber,
        yearsOfExperience: yearsOfExperience,
        specializations: specializations,
      );
      // Logic to upload documents would go here
    }
    return user;
  }

  /// Sign up a Company
  Future<User?> signUpCompany({
    required String email,
    required String password,
    required String companyName,
    required String tradeLicense,
    required String taxId,
  }) async {
    final user = await signUpWithEmail(
      email: email,
      password: password,
      displayName: '$companyName (Admin)',
      role: UserRole.companyAdmin,
    );

    if (user != null) {
      final companyId = 'comp_${DateTime.now().millisecondsSinceEpoch}';
      _currentCompany = Company(
        id: companyId,
        name: companyName,
        tradeLicenseNumber: tradeLicense,
        taxId: taxId,
        createdAt: DateTime.now(),
      );

      // Link user to company
      _currentUserProfile = _currentUserProfile?.copyWith(companyId: companyId);
    }
    return user;
  }

  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    // In real app: Fetch profile from DB here
    // For demo: We assume profile is already loaded or we create a dummy one
    if (credential.user != null && _currentUserProfile == null) {
      _currentUserProfile = AppUser(
        id: credential.user!.uid,
        email: email,
        fullName: credential.user!.displayName ?? 'User',
        role: UserRole.owner, // Default to owner if not found
        createdAt: DateTime.now(),
      );
    }

    return credential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUserProfile = null;
    _currentEngineerProfile = null;
    _currentCompany = null;
  }
}

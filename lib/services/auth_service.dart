abstract class AuthService {
  Future<void> signUp(
    String email,
    String password,
  );
  Future<void> signIn(
    String email,
    String password,
  );
  Future<void> signOut();
  Future<bool> isAuthenticated();
}

class AuthRepository {
  // Mocked login. Replace with real API call if needed.
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // demo rule: if email contains 'fail' throw error, else success
    if (email.contains('fail')) {
      throw Exception('Invalid credentials');
    }
    return;
  }
}

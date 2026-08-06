import '../api/dio_client.dart';

class AuthService {
  final DioClient client;

  AuthService(this.client);

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await client.dio.post(
      "/auth/login",
      data: {
        "username": username,
        "password": password,
      },
    );

    return response.data;
  }

  Future<void> sendReset(String username) async {
    print(username);
    await client.dio.post("/mail/forgot-password", data: {
      "username": username,
    });
  }
}
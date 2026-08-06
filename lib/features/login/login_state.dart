class LoginState {
  final bool loading;
  final bool success;
  final String message;
  final bool forgotMode;
  final String? role; // 👈 لازم تكون موجودة

  LoginState({
    this.loading = false,
    this.success = false,
    this.message = "",
    this.forgotMode = false,
    this.role,
  });

  LoginState copyWith({
    bool? loading,
    bool? success,
    String? message,
    bool? forgotMode,
    String? role,
  }) {
    return LoginState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      message: message ?? this.message,
      forgotMode: forgotMode ?? this.forgotMode,
      role: role ?? this.role,
    );
  }
}
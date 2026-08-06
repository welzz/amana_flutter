import '../../models/delegation.dart';

class StaffDashboardState {
  final bool isLoading;
  final bool isVerifying;
  final bool isConfirming;
  final bool isScanning;

  final String verificationCode;
  final String toastMessage;
  final String scanMessage;

  final bool showToast;
  final bool? isValid;

  final Delegation? delegation;

  const StaffDashboardState({
    this.isLoading = false,
    this.isVerifying = false,
    this.isConfirming = false,
    this.isScanning = false,
    this.verificationCode = '',
    this.toastMessage = '',
    this.scanMessage = '',
    this.showToast = false,
    this.isValid,
    this.delegation,
  });

  StaffDashboardState copyWith({
    bool? isLoading,
    bool? isVerifying,
    bool? isConfirming,
    bool? isScanning,
    String? verificationCode,
    String? toastMessage,
    String? scanMessage,
    bool? showToast,
    bool? isValid,
    Delegation? delegation,
  }) {
    return StaffDashboardState(
      isLoading: isLoading ?? this.isLoading,
      isVerifying: isVerifying ?? this.isVerifying,
      isConfirming: isConfirming ?? this.isConfirming,
      isScanning: isScanning ?? this.isScanning,
      verificationCode: verificationCode ?? this.verificationCode,
      toastMessage: toastMessage ?? this.toastMessage,
      scanMessage: scanMessage ?? this.scanMessage,
      showToast: showToast ?? this.showToast,
      isValid: isValid ?? this.isValid,
      delegation: delegation ?? this.delegation,
    );
  }
}
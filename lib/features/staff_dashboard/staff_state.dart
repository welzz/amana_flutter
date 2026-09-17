 import '../../models/PickupRequest.dart';
class StaffState {
  final List<PickupRequest> pickupRequests;
  final Set<PickupStatus> selectedFilters;
  final DateTime lastUpdated;
  final bool isLoading;
  final bool isScanning;
  final String scanResultMessage;

  const StaffState({
    this.pickupRequests = const [],
    this.selectedFilters = const {
      PickupStatus.Awaiting,
      PickupStatus.ChildReleased,
      PickupStatus.Completed,
    },
    required this.lastUpdated,
    this.isLoading = false,
    this.isScanning = false,
    this.scanResultMessage = '',
  });


  StaffState copyWith({
    List<PickupRequest>? pickupRequests,
    Set<PickupStatus>? selectedFilters,
    DateTime? lastUpdated,
    bool? isLoading,
    bool? isScanning,
    String? scanResultMessage,
  }) {

    return StaffState(
      pickupRequests:
          pickupRequests ?? this.pickupRequests,

      selectedFilters:
          selectedFilters ?? this.selectedFilters,

      lastUpdated:
          lastUpdated ?? this.lastUpdated,

      isLoading:
          isLoading ?? this.isLoading,

      isScanning:
          isScanning ?? this.isScanning,

      scanResultMessage:
          scanResultMessage ?? this.scanResultMessage,
    );
  }



  List<PickupRequest> get filteredRequests {

    if(selectedFilters.isEmpty){
      return pickupRequests;
    }


    return pickupRequests
        .where(
          (item)=>
          selectedFilters.contains(item.status)
        )
        .toList();

  }
}
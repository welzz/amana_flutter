import 'dart:async';

import 'package:amana_flutter/features/bus_dashboard/BusController.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

 import '../../models/PickupRequest.dart';
import '../../core/services/PickupService.dart';
import 'staff_state.dart';



final staffControllerProvider =
    StateNotifierProvider<StaffController, StaffState>((ref) {

  final pickupService = ref.read(pickupServiceProvider);

  return StaffController(
    pickupService: pickupService,
  );

});




class StaffController extends StateNotifier<StaffState> {


  final PickupService pickupService;


  Timer? _refreshTimer;



  StaffController({
    required this.pickupService,
  })
      : super(
          StaffState(
            lastUpdated: DateTime.now(),
          ),
        );




  Future<void> loadPickupRequests(
      int schoolId,
      ) async {


    try {


      state = state.copyWith(
        isLoading: true,
      );


      final result =
          await pickupService.loadSPickupRequest(
            schoolId,
          );



      final now = DateTime.now();


      final todayRequests =
          result.where((item){


            final arrival =
                
                  item.arrivalTime
                 ;


            return arrival.year == now.year &&
                arrival.month == now.month &&
                arrival.day == now.day;


          }).toList();




      state = state.copyWith(

        pickupRequests: todayRequests,

        lastUpdated: DateTime.now(),

        isLoading:false,

      );



    } catch(e){


      state = state.copyWith(
        isLoading:false,
      );


      print(
        "Staff load error : $e",
      );

    }


  }





  void startAutoRefresh(
      int schoolId,
      ){


    _refreshTimer?.cancel();



    _refreshTimer =
        Timer.periodic(
          const Duration(seconds:30),
          (_) {


            loadPickupRequests(
              schoolId,
            );


          },
        );


  }





  void stopAutoRefresh(){

    _refreshTimer?.cancel();

    _refreshTimer=null;

  }





  void toggleFilter(
      PickupStatus status,
      ){


    final filters =
        {...state.selectedFilters};



    if(filters.contains(status)){

      filters.remove(status);

    }else{

      filters.add(status);

    }



    state =
        state.copyWith(
          selectedFilters: filters,
        );


  }





  Future<void> updateStatus(
      int requestId,
      PickupStatus status,
      int schoolId,
      ) async {



    try{


      await pickupService.updatePickupStatus(
        requestId,
        status.name,
      );



      await loadPickupRequests(
        schoolId,
      );


    }catch(e){

      print(
        "Update status error : $e",
      );

    }



  }







  Future<void> updateStatusFromQr(
      PickupRequest request,
      int schoolId,
      ) async {



    PickupStatus nextStatus =
        request.status;



    if(request.status ==
        PickupStatus.Awaiting){


      nextStatus =
          PickupStatus.ChildReleased;


    }



    await updateStatus(
      request.id!,
      nextStatus,
      schoolId,
    );


  }





  void startScanner(){

    state =
        state.copyWith(
          isScanning:true,
          scanResultMessage:'',
        );

  }





  void closeScanner(){

    state =
        state.copyWith(
          isScanning:false,
          scanResultMessage:'',
        );


  }





  void setScanMessage(
      String message,
      ){

    state =
        state.copyWith(
          scanResultMessage:message,
        );

  }





  @override
  void dispose(){

    _refreshTimer?.cancel();

    super.dispose();

  }

  Future<void> submitTicket({required String subject, required String message}) async {}


}
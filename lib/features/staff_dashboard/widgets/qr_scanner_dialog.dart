import 'dart:convert';

import 'package:amana_flutter/models/PickupRequest.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

 import '../staff_controller.dart';



class QrScannerDialog extends ConsumerStatefulWidget {


  final int schoolId;



  const QrScannerDialog({

    super.key,

    required this.schoolId,

  });




  @override
  ConsumerState<QrScannerDialog> createState() =>
      _QrScannerDialogState();


}







class _QrScannerDialogState
    extends ConsumerState<QrScannerDialog> {


  bool scanned = false;



  final MobileScannerController scannerController =
      MobileScannerController();





  @override
  Widget build(BuildContext context) {



    final state =
        ref.watch(
          staffControllerProvider,
        );



    final controller =
        ref.read(
          staffControllerProvider.notifier,
        );




    return Dialog(


      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(20),

      ),



      child:
      SizedBox(

        height:
        500,


        child:
        Column(


          children:[



            Padding(

              padding:
              const EdgeInsets.all(16),


              child:
              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,


                children:[



                  Text(

                    "staffDashboard.scan.title"
                        .tr(),


                    style:
                    Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),



                  IconButton(

                    onPressed: (){

                      Navigator.pop(context);

                    },


                    icon:
                    const Icon(
                      Icons.close,
                    ),


                  ),


                ],

              ),

            ),





            Expanded(


              child:
              ClipRRect(

                borderRadius:
                BorderRadius.circular(12),



                child:
                MobileScanner(


                  controller:
                  scannerController,



                  onDetect:
                      (capture){



                    if(scanned){
                      return;
                    }



                    final barcode =
                        capture.barcodes.firstOrNull;



                    if(barcode == null){
                      return;
                    }



                    final value =
                        barcode.rawValue;



                    if(value == null){
                      return;
                    }




                    scanned=true;



                    _processQr(

                      value,

                      controller,

                      state.pickupRequests,

                    );



                  },


                ),

              ),


            ),





            if(state.scanResultMessage.isNotEmpty)

              Padding(

                padding:
                const EdgeInsets.all(16),


                child:
                Text(

                  state.scanResultMessage,

                  textAlign:
                  TextAlign.center,


                ),

              )




          ],


        ),



      ),


    );



  }









  void _processQr(

      String code,

      StaffController controller,

      List<PickupRequest> requests,

      ){



    try{



      final data =
      jsonDecode(code);




      final studentId =
      data["studentId"];




      final studentName =
      data["studentName"];




      final request =
      requests.firstWhere(

            (item)=>

        item.studentId ==
            studentId &&

            item.status !=
                PickupStatus.Completed,


        orElse: () => throw Exception(),

      );





      if(request.status ==
          PickupStatus.Awaiting){



        controller
            .updateStatusFromQr(
          request,
          widget.schoolId,
        );



        controller.setScanMessage(

          "${"change.status".tr()} "
              "$studentName "
              "${"pickupStatus.childreleased".tr()}",

        );



      }else{



        controller.setScanMessage(

          "$studentName "
              "${"status.completed".tr()}",

        );


      }





      Future.delayed(

          const Duration(seconds:2),

              (){

            if(mounted){

              Navigator.pop(context);

            }


          }

      );




    }catch(e){



      controller.setScanMessage(

        "Invalid QR Code",

      );


      scanned=false;



    }


  }





  @override
  void dispose(){

    scannerController.dispose();

    super.dispose();

  }


}
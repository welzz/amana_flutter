import 'package:amana_flutter/features/staff_dashboard/staff_controller.dart';
import 'package:amana_flutter/models/PickupRequest.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

 


class StatusFilter extends ConsumerWidget {

  const StatusFilter({
    super.key,
  });



  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final state =
        ref.watch(
          staffControllerProvider,
        );


    final controller =
        ref.read(
          staffControllerProvider.notifier,
        );



    final statuses =
    <PickupStatus>[

      PickupStatus.Awaiting,

      PickupStatus.ChildReleased,

      PickupStatus.Completed,

    ];




    return Container(

      padding:
      const EdgeInsets.all(16),


      decoration:
      BoxDecoration(

        color:
        Theme.of(context)
            .cardColor,


        borderRadius:
        BorderRadius.circular(16),


        boxShadow:[

          BoxShadow(

            blurRadius:12,

            offset:
            const Offset(0,4),

            color:
            Colors.black12,

          ),

        ],

      ),




      child:
      Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children:[



          Text(

            "staffDashboard.filterByStatus"
                .tr(),


            style:
            Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(

              fontWeight:
              FontWeight.bold,

            ),


          ),




          const SizedBox(
            height:12,
          ),





          Wrap(

            spacing:
            8,


            runSpacing:
            8,



            children:

            statuses.map((status){


              final selected =
              state.selectedFilters
                  .contains(status);




              return InkWell(

                borderRadius:
                BorderRadius.circular(30),


                onTap: (){


                  controller.toggleFilter(
                    status,
                  );


                },


                child:
                AnimatedContainer(

                  duration:
                  const Duration(
                    milliseconds:200,
                  ),


                  padding:
                  const EdgeInsets.symmetric(

                    horizontal:18,

                    vertical:10,

                  ),



                  decoration:
                  BoxDecoration(

                    color:
                    selected

                        ? Theme.of(context)
                        .colorScheme
                        .primary

                        :

                    Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,


                    borderRadius:
                    BorderRadius.circular(30),


                  ),



                  child:
                  Text(

                    _statusText(status),


                    style:
                    TextStyle(

                      color:
                      selected

                          ? Colors.white

                          :

                      Theme.of(context)
                          .colorScheme
                          .onSurface,

                      fontWeight:
                      FontWeight.w600,

                    ),


                  ),


                ),


              );


            }).toList(),


          ),



        ],

      ),

    );


  }






  String _statusText(
      PickupStatus status
      ){


    switch(status){


      case PickupStatus.Awaiting:

        return "pickupStatus.awaiting"
            .tr();



      case PickupStatus.ChildReleased:

        return "pickupStatus.childreleased"
            .tr();



      case PickupStatus.Completed:

        return "pickupStatus.completed"
            .tr();


    }

  }


}
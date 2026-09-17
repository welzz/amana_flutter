import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../models/PickupRequest.dart';



class PickupCard extends StatelessWidget {


  final PickupRequest pickupRequest;

  final Function(PickupStatus status) onStatusChange;



  const PickupCard({

    super.key,

    required this.pickupRequest,

    required this.onStatusChange,

  });





  @override
  Widget build(BuildContext context) {



    return Container(

      padding:
      const EdgeInsets.all(16),


      decoration:
      BoxDecoration(

        color:
        Theme.of(context)
            .cardColor,


        borderRadius:
        BorderRadius.circular(18),


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




          Row(

            children:[



              CircleAvatar(

                radius:
                28,


           backgroundImage:

pickupRequest.studentPictureUrl != null &&
        pickupRequest.studentPictureUrl!.isNotEmpty

    ? MemoryImage(
        base64Decode(
          pickupRequest.studentPictureUrl!
              .split(',')
              .last,
        ),
      )

    : null,


                child:

                pickupRequest.studentPictureUrl == null

                    ? const Icon(
                  Icons.person,
                )

                    :

                null,

              ),





              const SizedBox(
                width:12,
              ),





              Expanded(

                child:
                Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,


                  children:[



                    Text(

                      pickupRequest.studentName,

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
                      height:4,
                    ),




                    Text(

                      pickupRequest.studentClass ?? "",

                      style:
                      Theme.of(context)
                          .textTheme
                          .bodyMedium,

                    ),



                  ],

                ),

              ),




              _statusBadge(context),

            ],

          ),





          const SizedBox(
            height:16,
          ),





          Divider(
            color:
            Colors.grey.shade300,
          ),





          const SizedBox(
            height:10,
          ),





      _infoRow(
  context,
  Icons.access_time,
  DateFormat('hh:mm a').format(
    pickupRequest.arrivalTime,
  ),
),






          const Spacer(),





          if(pickupRequest.status ==
              PickupStatus.Awaiting)

            SizedBox(

              width:
              double.infinity,


              child:
              ElevatedButton.icon(


                icon:
                const Icon(
                  Icons.check,
                ),



                label:
                Text(
                  "change.status"
                      .tr(),
                ),




                onPressed: (){


                  onStatusChange(

                    PickupStatus.ChildReleased,

                  );


                },


              ),

            ),




          if(pickupRequest.status ==
              PickupStatus.ChildReleased)

            SizedBox(

              width:
              double.infinity,


              child:
              ElevatedButton.icon(

                icon:
                const Icon(
                  Icons.done_all,
                ),



                label:
                Text(
                  "pickupStatus.completed"
                      .tr(),
                ),



                onPressed: (){


                  onStatusChange(

                    PickupStatus.Completed,

                  );


                },


              ),

            ),




        ],

      ),



    );

  }







  Widget _statusBadge(
      BuildContext context
      ){



    Color color;


    switch(
    pickupRequest.status
    ){


      case PickupStatus.Awaiting:

        color =
            Colors.orange;



        break;


      case PickupStatus.ChildReleased:

        color =
            Colors.blue;



        break;



      case PickupStatus.Completed:

        color =
            Colors.green;



        break;


    }




    return Container(

      padding:
      const EdgeInsets.symmetric(

        horizontal:10,

        vertical:6,

      ),



      decoration:
      BoxDecoration(

        color:
        color.withOpacity(.15),


        borderRadius:
        BorderRadius.circular(20),

      ),



      child:
      Text(

        pickupRequest.status.name,

        style:
        TextStyle(

          color:
          color,

          fontWeight:
          FontWeight.bold,

        ),

      ),



    );

  }





  Widget _infoRow(

      BuildContext context,

      IconData icon,

      String text,

      ){


    return Row(

      children:[


        Icon(

          icon,

          size:
          18,

        ),



        const SizedBox(
          width:8,
        ),



        Text(
          text,
        ),



      ],

    );

  }


}
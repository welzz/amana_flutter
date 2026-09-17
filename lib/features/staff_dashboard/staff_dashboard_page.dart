import 'package:amana_flutter/app/router/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

 
import 'staff_controller.dart';
import 'widgets/pickup_card.dart';
import 'widgets/status_filter.dart';
import 'widgets/qr_scanner_dialog.dart';
import 'widgets/support_ticket_dialog.dart';

import '../login/auth_providers.dart';

class StaffDashboardPage extends ConsumerStatefulWidget {

  const StaffDashboardPage({
    super.key,
  });


  @override
  ConsumerState<StaffDashboardPage> createState() =>
      _StaffDashboardPageState();

}





class _StaffDashboardPageState
    extends ConsumerState<StaffDashboardPage> {



  late int schoolId;



  @override
  void initState() {

    super.initState();


    WidgetsBinding.instance
        .addPostFrameCallback((_) {


      final loginResponse =
    ref.read(loginSessionProvider);

if (loginResponse == null) return;

final schoolIdValue =
    loginResponse['schoolId'];

if (schoolIdValue != null) {

  schoolId =
      int.parse(
        schoolIdValue.toString(),
      );


  ref
      .read(staffControllerProvider.notifier)
      .loadPickupRequests(
        schoolId,
      );


  ref
      .read(staffControllerProvider.notifier)
      .startAutoRefresh(
        schoolId,
      );

}


      


    });

  }







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



    final loginResponse =
    ref.watch(loginSessionProvider);

final userName =
    context.locale.languageCode == 'ar'
        ? (loginResponse?['name'] ?? '')
        : (loginResponse?['firstNameEn'] ?? '');




    return Scaffold(


      floatingActionButton:


      FloatingActionButton(

        onPressed: (){

          showDialog(

            context: context,

            builder: (_) =>
                const SupportTicketDialog(),

          );

        },


        child:
        const Icon(
          Icons.help_outline,
        ),

      ),






      body:


      SafeArea(

        child:


        SingleChildScrollView(

          padding:
          const EdgeInsets.all(16),


          child:


          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,


            children: [





              // HEADER

              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,


                children: [


                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,


                      children: [


                        Text(

                          'parentDashboard.title'.tr(),

                          style:
                          Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            fontWeight:
                            FontWeight.bold,
                          ),

                        ),




                        const SizedBox(
                          height:8,
                        ),




                        Text(

                          "${"staffDashboard.welcome".tr()} "
                              "$userName",


                          style:
                          Theme.of(context)
                              .textTheme
                              .titleMedium,

                        ),





                        const SizedBox(
                          height:4,
                        ),





                        Text(

                          "${"staffDashboard.lastUpdated".tr()} "
                              "${DateFormat('hh:mm:ss').format(state.lastUpdated)}",


                          style:
                          Theme.of(context)
                              .textTheme
                              .bodySmall,

                        ),



                      ],

                    ),

                  ),





                  Row(

                    children: [


                     IconButton(
  icon: const Icon(Icons.language),
  onPressed: () {
    if (context.locale.languageCode == 'en') {
      context.setLocale(const Locale('ar'));
    } else {
      context.setLocale(const Locale('en'));
    }
  },
),



                      const SizedBox(
                        width:8,
                      ),



                     PopupMenuButton<String>(
  icon: const Icon(Icons.account_circle),
  onSelected: (value) {
    switch (value) {
      case 'logout':
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.login,
        );
        break;
    }
  },
  itemBuilder: (context) => [
    PopupMenuItem(
      value: 'logout',
      child: Text('logout'.tr()),
    ),
  ],
),



                    ],

                  )




                ],

              ),





              const SizedBox(
                height:24,
              ),





              // ACTION BUTTONS

              Row(

                children: [


                  Expanded(

                    child:
                    ElevatedButton.icon(

                      icon:
                      const Icon(
                        Icons.qr_code_scanner,
                      ),


                      label:
                      Text(
                        "staffDashboard.scanQr"
                            .tr(),
                      ),


                      onPressed: (){


                        showDialog(

                          context: context,

                          builder: (_) =>
                              QrScannerDialog(
                                schoolId:
                                schoolId,
                              ),

                        );


                      },


                    ),

                  ),



                ],

              ),



              const SizedBox(
                height:20,
              ),
                            const SizedBox(
                height:20,
              ),



              // STATUS FILTER

              StatusFilter(),




              const SizedBox(
                height:20,
              ),





              // CONTENT


              if(state.isLoading)

                const Center(

                  child:
                  CircularProgressIndicator(),

                )



              else if(
                state.filteredRequests.isEmpty
              )

                _emptyState(context)



              else


                GridView.builder(

                  shrinkWrap:true,

                  physics:
                  const NeverScrollableScrollPhysics(),


                  itemCount:
                  state.filteredRequests.length,


                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount:
                    1,

                    childAspectRatio:
                    1.5,

                    mainAxisSpacing:
                    16,

                  ),



                  itemBuilder:
                  (context,index){


                    final request =
                    state.filteredRequests[index];



                    return PickupCard(

                      pickupRequest:
                      request,


                      onStatusChange:
                      (status){


                        controller.updateStatus(

                          request.id!,

                          status,

                          schoolId,

                        );


                      },

                    );


                  },

                ),





            ],

          ),

        ),

      ),


    );


  }






  Widget _emptyState(
      BuildContext context
      ){


    return Container(

      width:
      double.infinity,


      padding:
      const EdgeInsets.all(32),



      decoration:
      BoxDecoration(

        color:
        Theme.of(context)
            .cardColor,


        borderRadius:
        BorderRadius.circular(20),


        boxShadow:[

          BoxShadow(

            blurRadius:12,

            color:
            Colors.black12,

          )

        ],


      ),




      child:
      Column(


        children:[



          Container(

            padding:
            const EdgeInsets.all(16),


            decoration:
            BoxDecoration(

              color:
              Colors.green.shade100,

              shape:
              BoxShape.circle,

            ),


            child:
            Icon(

              Icons.check_circle,

              size:
              45,

              color:
              Colors.green,

            ),


          ),




          const SizedBox(
            height:16,
          ),




          Text(

            "staffDashboard.allClear"
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





          const SizedBox(
            height:8,
          ),





          Text(

            "staffDashboard.noRequests"
                .tr(),


            textAlign:
            TextAlign.center,


          ),



        ],


      ),



    );


  }





  @override
  void dispose(){


    ref
        .read(
      staffControllerProvider.notifier,
    )
        .stopAutoRefresh();



    super.dispose();

  }



}
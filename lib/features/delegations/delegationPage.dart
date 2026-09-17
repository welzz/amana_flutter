import 'package:amana_flutter/core/services/DelegationService.dart';
import 'package:amana_flutter/features/login/auth_providers.dart';
import 'package:amana_flutter/models/student.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateDelegationPage extends ConsumerStatefulWidget {
  final List<Student> students;

  const CreateDelegationPage({super.key, required this.students});

  @override
  ConsumerState<CreateDelegationPage> createState() =>
      _CreateDelegationPageState();
}

class _CreateDelegationPageState extends ConsumerState<CreateDelegationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController delegatorNameController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  Student? selectedStudent;

  Future<void> pickDateTime({required bool isStart}) async {
    FocusScope.of(context).unfocus();

    // DATE
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (pickedDate == null) return;

    await Future.delayed(const Duration(milliseconds: 200));

    // TIME
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final finalDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (isStart) {
        startDate = finalDateTime;
      } else {
        endDate = finalDateTime;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
        final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(title:  Text('delegation.createDelegation'.tr())),

      body: Container(
        color: Colors.white,

        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= HEADER =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),

                      decoration: const BoxDecoration(color: Color(0xFF1E3F95)),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/aman-logo.png',
                                height: 40,
                              ),

                              const SizedBox(width: 10),

                              Text(
                                'login.amana'.tr(),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          Text(
                            'delegation.createDelegation'.tr(),
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'delegation.autAnoterPerson'.tr(),
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= STUDENT =================
                    Text(
                      'delegation.student'.tr(),
                      style: TextStyle(
                        color: Color(0xFF1E3F95),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF1E3F95)),
                      ),

                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Student>(
                          value: selectedStudent,
                          isExpanded: true,
                          hint: Text('delegation.selectStudent'.tr()),
                          items: widget.students.map((student) {
                            print(student);

                            return DropdownMenuItem<Student>(
                              value: student,
                              child: Text(
                               isArabic ?  student.name.toString() : student.nameEn.toString() 
                                    ,
                              ),
                            );
                          }).toList(),

                          onChanged: (value) {
                            setState(() {
                              selectedStudent = value;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= DELEGATOR NAME =================
                    Text(
                      'delegation.delegatorName'.tr(),
                      style: TextStyle(
                        color: Color(0xFF1E3F95),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      controller: delegatorNameController,

                      decoration: InputDecoration(
                        hintText: 'delegation.enterdelegatorname'.tr(),

                        contentPadding: const EdgeInsets.all(16),

                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1E3F95),
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1E3F95),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'delegation.pleaseenterdelegatorname'.tr();
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // ================= MOBILE =================
                    Text(
                      'delegation.mobileNumber'.tr(),
                      style: TextStyle(
                        color: Color(0xFF1E3F95),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,

                      decoration: InputDecoration(
                        hintText: 'delegation.entermobilenumber'.tr(),

                        contentPadding: const EdgeInsets.all(16),

                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1E3F95),
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1E3F95),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'delegation.pleaseentermobilenumber'.tr();
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // ================= START DATE =================
                    Text(
                      'delegation.startDate'.tr(),
                      style: TextStyle(
                        color: Color(0xFF1E3F95),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    InkWell(
                      onTap: () => pickDateTime(isStart: true),

                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF1E3F95)),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              startDate == null
                                  ? 'delegation.selectstartdate'.tr()
                                  : DateFormat(
                                      'yyyy-MM-dd HH:mm:ss',
                                    ).format(startDate!),

                              style: const TextStyle(fontSize: 16),
                            ),

                            const Icon(
                              Icons.calendar_month,
                              color: Color(0xFF1E3F95),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= END DATE =================
                    Text(
                      'delegation.endDate'.tr(),
                      style: TextStyle(
                        color: Color(0xFF1E3F95),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    InkWell(
                      onTap: () => pickDateTime(isStart: false),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF1E3F95)),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              endDate == null
                                  ? 'delegation.selectenddate'.tr()
                                  : DateFormat(
                                      'yyyy-MM-dd HH:mm:ss',
                                    ).format(endDate!),

                              style: const TextStyle(fontSize: 16),
                            ),

                            const Icon(
                              Icons.calendar_month,
                              color: Color(0xFF1E3F95),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ================= BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3F95),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),

                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (selectedStudent == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select student'),
                                ),
                              );
                              return;
                            }

                            if (startDate == null || endDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select dates'),
                                ),
                              );
                              return;
                            }

                            try {
                              final loginResponse = ref.read(
                                loginSessionProvider,
                              );

                              final parentId = loginResponse?['userId'];

                              final delegationService = ref.read(
                                delegationServiceProvider,
                              );
                              // print('delegationService');
                              final result = await delegationService
                                  .createDelegation(
                                    studentId: (selectedStudent!.id),

                                    parentId: parentId,

                                    delegateName: delegatorNameController.text,

                                    delegatePhone: mobileController.text,

                                    startTime: startDate!,

                                    endTime: endDate!,
                                  );

                              if (result != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'delegation.delegationcreatedsuccessfully'
                                          .tr(),
                                    ),
                                  ),
                                );

                                Navigator.pop(context);
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },

                        child: Text(
                          'delegation.createDelegation'.tr(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

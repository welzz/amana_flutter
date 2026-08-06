import 'package:amana_flutter/models/bus.dart';
import '../../models/student.dart';

class BusState {
  final bool loading;
  final List<Student> students;
  final Bus? bus;
  final bool disableIamButtonHere;

  const BusState({
    this.loading = false,
    this.students = const [],
    this.bus,
    this.disableIamButtonHere=false
  });

  BusState copyWith({
    bool? loading,
    List<Student>? students,
    Bus? bus,
    bool? disableIamButtonHere,
  }) {
    return BusState(
      loading: loading ?? this.loading,
      students: students ?? this.students,
      bus: bus ?? this.bus,
      disableIamButtonHere: disableIamButtonHere ?? this.disableIamButtonHere
    );
  }
}
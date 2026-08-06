import 'dart:convert';
import 'dart:math';

 import 'package:amana_flutter/core/config/app_config.dart';
import 'package:amana_flutter/models/delegation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

// final delegationServiceProvider = Provider<DelegationService>((ref) {
//   return DelegationService();
// });

// final delegationServiceProvider =
//     Provider<DelegationService>((ref) {

//   return DelegationService(
//     final baseUrl = AppConfig.baseUrl;
//   );
// });
final delegationServiceProvider =
    Provider<DelegationService>((ref) {

  return DelegationService(
    baseUrl:
         AppConfig.baseUrl,
  );
});
class DelegationService {
     final String baseUrl;

  DelegationService({required this.baseUrl});

  // final DioClient _dioClient = DioClient();

  // final String apiUrl = '/delegation';

  // ================= LOAD ALL =================
  Future<List<Delegation>> loadDelegations(
    int parentId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse( '$baseUrl/loadAllDelegationsByParentId/$parentId',),
      );

      // final List data = response.data;
    final data = jsonDecode(response.body) as List;

      return data
          .map((e) => Delegation.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // ================= LOAD BY TOKEN =================
  Future<List<Delegation>> loadDelegationsByToken(
    String token,
    int typeToken,
  ) async {
    try {
      final response = await http.get(
        Uri.parse( 
        '$baseUrl/loadAllDelegationsByToken/$token/$typeToken',),
      );

    final data = jsonDecode(response.body) as List;

      return data
          .map((e) => Delegation.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // ================= LOAD BY SCHOOL IDS =================
Future<List<Delegation>> loadDelegationsBySchoolIds(
  List<int> schoolIds,
) async {
  try {

    final response = await http.post(
      Uri.parse(
        '$baseUrl/loadDelegationsBySchoolIds',
      ),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode(schoolIds),
    );

    final List data = jsonDecode(response.body);

    return data
        .map((e) => Delegation.fromJson(e))
        .toList();

  } catch (e) {
    rethrow;
  }
}

  // ================= CREATE =================
  Future<Delegation?> createDelegation({
  required int studentId,
  required int parentId,
  required String delegateName,
  required String delegatePhone,
  required DateTime startTime,
  required DateTime endTime,
}) async {
  try {

    final delegation = Delegation(
      studentId: studentId,
      parentId: parentId,
      delegateName: delegateName,
      delegatePhone: delegatePhone,
      token: const Uuid().v4(),
      pinCode: _generatePinCode(),
      startTime: startTime,
      endTime: endTime,
      maxUsage: 1,
      usageCount: 0,
      status: DelegationStatus.active,
      createdAt: DateTime.now(),
    );

    final response = await http.post(
      Uri.parse(
        '$baseUrl/delegation/saveNewDelegation',
      ),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode(
        delegation.toJson(),
      ),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {

      return Delegation.fromJson(
        jsonDecode(response.body),
      );
    }

    return null;

  } catch (e) {
    rethrow;
  }
}

  // ================= DELETE =================
 Future<void> cancelDelegation(
  int id,
) async {
  try {

    final response = await http.delete(
      Uri.parse(
        '$baseUrl/deleteDelegation/$id',
      ),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {
      throw Exception(
        'Failed to delete delegation',
      );
    }

  } catch (e) {
    rethrow;
  }
}

  // ================= VALIDATE =================
  Future<Map<String, dynamic>> validateDelegation({
    required String tokenOrPin,
    required int typeTokenOrPin,
  }) async {
    try {
      final delegations = await loadDelegationsByToken(
        tokenOrPin,
        typeTokenOrPin,
      );

      final delegation = delegations.firstWhere(
        (d) =>
            d.token == tokenOrPin ||
            d.pinCode == tokenOrPin,
      );

      final now = DateTime.now();

      if (delegation.status != 'active') {
        return {
          'valid': false,
          'delegation': delegation,
          'error':
              'delegation.error.${delegation.status}',
        };
      }

      if (now.isBefore(delegation.startTime)) {
        return {
          'valid': false,
          'delegation': delegation,
          'error': 'delegation.error.tooEarly',
        };
      }

      if (now.isAfter(delegation.endTime)) {
        await markAsExpired(delegation.id!);

        return {
          'valid': false,
          'delegation': delegation,
          'error': 'delegation.error.expired',
        };
      }

      if (delegation.usageCount >=
          delegation.maxUsage) {
        return {
          'valid': false,
          'delegation': delegation,
          'error':
              'delegation.error.maxUsageReached',
        };
      }

      return {
        'valid': true,
        'delegation': delegation,
      };
    } catch (e) {
      return {
        'valid': false,
        'error': 'delegation.error.notFound',
      };
    }
  }

  // ================= CONFIRM PICKUP =================
  Future<bool> confirmPickup({
    required String tokenOrPin,
    required int typeTokenOrPin,
  }) async {
    try {
      final validation = await validateDelegation(
        tokenOrPin: tokenOrPin,
        typeTokenOrPin: typeTokenOrPin,
      );

      if (!validation['valid']) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // ================= EXPIRE =================
Future<void> markAsExpired(
  int id,
) async {
  try {

    final response = await http.put(
      Uri.parse(
        '$baseUrl/markAsExpired/$id',
      ),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {
      throw Exception(
        'Failed to mark delegation as expired',
      );
    }

  } catch (e) {
    rethrow;
  }
}

  // ================= GET BY TOKEN =================
  Future<Delegation?> getDelegationByToken({
    required String token,
    required int typeTokenPin,
  }) async {
    try {
      final delegations =
          await loadDelegationsByToken(
        token,
        typeTokenPin,
      );

      return delegations.firstWhere(
        (d) => d.token == token,
      );
    } catch (e) {
      return null;
    }
  }

  // ================= PIN CODE =================
  String _generatePinCode() {
    final random = Random();

    return (1000 + random.nextInt(9000))
        .toString();
  }
}
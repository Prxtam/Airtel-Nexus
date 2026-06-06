import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/dio_client.dart';
import 'package:frontend/features/ai/models/ai_responses.dart';

class AIRepository {
  final Dio _dio;

  AIRepository(this._dio);

  Future<AISummaryResponse> generateSummary(String meetingId) async {
    final response = await _dio.post('/ai/meetings/$meetingId/summary');
    return AISummaryResponse.fromJson(response.data);
  }

  Future<AIActionItemsResponse> extractActions(String meetingId) async {
    final response = await _dio.post('/ai/meetings/$meetingId/actions');
    return AIActionItemsResponse.fromJson(response.data);
  }

  Future<AIEmailDraftResponse> draftEmail(String meetingId) async {
    final response = await _dio.post('/ai/meetings/$meetingId/email');
    return AIEmailDraftResponse.fromJson(response.data);
  }

  Future<AISummaryResponse> generateCustomerInsights(String customerId) async {
    final response = await _dio.post('/ai/customers/$customerId/insights');
    return AISummaryResponse.fromJson(response.data);
  }
}

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AIRepository(dio);
});

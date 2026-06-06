import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/ai/repositories/ai_repository.dart';

class AICopilotState {
  final bool isLoading;
  final String? resultText;
  final List<String>? actionItems;
  final String? error;

  AICopilotState({
    this.isLoading = false,
    this.resultText,
    this.actionItems,
    this.error,
  });

  AICopilotState copyWith({
    bool? isLoading,
    String? resultText,
    List<String>? actionItems,
    String? error,
    bool clearResult = false,
    bool clearActionItems = false,
    bool clearError = false,
  }) {
    return AICopilotState(
      isLoading: isLoading ?? this.isLoading,
      resultText: clearResult ? null : (resultText ?? this.resultText),
      actionItems: clearActionItems ? null : (actionItems ?? this.actionItems),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AICopilotNotifier extends StateNotifier<AICopilotState> {
  final AIRepository _repository;

  AICopilotNotifier(this._repository) : super(AICopilotState());

  void clear() {
    state = AICopilotState();
  }

  Future<void> generateSummary(String meetingId) async {
    state = state.copyWith(isLoading: true, clearResult: true, clearActionItems: true, clearError: true);
    try {
      final response = await _repository.generateSummary(meetingId);
      state = state.copyWith(isLoading: false, resultText: response.summary);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> extractActions(String meetingId) async {
    state = state.copyWith(isLoading: true, clearResult: true, clearActionItems: true, clearError: true);
    try {
      final response = await _repository.extractActions(meetingId);
      state = state.copyWith(isLoading: false, actionItems: response.actionItems);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> draftEmail(String meetingId) async {
    state = state.copyWith(isLoading: true, clearResult: true, clearActionItems: true, clearError: true);
    try {
      final response = await _repository.draftEmail(meetingId);
      state = state.copyWith(isLoading: false, resultText: response.emailDraft);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> generateCustomerInsights(String customerId) async {
    state = state.copyWith(isLoading: true, clearResult: true, clearActionItems: true, clearError: true);
    try {
      final response = await _repository.generateCustomerInsights(customerId);
      state = state.copyWith(isLoading: false, resultText: response.summary);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final aiCopilotProvider = StateNotifierProvider.autoDispose<AICopilotNotifier, AICopilotState>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return AICopilotNotifier(repository);
});

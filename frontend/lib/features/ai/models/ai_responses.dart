class AISummaryResponse {
  final String summary;

  AISummaryResponse({required this.summary});

  factory AISummaryResponse.fromJson(Map<String, dynamic> json) {
    return AISummaryResponse(
      summary: json['summary'] as String,
    );
  }
}

class AIActionItemsResponse {
  final List<String> actionItems;

  AIActionItemsResponse({required this.actionItems});

  factory AIActionItemsResponse.fromJson(Map<String, dynamic> json) {
    return AIActionItemsResponse(
      actionItems: (json['action_items'] as List).cast<String>(),
    );
  }
}

class AIEmailDraftResponse {
  final String emailDraft;

  AIEmailDraftResponse({required this.emailDraft});

  factory AIEmailDraftResponse.fromJson(Map<String, dynamic> json) {
    return AIEmailDraftResponse(
      emailDraft: json['email_draft'] as String,
    );
  }
}

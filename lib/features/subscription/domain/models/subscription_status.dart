import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_status.freezed.dart';
part 'subscription_status.g.dart';

@freezed
class SubscriptionStatus with _$SubscriptionStatus {
  const factory SubscriptionStatus({
    @Default(false) bool isPremium,
    @Default(false) bool isActive,
    String? productIdentifier,
    DateTime? expiresAt,
    DateTime? purchaseDate,
    @Default(false) bool willRenew,
  }) = _SubscriptionStatus;
  
  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatusFromJson(json);
}


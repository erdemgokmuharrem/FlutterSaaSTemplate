import 'package:flutter_saas_starter/features/subscription/domain/models/subscription_status.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class SubscriptionRepository {
  Future<void> initialize(String userId);
  Future<SubscriptionStatus> getSubscriptionStatus();
  Future<List<Package>> getAvailablePackages();
  Future<CustomerInfo> purchasePackage(Package package);
  Future<CustomerInfo> restorePurchases();
  Stream<SubscriptionStatus> watchSubscriptionStatus();
}


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_saas_starter/features/subscription/data/repositories/revenuecat_subscription_repository.dart';
import 'package:flutter_saas_starter/features/subscription/domain/models/subscription_status.dart';
import 'package:flutter_saas_starter/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:flutter_saas_starter/features/auth/presentation/providers/auth_provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return RevenueCatSubscriptionRepository();
});

final subscriptionStatusProvider = StreamProvider<SubscriptionStatus>((ref) {
  final subscriptionRepository = ref.watch(subscriptionRepositoryProvider);
  return subscriptionRepository.watchSubscriptionStatus();
});

final isPremiumProvider = Provider<bool>((ref) {
  final subscriptionStatus = ref.watch(subscriptionStatusProvider);
  return subscriptionStatus.valueOrNull?.isPremium ?? false;
});

final availablePackagesProvider = FutureProvider<List<Package>>((ref) async {
  final subscriptionRepository = ref.watch(subscriptionRepositoryProvider);
  return subscriptionRepository.getAvailablePackages();
});

final subscriptionControllerProvider = Provider<SubscriptionController>((ref) {
  return SubscriptionController(ref.watch(subscriptionRepositoryProvider));
});

class SubscriptionController {
  final SubscriptionRepository _subscriptionRepository;
  
  SubscriptionController(this._subscriptionRepository);
  
  Future<void> initialize(String userId) async {
    await _subscriptionRepository.initialize(userId);
  }
  
  Future<CustomerInfo> purchasePackage(Package package) async {
    return await _subscriptionRepository.purchasePackage(package);
  }
  
  Future<CustomerInfo> restorePurchases() async {
    return await _subscriptionRepository.restorePurchases();
  }
}


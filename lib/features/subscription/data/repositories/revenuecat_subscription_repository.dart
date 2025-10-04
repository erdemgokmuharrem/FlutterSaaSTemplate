import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_saas_starter/features/subscription/domain/models/subscription_status.dart';
import 'package:flutter_saas_starter/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:flutter_saas_starter/core/config/config.dart';
import 'package:flutter_saas_starter/core/utils/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatSubscriptionRepository implements SubscriptionRepository {
  bool _initialized = false;
  
  @override
  Future<void> initialize(String userId) async {
    if (_initialized) return;
    
    // Skip initialization on macOS (not fully supported yet)
    if (!kIsWeb && Platform.isMacOS) {
      Logger.warning('RevenueCat not fully supported on macOS - skipping initialization');
      _initialized = true;
      return;
    }
    
    try {
      String apiKey;
      
      if (kIsWeb) {
        // Web uses Android key
        apiKey = AppConfig.revenueCatApiKeyAndroid;
      } else if (Platform.isIOS) {
        apiKey = AppConfig.revenueCatApiKeyIos;
      } else {
        apiKey = AppConfig.revenueCatApiKeyAndroid;
      }
      
      final configuration = PurchasesConfiguration(apiKey);
      await Purchases.configure(configuration);
      await Purchases.logIn(userId);
      
      _initialized = true;
      Logger.info('RevenueCat initialized for user: $userId');
    } catch (e, stackTrace) {
      Logger.error('Failed to initialize RevenueCat', error: e, stackTrace: stackTrace);
      // Don't rethrow - allow app to continue without RevenueCat
      _initialized = true;
    }
  }
  
  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return _parseCustomerInfo(customerInfo);
    } catch (e, stackTrace) {
      Logger.error('Failed to get subscription status', error: e, stackTrace: stackTrace);
      return const SubscriptionStatus();
    }
  }
  
  @override
  Future<List<Package>> getAvailablePackages() async {
    try {
      final offerings = await Purchases.getOfferings();
      
      if (offerings.current == null) {
        Logger.warning('No current offering found');
        return [];
      }
      
      return offerings.current!.availablePackages;
    } catch (e, stackTrace) {
      Logger.error('Failed to get available packages', error: e, stackTrace: stackTrace);
      return [];
    }
  }
  
  @override
  Future<CustomerInfo> purchasePackage(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      Logger.info('Purchase successful: ${package.identifier}');
      return purchaseResult.customerInfo;
    } catch (e, stackTrace) {
      Logger.error('Purchase failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<CustomerInfo> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      Logger.info('Purchases restored successfully');
      return customerInfo;
    } catch (e, stackTrace) {
      Logger.error('Failed to restore purchases', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Stream<SubscriptionStatus> watchSubscriptionStatus() async* {
    // Initial status
    yield await getSubscriptionStatus();
    
    // Listen to updates
    await for (final customerInfo in Purchases.customerInfoStream) {
      yield _parseCustomerInfo(customerInfo);
    }
  }
  
  SubscriptionStatus _parseCustomerInfo(CustomerInfo customerInfo) {
    final entitlements = customerInfo.entitlements.all;
    final premiumEntitlement = entitlements[AppConfig.premiumEntitlementId];
    
    if (premiumEntitlement == null) {
      return const SubscriptionStatus();
    }
    
    return SubscriptionStatus(
      isPremium: premiumEntitlement.isActive,
      isActive: premiumEntitlement.isActive,
      productIdentifier: premiumEntitlement.productIdentifier,
      expiresAt: premiumEntitlement.expirationDate != null
          ? DateTime.parse(premiumEntitlement.expirationDate!)
          : null,
      purchaseDate: premiumEntitlement.originalPurchaseDate != null
          ? DateTime.parse(premiumEntitlement.originalPurchaseDate!)
          : null,
      willRenew: premiumEntitlement.willRenew,
    );
  }
}


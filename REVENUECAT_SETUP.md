# RevenueCat Setup Guide

This guide will help you set up RevenueCat for subscription management in your Flutter app.

## Prerequisites

- App Store Connect account (for iOS)
- Google Play Console account (for Android)
- Products created in stores
- RevenueCat account

## Step 1: Create RevenueCat Account

1. Go to [RevenueCat](https://www.revenuecat.com/)
2. Sign up for a free account
3. Create a new project

## Step 2: Add Your App

### iOS Setup

1. In RevenueCat dashboard, click "Projects"
2. Select your project
3. Click "Apps" > "Add App"
4. Choose "iOS"
5. Enter Bundle ID: `com.fluttersaas.flutterSaasStarter`
6. Upload App Store Connect API Key:
   - Go to App Store Connect
   - Users and Access > Keys > App Store Connect API
   - Generate new key with "App Manager" role
   - Download and upload to RevenueCat

### Android Setup

1. Click "Add App" again
2. Choose "Android"
3. Enter Package Name: `com.fluttersaas.flutter_saas_starter`
4. Upload Google Play Service Account Key:
   - Go to Google Play Console
   - Setup > API access
   - Create service account
   - Grant permissions
   - Create JSON key
   - Upload to RevenueCat

## Step 3: Create Products in Stores

### iOS - App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Select your app
3. Go to Features > In-App Purchases
4. Click "+" to create new subscription
5. Choose "Auto-Renewable Subscription"
6. Create Subscription Group (e.g., "Premium")
7. Add subscription:
   - Product ID: `premium_monthly` or `premium_yearly`
   - Reference Name: "Premium Monthly" / "Premium Yearly"
   - Price: Set your price
   - Duration: 1 month / 1 year
8. Add localization
9. Submit for review

**Example Product IDs:**
- `premium_monthly`
- `premium_yearly`
- `premium_lifetime` (non-renewing)

### Android - Google Play Console

1. Go to [Google Play Console](https://play.google.com/console/)
2. Select your app
3. Monetize > Subscriptions
4. Create subscription
5. Add product:
   - Product ID: `premium_monthly` or `premium_yearly`
   - Name: "Premium Monthly" / "Premium Yearly"
   - Description: Describe benefits
   - Price: Set your price
   - Billing period: 1 month / 1 year
6. Save and activate

**Note**: Product IDs should match between iOS and Android for easier management.

## Step 4: Configure Products in RevenueCat

1. Go to RevenueCat dashboard
2. Products > "Add Product"
3. For each product:
   - Product identifier (from stores)
   - Display name
   - Product type (subscription)
4. Link store products:
   - Click on product
   - Link Apple App Store product
   - Link Google Play product

## Step 5: Create Offerings

Offerings organize products for display in your app.

1. Go to "Offerings"
2. Click "Add Offering"
3. Name it (e.g., "default")
4. Set as current offering
5. Add packages:
   - **Monthly Package**: Link to `premium_monthly`
   - **Yearly Package**: Link to `premium_yearly`
6. Save

**Example Package Configuration:**
```
Offering: default
├── Package: $rc_monthly
│   └── Product: premium_monthly
└── Package: $rc_annual
    └── Product: premium_yearly
```

## Step 6: Create Entitlements

Entitlements represent access levels in your app.

1. Go to "Entitlements"
2. Click "Add Entitlement"
3. Create entitlement:
   - Identifier: `premium`
   - Display name: "Premium Access"
4. Save
5. Attach products to entitlement:
   - Select entitlement
   - Link all premium products

## Step 7: Get API Keys

1. Go to Project Settings > API Keys
2. Copy the following keys:
   - **iOS**: Apple App Store key
   - **Android**: Google Play Store key
3. Keep these keys secure!

## Step 8: Configure in Your App

1. Copy `lib/core/config/config.example.dart` to `lib/core/config/config.dart`
2. Update with your keys:

```dart
class AppConfig {
  static const String revenueCatApiKeyIos = 'appl_xxx...'; // Your iOS key
  static const String revenueCatApiKeyAndroid = 'goog_xxx...'; // Your Android key
  static const String premiumEntitlementId = 'premium';
}
```

3. **NEVER commit `config.dart` to version control!**

## Step 9: Test Purchases

### iOS Sandbox Testing

1. Create sandbox test account:
   - App Store Connect > Users and Access
   - Sandbox Testers > Add Tester
2. On device:
   - Settings > App Store > Sandbox Account
   - Sign in with test account
3. Make test purchase in app
4. Verify in RevenueCat dashboard

### Android Testing

1. Add license testers:
   - Play Console > Setup > License Testing
   - Add email addresses
2. Install app from Play Store (internal testing track)
3. Make test purchase
4. Verify in RevenueCat dashboard

## Step 10: Verify Integration

Run the app and check:

1. Products load correctly
2. Can make test purchase
3. Subscription status updates
4. Premium features unlock
5. Check RevenueCat dashboard for events

## Features Included in Starter

- ✅ RevenueCat SDK integration
- ✅ Product loading
- ✅ Purchase handling
- ✅ Restore purchases
- ✅ Subscription status checking
- ✅ Premium content gating
- ✅ Error handling

## Premium Features Example

In this starter, premium users get:
- Unlimited todos (free: 5 max)
- Priority support
- Ad-free experience
- Cloud sync

To add more premium features:

```dart
// Check if user is premium
final isPremium = ref.watch(isPremiumProvider);

// Gate feature
if (!isPremium) {
  // Show upgrade prompt
  context.goNamed(AppRoute.subscription.name);
  return;
}

// Premium feature code
```

## Troubleshooting

### Products not loading
- Verify API keys are correct
- Check products are configured in RevenueCat
- Ensure products are active in stores
- Check device logs

### Purchase fails
- Verify store products are approved
- Check sandbox/test account setup
- Ensure billing is set up (for testing)
- Review RevenueCat dashboard for errors

### Subscription not detected
- Wait a few minutes for sync
- Call `restorePurchases()`
- Check entitlement configuration
- Verify user ID is set

## Best Practices

1. **Test thoroughly** before production
2. Use **sandbox accounts** for testing
3. Handle **all error cases** gracefully
4. Implement **restore purchases** button
5. Show **clear pricing** to users
6. Follow **store guidelines** for subscriptions
7. Set up **webhooks** for server-side verification

## Going to Production

Before launching:

1. ✅ Products approved in both stores
2. ✅ Offerings configured correctly
3. ✅ Entitlements set up
4. ✅ Test purchases work
5. ✅ Restore purchases tested
6. ✅ Error handling implemented
7. ✅ Analytics set up
8. ✅ Privacy policy updated
9. ✅ Terms of service updated
10. ✅ App review approved

## Monitoring

RevenueCat provides:
- **Dashboard**: View metrics and revenue
- **Charts**: Analyze growth and retention
- **Customer View**: See individual subscriptions
- **Webhooks**: Server-side notifications
- **Integrations**: Connect analytics tools

## Resources

- [RevenueCat Documentation](https://docs.revenuecat.com/)
- [Flutter SDK Guide](https://docs.revenuecat.com/docs/flutter)
- [Sample Apps](https://github.com/RevenueCat/purchases-flutter)
- [Community](https://community.revenuecat.com/)
- [App Store Guidelines](https://developer.apple.com/app-store/subscriptions/)
- [Play Store Guidelines](https://support.google.com/googleplay/android-developer/answer/140504)

## Support

For RevenueCat issues:
- Check [documentation](https://docs.revenuecat.com/)
- Visit [community forum](https://community.revenuecat.com/)
- Contact RevenueCat support

For store issues:
- iOS: App Store Connect support
- Android: Google Play Console support


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_saas_starter/features/subscription/presentation/providers/subscription_provider.dart';
import 'package:flutter_saas_starter/shared/widgets/loading_overlay.dart';

class SubscriptionPage extends ConsumerStatefulWidget {
  const SubscriptionPage({super.key});

  @override
  ConsumerState<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends ConsumerState<SubscriptionPage> {
  bool _isLoading = false;

  Future<void> _handlePurchase(dynamic package) async {
    setState(() => _isLoading = true);

    try {
      await ref.read(subscriptionControllerProvider).purchasePackage(package);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchase successful! Welcome to Premium!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchase failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(subscriptionControllerProvider).restorePurchases();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchases restored successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to restore purchases: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(availablePackagesProvider);
    final subscriptionStatus = ref.watch(subscriptionStatusProvider);

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Premium Subscription'),
        ),
        body: subscriptionStatus.when(
          data: (status) {
            if (status.isPremium) {
              return _buildPremiumActiveView(status);
            }
            return packagesAsync.when(
              data: (packages) => _buildPackagesView(packages),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading packages: $error'),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error loading subscription status: $error'),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumActiveView(dynamic status) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.workspace_premium,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'You are Premium!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (status.expiresAt != null)
              Text(
                'Expires: ${_formatDate(status.expiresAt)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: _handleRestore,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Restore Purchases'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackagesView(List<dynamic> packages) {
    if (packages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 60),
            const SizedBox(height: 16),
            const Text('No subscription packages available'),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: _handleRestore,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Restore Purchases'),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 24),
        Icon(
          Icons.workspace_premium,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Upgrade to Premium',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Unlock all features and get the most out of your experience',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _buildFeaturesList(),
        const SizedBox(height: 32),
        ...packages.map((package) => _buildPackageCard(package)),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _handleRestore,
          child: const Text('Restore Purchases'),
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      'Unlimited Todos',
      'Priority Support',
      'Ad-Free Experience',
      'Cloud Sync',
      'Advanced Features',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: features
              .map(
                (feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        feature,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildPackageCard(dynamic package) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              package.storeProduct.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              package.storeProduct.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  package.storeProduct.priceString,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                ElevatedButton(
                  onPressed: () => _handlePurchase(package),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text('Subscribe'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}


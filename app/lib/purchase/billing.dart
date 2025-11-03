import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

class BillingService {
  static const String kProId = 'pro_unlock';

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<void> init({required void Function(bool) onProUnlocked}) async {
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchases) {
      for (final p in purchases) {
        if (p.productID == kProId &&
            (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored)) {
          onProUnlocked(true);
        }
      }
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}


//
//  InAppPurchasesManager.h
//  Remember when
//
//  Created by René Fernández on 20/02/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface InAppPurchasesManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (InAppPurchasesManager *)sharedInstance;

@property (nonatomic, strong) SKProduct *productDisableAds;
@property (nonatomic, strong) SKProductsRequest *productsRequest;

- (void)requestProductDisableAds;

- (void)purchaseDisableAds;

// public methods
- (void)loadStore;
- (BOOL)canMakePurchases;

@end

//
//  InAppPurchasesManager.m
//  Remember when
//
//  Created by René Fernández on 20/02/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import "InAppPurchasesManager.h"

@implementation InAppPurchasesManager

@synthesize productDisableAds,productsRequest;

+ (InAppPurchasesManager *)sharedInstance
{
	static InAppPurchasesManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[InAppPurchasesManager alloc] init];
        // Do any other initialisation stuff here
		
    });
    return sharedInstance;
}

- (void)requestProductDisableAds{
	
	if ([self canMakePurchases]) {
		
        NSLog(@"Puedo hacer pagos In-App");
		
        // Inicializamos la solicitud con los productos que nos interesen. En este caso solo mandamos el único que tenemos creado.
        productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"com.whenapp.when.disableAds"]];
        productsRequest.delegate = self;
        [productsRequest start];
    }
    else {
        NSLog(@"Control parental activado");
    }
	
}

- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProductDisableAds];
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseDisableAds
{
    // Añadimos el producto que recibimos en el método delegado productsRequest:didReceiveResponse:
    SKPayment *pago = [SKPayment paymentWithProduct:productDisableAds];
    // Nos añadimos a nosotros mismos como observadores de la transacción.
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	[[SKPaymentQueue defaultQueue] addPayment:pago];
}

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kDisableAdsPurchased])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:[NSString stringWithFormat:@"%@_receipt",kDisableAdsPurchased ]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kDisableAdsPurchased])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDisableAdsPurchased ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

//Se ejecuta al recibir datos de requestInAppProducts
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *misProductos = response.products;
	
    NSLog(@"Número de productos devueltos: %i", misProductos.count);
	
    if (misProductos.count > 0) {
		
		for (int i=0; i<[misProductos count]; i++) {
			
			SKProduct *p = [misProductos objectAtIndex:i];
			
			if([p.productIdentifier isEqualToString:kDisableAdsPurchased]){
				productDisableAds = [misProductos objectAtIndex:0];
				//[buttonDisableAds setTitle:@"Comprar canción 0.99€" forState:UIControlStateNormal];
				// Habilitamos el botón de comprar
				//[buttonDisableAds setEnabled:YES];
				NSLog(@"Producto recibido: %@",kDisableAdsPurchased);
			}
			
		}
		
		for (NSString *invalidProductId in response.invalidProductIdentifiers){
			NSLog(@"Invalid product id: %@" , invalidProductId);
		}
		
    }else{
        NSLog(@"Productos no disponibles");
    }
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Error al conectar a la AppStore para las In-App Purchase: %@", error);
}

// Add new method
-(IBAction)restoreCompletedTransactions:(id)sender {
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


@end

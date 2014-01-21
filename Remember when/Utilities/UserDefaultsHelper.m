//
//  UserDefaultsHelper.m
//  Remember when
//
//  Created by René Fernández on 19/02/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import "UserDefaultsHelper.h"


NSString* const kDisableAdsPurchased=@"com.whenapp.when.disableAds";
/*NSString* const kyrIsFirstLaunch=@"IsFirstLaunchOfApp";
NSString* const kyrMustDoFirstSync=@"MustDoFirstSync";
NSString* const kyrMustRegisterBlog=@"MustRegisterBlog";

NSString* const kyrSyncCategoriesOnStart=@"SyncCategoriesOnStart";
NSString* const kyrNumberOfPostsToSync =@"NumberOfPostsToSync";*/

@implementation UserDefaultsHelper

+(NSString*) getUserValueForKey:(NSString*)aKey withDefault:(NSString*)aDefaultValue{
	
	NSString *result = [[NSUserDefaults standardUserDefaults] stringForKey:aKey];
	if(result== nil || [result isEqualToString:@""]){
		return aDefaultValue;
	}
	return result;
}
+ (void) setUserBooleanValue: (BOOL) aValue forKey:(NSString*) aKey{
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:aValue] forKey:aKey];
}

+ (void) setUserStringValue: (NSString*) aValue forKey:(NSString*) aKey{
	[[NSUserDefaults standardUserDefaults] setObject:aValue forKey:aKey];
}

@end

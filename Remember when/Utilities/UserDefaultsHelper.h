//
//  UserDefaultsHelper.h
//  Remember when
//
//  Created by René Fernández on 19/02/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kDisableAdsPurchased;
extern NSString* const kIsFirstLaunch;
/*extern NSString* const kyrNumberOfPostsToSync;
//extern NSString* const kyrBlogAutoId;
//extern NSString* const kyrPostAutoId;
extern NSString* const kyrSyncCategoriesOnStart;
*/

@interface UserDefaultsHelper : NSObject


+ (id) getUserValueForKey:(NSString*)aKey withDefault:(NSString*)aDefaultValue;
+ (void) setUserBooleanValue: (BOOL) aValue forKey:(NSString*) aKey;
+ (void) setUserStringValue: (NSString*) aValue forKey:(NSString*) aKey;

@end

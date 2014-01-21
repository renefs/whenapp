//
//  Moment.h
//  Whenapp
//
//  Created by Rene on 13/06/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Moment : NSManagedObject

@property (nonatomic, retain) NSDate * alarmDate;
@property (nonatomic, retain) NSNumber * alarmEnabled;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * moment_id;
@property (nonatomic, retain) NSString * fullImage;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * thumbnail;

@end

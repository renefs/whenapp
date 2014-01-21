//
//  CoreDataManager.h
//  Remember when
//
//  Created by René Fernández on 12/02/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppDelegate;
@class Moment;
@class MomentWithImage;

@interface CoreDataManager : NSObject

@property(strong,nonatomic) NSManagedObjectContext *context;

+ (CoreDataManager *)sharedInstance;

/**
 Añade un nuevo Momento a Core Data.
 */
-(Moment*) addNewMoment:(NSString*) momentTitle onDate:(NSDate*)date withLatitude:(float) lat andLongitude:(float)longi withThumbnail:(UIImage*) thumb andFullImage:(UIImage*) img;

/**
 Actualiza un Momento ya existente en Core Data. 
 */
-(Moment*) updateExistingMoment:(NSString*) momentTitle onDate:(NSDate*)date withLatitude:(float) lat andLongitude:(float)longi withThumbnail:(UIImage*) thumb andFullImage:(UIImage*) img andOldMoment:(Moment*) m;

/**
 Borra un Momento.
 */
-(BOOL) removeMoment:(Moment*) moment;

/**
 Obtiene todos los Momentos.
 */
- (NSArray*) getAllMoments;
/**
 Devuelve todos los Momentos en forma de array mutable.
 */
- (NSMutableArray*) getAllMomentsMutable;

/**
 Obtiene el último Momento añadido.
 */
- (Moment*) getLastMoment;
/**
 Obtiene el primer Momento añadido.
 */
- (Moment*) getFirstMoment;

@end

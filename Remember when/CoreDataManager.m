//
//  CoreDataManager.m
//  Remember when
//
//  Created by René Fernández on 12/02/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"
#import "Moment.h"

@implementation CoreDataManager

@synthesize context;

+ (CoreDataManager *)sharedInstance
{
	static CoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataManager alloc] init];
        // Do any other initialisation stuff here
		
    });
    return sharedInstance;
}

-(Moment*) addNewMoment:(NSString*) momentTitle onDate:(NSDate*)date withLatitude:(float) lat andLongitude:(float)longi withThumbnail:(UIImage*) thumb andFullImage:(UIImage*) img{
	
	NSError *error;
	
	self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	Moment *newMoment;
	newMoment = [NSEntityDescription insertNewObjectForEntityForName:@"Moment" inManagedObjectContext:context];
	
	newMoment.title=momentTitle;
	newMoment.date=date;
	newMoment.latitude=[NSNumber numberWithFloat:lat];
	newMoment.longitude=[NSNumber numberWithFloat:longi];
    newMoment.Moment_id= [[NSDate alloc] init];
    NSData *imageData = UIImageJPEGRepresentation(thumb, 50);
	newMoment.thumbnail = imageData;
    
    //Saving image to filesystem
    NSData *jpgData = UIImageJPEGRepresentation(img, 70);
    
    
    NSString *filePath;
	if(img){
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
		filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[newMoment.moment_id description]]]; //Add the file name
		[jpgData writeToFile:filePath atomically:YES];
	}else{
		filePath=@"";
	}
	
	newMoment.fullImage=filePath;
	
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		return nil;
	}
	
	return newMoment;
	
}

-(Moment*) updateExistingMoment:(NSString*) momentTitle onDate:(NSDate*)date withLatitude:(float) lat andLongitude:(float)longi withThumbnail:(UIImage*) thumb andFullImage:(UIImage*) img andOldMoment:(Moment*) m{
	
	NSError *error;
	
	self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	[self removeMoment:m];
	
	Moment *newMoment;
	newMoment = [NSEntityDescription insertNewObjectForEntityForName:@"Moment" inManagedObjectContext:context];
	
	newMoment.title=momentTitle;
	newMoment.date=date;
	newMoment.latitude=[NSNumber numberWithFloat:lat];
	newMoment.longitude=[NSNumber numberWithFloat:longi];
    newMoment.Moment_id= [[NSDate alloc] init];
    NSData *imageData = UIImageJPEGRepresentation(thumb, 50);
	newMoment.thumbnail = imageData;
    
    //Saving image to filesystem
    NSData *jpgData = UIImageJPEGRepresentation(img, 70);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
	
	NSString *filePath;
	if(img){
		filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[newMoment.moment_id description]]]; //Add the file name
		[jpgData writeToFile:filePath atomically:YES];
	}else{
		filePath=@"";
	}
    
    newMoment.fullImage=filePath;
	
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		return nil;
	}
	
	return newMoment;
	
}


-(BOOL) removeMoment:(Moment*) moment{
	
	NSError *error;
	
	self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	[self.context deleteObject:moment];
	
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't remove: %@", [error localizedDescription]);
		return NO;
	}
	
	return YES;
	
}

- (NSArray*) getAllMoments{
	
	self.context =  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Moment" inManagedObjectContext:context];
	[fetch setEntity:entity];
	
	NSError *error;
	NSArray *result = [context executeFetchRequest:fetch error:&error];
	
	if(!result){
		NSLog(@"%@", [error localizedDescription]);
		return nil;
	}
	
	return result;
}

- (Moment*) getFirstMoment{
	
	self.context =  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Moment" inManagedObjectContext:context];
	[fetch setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetch setSortDescriptors:sortDescriptors];
    
    [fetch setFetchLimit:1];
	
	NSError *error;
	NSArray *result = [context executeFetchRequest:fetch error:&error];
	
	if(!result){
		NSLog(@"%@", [error localizedDescription]);
		return nil;
	}
	
	if([result count]<=0){
		return nil;
	}
	
	return (Moment*)[result objectAtIndex:0];
}

- (Moment*) getLastMoment{
	
	self.context =  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Moment" inManagedObjectContext:context];
	[fetch setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetch setSortDescriptors:sortDescriptors];
    
    [fetch setFetchLimit:1];
	
	NSError *error;
	NSArray *result = [context executeFetchRequest:fetch error:&error];
	
	if(!result){
		NSLog(@"%@", [error localizedDescription]);
		return nil;
	}
	
	if([result count]<=0){
		NSLog(@"Last moment not found.");
		return nil;
	}
	
	return (Moment*)[result objectAtIndex:0];
}

- (NSMutableArray*) getAllMomentsMutable{
	
	NSArray *moments = [self getAllMoments];
	
	NSMutableArray *result = [moments mutableCopy];
	
	return result;
}


@end

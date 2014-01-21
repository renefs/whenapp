//
//  PositionAnnotation.m
//  Remember when
//
//  Created by René Fernández on 05/03/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation

//@synthesize image,title,subtitle;

- (id)initWithTitle:(NSString*) tit andSubtitle:(NSString*)sub onCoordinate:(CLLocationCoordinate2D)coord{
	self = [super init];
    if (self) {
        //self.image = img;
		title=tit;
		subtitle=sub;
		coordinate=coord;
    }
    
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord{
	self = [super init];
    if (self) {
        //self.image = img;
		coordinate=coord;
    }
    
    return self;
}

- (id)initWithImage:(UIImage *)img andTitle:(NSString*) tit andSubtitle:(NSString*)sub onCoordinate:(CLLocationCoordinate2D)coord{
    self = [super init];
    if (self) {
        image = img;
		title=tit;
		subtitle=sub;
		coordinate=coord;
    }
    
    return self;
}

/*- (CLLocationCoordinate2D)coordinate {
    CLLocation *annotationLocation = (CLLocation *)[annotationAsset valueForProperty:ALAssetPropertyLocation];
    return annotationLocation.coordinate;
}*/

- (UIImage *)image {
    return image;
}

- (NSString *)title {
    return title;
}

- (NSString *)subtitle {
    return subtitle;
}

- (CLLocationCoordinate2D)coordinate {
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

/*- (NSComparisonResult)compareByDate:(MapAnnotation *)other {
 NSDate *myDate = [annotationAsset valueForProperty:ALAssetPropertyDate];
 NSDate *otherDate = [other.annotationAsset valueForProperty:ALAssetPropertyDate];
 
 return [myDate compare:otherDate];
 }*/

@end


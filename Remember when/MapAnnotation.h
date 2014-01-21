//
//  PositionAnnotation.h
//  Remember when
//
//  Created by René Fernández on 05/03/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	UIImage *image;
}

//@property (nonatomic,strong) NSString *title;
//@property (nonatomic,strong) NSString *subtitle;
//@property (nonatomic, retain) UIImage *image;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;

- (id)initWithTitle:(NSString*) tit andSubtitle:(NSString*)sub onCoordinate:(CLLocationCoordinate2D)coord;

- (id)initWithImage:(UIImage *)img andTitle:(NSString*) tit andSubtitle:(NSString*)sub onCoordinate:(CLLocationCoordinate2D)coord;
//- (NSComparisonResult)compareByDate:(MapAnnotation *)other;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (UIImage *)image;

@end


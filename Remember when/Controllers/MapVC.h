//
//  MapVC.h
//  Remember when
//
//  Created by René Fernández on 04/03/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "MomentDetailVC.h"

@interface MapVC : UIViewController <MKMapViewDelegate>{
	//CLLocationManager *locationManager;
	//CLLocationCoordinate2D userLocation;
	NSMutableArray *annotations;
	NSInteger currentAnnotationIndex;
	 //CLLocationCoordinate2D ubicacion;
}
/**
 Mapa sobre el que se mostrarán los eventos
 */
@property (nonatomic,strong) IBOutlet MKMapView *map;

@property (strong,nonatomic) Moment *currentMoment;


@property (strong,nonatomic) NSMutableArray *moments;

@property (nonatomic,strong) MKPinAnnotationView *posicion;
@property (nonatomic,strong) MapAnnotation *point;

@property (nonatomic,strong) IBOutlet UISegmentedControl *segmentedButton;
@property (nonatomic) int currentFocusedMoment;


@end

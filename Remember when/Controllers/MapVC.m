//
//  MapVC.m
//  Remember when
//
//  Created by René Fernández on 04/03/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import "MapVC.h"

#import "CoreDataManager.h"
#import "Moment.h"
#import "DateHelper.h"

@interface MapVC ()

@end

@implementation MapVC

@synthesize map,moments,segmentedButton,currentFocusedMoment,currentMoment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillLayoutSubviews{
	
	[super viewWillLayoutSubviews];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg-orange-pattern.png"] forBarMetrics:UIBarMetricsDefault];
	
	[self.segmentedButton setBackgroundImage:[UIImage imageNamed:@"bg-orange-pattern.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	
	[self.segmentedButton setDividerImage:[UIImage imageNamed:@"bg-orange-pattern.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	
	self.segmentedButton.selectedSegmentIndex = -1;
	
	[[UIApplication sharedApplication]
	 setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

-(void)removeAllAnnotations
{
    id userAnnotation = self.map.userLocation;
	
    NSMutableArray *annota = [NSMutableArray arrayWithArray:self.map.annotations];
    [annota removeObject:userAnnotation];
	
    [self.map removeAnnotations:annotations];
}

-(void) viewWillDisappear:(BOOL)animated{
	
	[super viewWillDisappear:animated];
	
	//[locationManager stopUpdatingLocation];
	[self removeAllAnnotations];
}

-(void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	
	//[locationManager startUpdatingLocation];
	
	//[[LARSAdController sharedManager] addAdContainerToViewInViewController:self.navigationController];
	NSLog(@"before getAllMoments");
	self.moments = [[CoreDataManager sharedInstance] getAllMomentsMutable];
	NSLog(@"after getAllMoments");
	[self.map removeAnnotations:self.map.annotations];
	
	//if (!annotations) {
        annotations = [[NSMutableArray alloc] init];
    /*} else {
        [annotations removeAllObjects];
    }*/
	
	NSLog(@"Events count: %d", self.moments.count);
	
	NSLog(@"Annotations count: %d", annotations.count);
	for (Moment* e in self.moments) {
		
		//DateHelper *dateHelper = [[DateHelper alloc] init];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"dd/MM/YYY HH:mm"];
		
		NSString *dateString = [formatter stringFromDate:e.date];
		
		MapAnnotation *mapAnnotation = [[MapAnnotation alloc] initWithImage:[UIImage imageWithData:e.thumbnail] andTitle:e.title andSubtitle:dateString onCoordinate:CLLocationCoordinate2DMake([e.latitude floatValue], [e.longitude floatValue])];
		[annotations addObject:mapAnnotation];
		
		
		[self.map addAnnotation:mapAnnotation];
	}
	NSLog(@"Annotations count: %d", annotations.count);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"mapAnnotation"];
    
	
	if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
    if (pinAnnotationView) {
        [pinAnnotationView prepareForReuse];
    } else {
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapAnnotation"];
    }
    
    pinAnnotationView.canShowCallout = YES;
    
    //CGImageRef thumbnailImageRef = [[(MapAnnotation *)annotation annotationAsset] thumbnail];
    UIImage *thumbnail = [(MapAnnotation *)annotation image];
	
    UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnail];
    CGRect newBounds = CGRectMake(0.0, 0.0, 32.0, 32.0);
    [thumbnailImageView setBounds:newBounds];
    pinAnnotationView.leftCalloutAccessoryView = thumbnailImageView;
    
    UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinAnnotationView.rightCalloutAccessoryView = disclosureButton;
    [disclosureButton addTarget:self action:@selector(showFullSizeImage:) forControlEvents:UIControlEventTouchUpInside];
	
    
    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	
	NSLog(@"Selected annotationview");
	
	MapAnnotation *an = view.annotation;
	
	NSLog(@"%@",an);
	
	if ([view.annotation isKindOfClass:[MapAnnotation class]]) {
		
		currentAnnotationIndex=[annotations indexOfObject:an];
		
		//if([self.events count]>0 && currentAnnotationIndex >-1 && currentAnnotationIndex < ([self.events count]-1))
		//self.currentEvent = [self.events objectAtIndex:currentAnnotationIndex];
		NSLog(@"Index: %d",currentAnnotationIndex);
		
		NSLog(@"Title: %@",self.currentMoment.title);
	}
	
	NSLog(@"Annotations count: %d", annotations.count);
}

- (void)showFullSizeImage:(id)sender {
	NSLog(@"Disclosure touched up!");
	
	MomentDetailVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MomentDetailVC"];
	
	self.currentMoment = [self.moments objectAtIndex:currentAnnotationIndex];
	
	[self.map deselectAnnotation:[annotations objectAtIndex:currentAnnotationIndex] animated:YES];
	
	controller.moment= self.currentMoment;
	
	controller.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	
}

- (void) pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSLog(@"Pulsado segemented");
    NSLog(@"%d", [segmentedControl selectedSegmentIndex]);
	
	if([self.moments count]>1){
		
		NSLog(@"Antes: %d",self.currentFocusedMoment);
		
		switch ([segmentedControl selectedSegmentIndex]) {
			case 0:
				
				if(self.currentFocusedMoment==0 || self.currentFocusedMoment==-1){
					self.currentFocusedMoment=[self.moments count]-1;
				}else{
					self.currentFocusedMoment-=1;
				}
				
				break;
				
			case 1:
				
				if(self.currentFocusedMoment== [self.moments count]-1){
					self.currentFocusedMoment=0;
				}else{
					self.currentFocusedMoment+=1;
				}
				
				break;
				
			default:
				break;
		}
		
		NSLog(@"Después: %d",self.currentFocusedMoment);
		
		MKCoordinateRegion region;
		
		MapAnnotation* e = [annotations objectAtIndex:self.currentFocusedMoment];
		//MapAnnotation *pin = [[MKPointAnnotation alloc] init];
		//NSLog(@"Añadiendo anotación: (%f,%f)", [e.latitude floatValue],[e.longitude floatValue]);
		//e.coordinate=CLLocationCoordinate2DMake([e.latitude floatValue], [e.longitude floatValue]);
		
		region = MKCoordinateRegionMakeWithDistance(e.coordinate, 2000, 2000);
		[self.map setRegion:region animated:YES];
		
		[self.map selectAnnotation:e animated:YES];
	}
	
}

/*- (void)locationManager:(CLLocationManager *)manager     didUpdateLocations:(NSArray *)locations {
 userLocation = [locations objectAtIndex:0];
 NSLog(@"Localización actualizada: lat%f - lon%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
 [locationManager stopUpdatingLocation];
 
 //[locationManager stopUpdatingLocation];
 }*/


-(void) viewDidAppear:(BOOL)animated{
	
	[super viewDidAppear:animated];
	
	[self.segmentedButton addTarget:self
							 action:@selector(pickOne:)
				   forControlEvents:UIControlEventValueChanged];
	self.currentFocusedMoment=-1;
	self.map.showsUserLocation=NO;
	
	[self centerOnUserLocation];
	
	//[self centerOnUserLocation];
	UIView *legalView = nil;
	for (UIView *subview in self.map.subviews) {
		if ([subview isKindOfClass:[UILabel class]]) {
			NSLog(@"Found map label iOS 6 >");
			// Legal label iOS 6
			legalView = subview;
		} else if ([subview isKindOfClass:[UIImageView class]]) {
			// google image iOS 5 and lower
			NSLog(@"Found map label iOS 5 <");
			legalView = subview;
		}
	}
	NSLog(@"Legal width: %f",legalView.frame.origin.x);
	NSLog(@"Legal height: %f",legalView.frame.origin.y);
	
	legalView.frame = CGRectMake(10, 10, legalView.frame.size.width, legalView.frame.size.height);
	
	
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
	//Si se termina de hacer "drag", se actualiza la ubicación del pin.
	/* if (newState == MKAnnotationViewDragStateEnding)
	 {
	 CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
	 NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
	 //ubicacion=droppedAt;
	 self.point.coordinate=droppedAt;
	 }*/
}

-(IBAction)centerOnUserLocationOnTouch:(id)sender{
	[self centerOnUserLocation];
}




-(void)centerOnUserLocation{
	
	MKCoordinateRegion region;
	if(annotations.count>0){
		MapAnnotation *lastAnnotation = [annotations objectAtIndex:([annotations count]-1)];
		
		region = MKCoordinateRegionMakeWithDistance(lastAnnotation.coordinate, 2000, 2000);
		[self.map setRegion:region animated:YES];
	}
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

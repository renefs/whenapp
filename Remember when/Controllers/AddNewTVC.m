//
//  AddNewTVC.m
//  Remember when
//
//  Created by René Fernández on 12/02/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import "AddNewTVC.h"
#import "ActionSheetPicker.h"
#import "CoreDataManager.h"



#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"

@interface AddNewTVC ()

@end

@implementation AddNewTVC

@synthesize selectedDate,selectedTime,textMoment,cellDate,cellTime,cellMomentTitle,cellImage,moment,editingExistingMoment;

@synthesize tableView,daContainer,point,posicion;

@synthesize map,cellMap;

@synthesize delegate;

@synthesize fullImage,thumbnail;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"AddNewTVC: viewDidLoad");
	//Map
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.selectedDate = [NSDate date];
	self.selectedTime = self.selectedDate;
	
	//self.tableView.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
	[self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_bg.png"]]];
	
	//self.selectedDateAlarm = self.selectedDate;
	//self.selectedTimeAlarm = self.selectedDate;

	//[self.navigationItem.rightBarButtonItem  setBackgroundImage:[UIImage imageNamed:@"17-check.png"] forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
	
	UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	[cancelButton setImage:[UIImage imageNamed:@"60-x.png"] forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	
	
	UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	[saveButton setImage:[UIImage imageNamed:@"17-check.png"] forState:UIControlStateNormal];
	[saveButton addTarget:self action:@selector(addNewMoment:) forControlEvents:UIControlEventTouchUpInside];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
	
	
	//[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg-orange-pattern.png"] forBarMetrics:UIBarMetricsDefault];
	
	NSLog(@"%f, %f",self.cellMap.contentView.frame.size.width,self.cellMap.contentView.frame.size.height);
	
	self.map = [[MKMapView alloc] initWithFrame:CGRectMake(self.cellMap.contentView.frame.origin.x,
														   self.cellMap.contentView.frame.origin.y,
														   self.cellMap.contentView.frame.size.width-20,
														   self.cellMap.contentView.frame.size.height-5)];
    
	self.map.zoomEnabled=YES;
	self.map.userInteractionEnabled=YES;
	self.map.delegate=self;
	//self.map.userTrackingMod
	//[self.view addSubview:self.mapView];
	self.map.layer.cornerRadius = 10.0;
	[cellMap.contentView addSubview:self.map];
	//[map sizeToFit];
	//cellMap.frame.size.height=100;
	
	self.cellImage.textLabel.text = @"Image";
	self.cellImage.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	/*self.cellImage.imageView.layer.masksToBounds = YES;
	self.cellImage.imageView.layer.cornerRadius = 5.0;*/
	self.cellImage.imageView.image = [UIImage imageNamed:@"57.png"];
	
	
	[self createGestureRecognizers];
    
    [self.map removeAnnotations:self.map.annotations];
	
	if(!self.moment){
		
		//NSLog(@"TIME: %@",self.selectedTimeAlarm);
		//NSLog(@"DATE: %@",self.selectedDateAlarm);
		self.map.showsUserLocation=YES;
		
		[self centerOnUserLocation];
		self.editingExistingMoment=NO;
		
		self.thumbnail = [UIImage imageNamed:@"57.png"];
		
	}else{
		
		self.map.showsUserLocation=NO;
		self.textMoment.text=self.moment.title;
		self.selectedDate=self.moment.date;
		self.selectedTime=self.moment.date;
		self.cellImage.imageView.image= [UIImage imageWithData:self.moment.thumbnail];
        NSData *jpgData = [NSData dataWithContentsOfFile:self.moment.fullImage];
        UIImage *img = [UIImage imageWithData:jpgData];
        self.fullImage=img;
		self.thumbnail = [UIImage imageWithData:self.moment.thumbnail];
		
		//self.selectedDateAlarm=self.Moment.alarmDate;
		//self.selectedTimeAlarm=self.Moment.alarmDate;
		
		location = [[CLLocation alloc] initWithLatitude:[self.moment.latitude floatValue] longitude:[self.moment.longitude floatValue]];
		
		self.point = [[MapAnnotation alloc] initWithCoordinate:location.coordinate];
		
		self.posicion = [[MKPinAnnotationView alloc] initWithAnnotation: self.point reuseIdentifier: @"myPin"];
		self.posicion.draggable=YES;
		self.posicion.selected=YES;
		
		[self.map addAnnotation:self.point];
		
		
		
		[self centerOnExistingLocation];
		
		self.editingExistingMoment=YES;
		
		//location = CLLocationCoordinate2DMake([self.Moment.latitude floatValue], [self.Moment.longitude floatValue]);
	}
	
}

- (void)locationManager:(CLLocationManager *)manager     didUpdateLocations:(NSArray *)locations {
    
	if(!moment){
		location = [locations objectAtIndex:0];
		NSLog(@"didUpdateLocations: lat: %f - lon: %f", location.coordinate.latitude, location.coordinate.longitude);
		
		
		[self centerOnUserLocation];
		
		[locationManager stopUpdatingLocation];
		
	}
}

-(void)centerOnUserLocation{
	
	
	[locationManager startUpdatingLocation];
	MKCoordinateRegion region;
	
	if(!location){
		NSLog(@"Ubicación inicial no establecida. A Nueva York.");
		
		self.point = [[MapAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(41.145495, -73.994901)];
		region = MKCoordinateRegionMakeWithDistance(self.point.coordinate, 2000, 2000);
		
	}else{
		self.point = [[MapAnnotation alloc] initWithCoordinate:location.coordinate];
		region = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000);
	}
	
	NSLog(@"Iniciando posición");
	
	NSLog(@"Centrando en %f,%f", location.coordinate.latitude, location.coordinate.longitude);
	
    [self.map setRegion:region animated:YES];
	
	//self.point = [[MapAnnotation alloc] initWithCoordinate:location.coordinate]; // Or whatever coordinates...
	
	self.posicion = [[MKPinAnnotationView alloc] initWithAnnotation: self.point reuseIdentifier: @"myPin"];
	self.posicion.draggable=YES;
	self.posicion.selected=YES;
	
}

-(void)centerOnExistingLocation{
	
	MKCoordinateRegion region;
	
	self.point = [[MapAnnotation alloc] initWithCoordinate:location.coordinate];
	region = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000);
	
	NSLog(@"Iniciando posición");
	
	NSLog(@"Centrando en %f,%f", location.coordinate.latitude, location.coordinate.longitude);
	
    [self.map setRegion:region animated:YES];
	
	//self.point = [[MapAnnotation alloc] initWithCoordinate:location.coordinate]; // Or whatever coordinates...
	
	self.posicion = [[MKPinAnnotationView alloc] initWithAnnotation: self.point reuseIdentifier: @"myPin"];
	self.posicion.draggable=YES;
	self.posicion.selected=YES;
	
}


- (void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	
	//[[LARSAdController sharedManager] addAdContainerToViewInViewController:self.navigationController];
	
	NSLog(@"Estableciendo cellImage...");
	self.cellImage.imageView.image = self.thumbnail;
	
	[self.tableView setNeedsLayout];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
	
	self.cellDate.detailTextLabel.text = [dateFormatter stringFromDate:self.selectedDate];
	
	[dateFormatter setDateFormat:@"HH:mm"];
	
	self.cellTime.detailTextLabel.text = [dateFormatter stringFromDate:self.selectedTime];
	
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
	//Si se termina de hacer "drag", se actualiza la ubicación del pin.
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
		//ubicacion=droppedAt;
		self.point.coordinate=droppedAt;
    }
}

/*- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:kLARSAdObserverKeyPathIsAdVisible]) {
        NSLog(@"Observing keypath \"%@\"", keyPath);
        
        BOOL anyAdsVisible = [change[NSKeyValueChangeNewKey] boolValue];
        if (anyAdsVisible) {
            NSLog(@"Ad is visible");
        }
        else{
            NSLog(@"Ad not visible");
			//self.view.frame=self.view.superview.frame;
        }
    }
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)selectADate:(id)sender {
	
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate target:self action:@selector(dateWasSelected:element:) origin:sender ];
	
    self.actionSheetPicker.hideCancel = NO;
    [self.actionSheetPicker showActionSheetPicker];
}

- (void)selectATime:(id)sender {
	
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeTime selectedDate:self.selectedTime target:self action:@selector(timeWasSelected:element:) origin:sender ];
	
    self.actionSheetPicker.hideCancel = NO;
    [self.actionSheetPicker showActionSheetPicker];
}

- (void)dateWasSelected:(NSDate *)sd element:(id)element {
    self.selectedDate = sd;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *date = [dateFormatter stringFromDate:self.selectedDate];
	
	self.cellDate.detailTextLabel.text = date;
}

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    //MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
    /*if (pin == nil) {
	 pin = [[MKPinAnnotationView alloc] initWithAnnotation: self.point reuseIdentifier: @"myPin"]; // If you use ARC, take out 'autorelease'
	 
	 } else {*/
	// pin.annotation = self.point;
    /*}
	 pin.draggable = YES;
	 pin.selected=YES;*/
	
    return self.posicion;
}

- (void)timeWasSelected:(NSDate *)sd element:(id)element {
    self.selectedTime = sd;
    
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *time = [dateFormatter stringFromDate:self.selectedTime];
	
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    //self.dateTextField.text = [self.selectedDate description];
	self.cellTime.detailTextLabel.text = time;
}

-(void)createGestureRecognizers {
	
	
	//¿Puede funcionar con perform(selector)?
	UITapGestureRecognizer *tapCellDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellDateTap:)];
	tapCellDate.numberOfTapsRequired = 1;
	[cellDate addGestureRecognizer:tapCellDate];
	
	UITapGestureRecognizer *tapCellTime = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellTimeTap:)];
	tapCellTime.numberOfTapsRequired = 1;
	[cellTime addGestureRecognizer:tapCellTime];
	
	//UITapGestureRecognizer *tapCellReminder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellReminderTap:)];
	//tapCellReminder.numberOfTapsRequired = 1;
	//[cellReminder addGestureRecognizer:tapCellReminder];
	
	//Perder el foco del campo de texto tocando fuera
	//UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	//tap.cancelsTouchesInView = NO;
	//[self.view addGestureRecognizer:tap];
	
	UITapGestureRecognizer *tapCellImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellImageTap:)];
	tapCellImage.numberOfTapsRequired = 1;
	[self.cellImage addGestureRecognizer:tapCellImage];
	
}

- (void)handleCellImageTap:(UIGestureRecognizer *)sender {
	NSLog(@"Cell Image");
	[self showImagesActionSheet];
	//[self selectADate:self.cellDate];
}

- (void)handleCellDateTap:(UIGestureRecognizer *)sender {
	NSLog(@"Date selected");
	[self selectADate:self.cellDate];
}

- (void)handleCellTimeTap:(UIGestureRecognizer *)sender {
	NSLog(@"Time selected");
	[self selectATime:self.cellTime];
}

- (IBAction)dismissView:(id)sender{
	NSLog(@"Dismiss View");
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissKeyboard {
	[self.textMoment resignFirstResponder];
}

- (IBAction)addNewMoment:(id)sender{
	
	if([self.textMoment.text isEqualToString:@""] || [self.cellDate.detailTextLabel.text isEqualToString:@""]){
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Fields can not be empty." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
		[alert show];
	}else{
		
		if(self.selectedDate && self.selectedDate){
			
			NSLog(@"DATE: %@",self.selectedDate);
			NSLog(@"TIME: %@",self.selectedTime);
			
			NSCalendar *cal = [NSCalendar currentCalendar];
			[cal setTimeZone:[NSTimeZone defaultTimeZone]];
			
			NSDateComponents *newComps = [[NSDateComponents alloc] init];
			
			NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self.selectedDate];
			
			int year = [components year];
			int month = [components month];
			int day = [components day];
			
			[newComps setYear:year];
			[newComps setMonth:month];
			[newComps setDay:day];
			
			components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:self.selectedTime];
			
			int hour = [components hour];
			int minute = [components minute];
			
			[newComps setHour:hour];
			[newComps setMinute:minute];
			
			NSLog(@"New Components: %@",newComps);
			
			NSDate *newDate = [cal dateFromComponents:newComps];
			NSLog(@"NEW DATE: %@",newDate);
			
			CoreDataManager* sharedManager = [CoreDataManager sharedInstance];
			//AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
			
			
			if(self.editingExistingMoment){
				
				//[app.Moments removeObject:self.Moment];
				Moment *existingMoment;
				//existingMoment=[sharedManager updateExistingMoment:self.textMoment.text onDate:newDate withLatitude:self.point.coordinate.latitude andLongitude:self.point.coordinate.longitude withImage:self.cellImage.imageView.image];
                
                existingMoment = [sharedManager updateExistingMoment:self.textMoment.text onDate:newDate withLatitude:self.point.coordinate.latitude andLongitude:self.point.coordinate.longitude withThumbnail:self.thumbnail andFullImage:self.fullImage andOldMoment:self.moment];
                
				if(existingMoment){
					[self.delegate addItemViewController:self didFinishUpdatingExistingMoment:existingMoment];
					[self dismissViewControllerAnimated:YES completion:nil];
					
					
					NSLog(@"Updating new Moment...");
					//[existingMoment updateImages];
					//[app.Moments addObject:existingMoment];
					
					
				}else{
					UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Moment could not be updated" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
					[alert show];
				}
				
			}else{
				Moment *newMoment;
				newMoment=[sharedManager addNewMoment:self.textMoment.text onDate:newDate withLatitude:self.point.coordinate.latitude andLongitude:self.point.coordinate.longitude withThumbnail:self.thumbnail andFullImage:self.fullImage];
				if(newMoment){
					[self dismissViewControllerAnimated:YES completion:nil];
					
					NSLog(@"Adding new Moment...");
					//[newMoment updateImages];
					//[app.Moments addObject:newMoment];
					
				}else{
					UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Moment could not be saved" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
					[alert show];
				}
				
			}
			
			
		}
		
		
	}
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	
	/*if ([[segue identifier] isEqualToString:@"setAlarm"])
    {
        // Get reference to the destination view controller
        SetAlarmTVC *vc = [segue destinationViewController];
		//ViewControllerB *viewControllerB = [[ViewControllerB alloc] initWithNib:@"ViewControllerB" bundle:nil];
		vc.delegate = self;
		//[[self navigationController] pushViewController:viewControllerB animated:YES];
		
		NSLog(@"Set Alarm.");
        // Pass any objects to the view controller here, like...
		[vc setAlarmViewWithDate:self.selectedDateAlarm andTime:self.selectedTimeAlarm andMessage:self.textMoment.text andAlarmStatus:self.alarmOn];
    }*/
	
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

/*- (void)addItemViewController:(SetAlarmTVC *)controller didFinishEnteringDate:(NSDate *)date andTime:(NSDate*) time andAlarmStatus:(BOOL) status
{
    //NSLog(@"This was returned from ViewControllerB %@",item);
	self.selectedDateAlarm=date;
	self.selectedTimeAlarm=time;
	self.alarmOn=status;
}*/

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	
}

-(void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	//[[LARSAdController sharedManager] removeObserver:self forKeyPath:kLARSAdObserverKeyPathIsAdVisible];
	
	[locationManager stopUpdatingLocation];
	
	//Para disminuir el consumo de memoria...
	//[self.map removeAnnotations:self.map.annotations];
	//self.map.mapType = MKMapTypeStandard;
	//[self.map removeFromSuperview];
    //self.map = nil;
	//Fin disminuir consumo de memoria.
	
}

- (void)showImagesActionSheet{
	NSString *actionSheetTitle = @"Select source"; //Action Sheet Title
	//NSString *destructiveTitle = @"Destructive Button"; //Action Sheet Button Titles
	NSString *other1 = @"Camera";
	NSString *other2 = @"Library";
	NSString *other3 = @"Album";
	NSString *cancelTitle = @"Cancelar";
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:actionSheetTitle
								  delegate:self
								  cancelButtonTitle:cancelTitle
								  destructiveButtonTitle:nil
								  otherButtonTitles:other1, other2, other3, nil];
	[actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	
	if ([buttonTitle isEqualToString:@"Camera"]) {
		
		[self showCameraAction];
		
		
		NSLog(@"Camera");
	}
	if ([buttonTitle isEqualToString:@"Library"]) {
		
		[self showLibraryAction];
		
		NSLog(@"Library");
	}
	if ([buttonTitle isEqualToString:@"Album"]) {
		
		[self showAlbumAction];
		
		NSLog(@"Album");
	}
	if ([buttonTitle isEqualToString:@"Cancelar"]) {
		NSLog(@"Cancelar");
	}
	
}


-(void)showCameraAction
{
    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
    imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
    imagePickController.delegate=self;
    imagePickController.allowsEditing=YES;
    [self presentViewController:imagePickController animated:YES completion:nil];
}

-(void)showLibraryAction
{
    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
    imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickController.delegate=self;
    imagePickController.allowsEditing=YES;
    [self presentViewController:imagePickController animated:YES completion:nil];
}

-(void)showAlbumAction
{
    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
    imagePickController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickController.delegate=self;
    imagePickController.allowsEditing=YES;
    [self presentViewController:imagePickController animated:YES completion:nil];
}

-(IBAction)saveImageAction:(id)sender
{
	 /*UIImage *image=self.cellImage.imageView.image;
	 UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);*/
	 //saveImageBotton.enabled=FALSE;
}

#pragma mark - When finish shoot

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@"didFinishPickingMediaWithInfo");
	NSLog(@"%@",info);
    self.fullImage=[info objectForKey:UIImagePickerControllerEditedImage];
    self.thumbnail = [self.fullImage thumbnailImage:40 transparentBorder:0 cornerRadius:0 interpolationQuality:0];
    
	//self.cellImage.imageView.contentMode=UIViewContentModeScaleAspectFill;
	if(self.moment){
        
		self.moment.thumbnail =UIImageJPEGRepresentation(thumbnail, 0);
        
	}else{
        self.cellImage.imageView.image=thumbnail;
	}
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

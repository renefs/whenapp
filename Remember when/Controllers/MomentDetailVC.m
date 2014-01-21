//
//  EventDetailVC.m
//  Remember when
//
//  Created by René Fernández on 24/04/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import "MomentDetailVC.h"
#import <QuartzCore/QuartzCore.h>
#import "DateHelper.h"
#import "FullImageVC.h"
#import <Social/Social.h>


@interface MomentDetailVC ()

@end

@implementation MomentDetailVC

@synthesize labelTime,viewImage,moment,map,titleLabel,isFullScreen,originalImageViewSize,eventUpdated,legalView, point,posicion;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	//[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg-orange-pattern.png"] forBarMetrics:UIBarMetricsDefault];
	//[self.navigationItem.backBarButtonItem setBackgroundImage:[UIImage imageNamed:@"bg-strange-pattern.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	
	//self.title=@"Your moment";
	
	NSMutableArray* leftButtons = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"09-arrow-west.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(popNavigationController:)];
	
	[leftButtons addObject:backButton];
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"158-wrench-2.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(editAction:)];
	[leftButtons addObject:editButton];
	
	self.navigationItem.leftBarButtonItems=leftButtons;
	
	// create an array for the buttons
	NSMutableArray* buttons = [[NSMutableArray alloc] init];

	
	UIBarButtonItem *facebookButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"facebook.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(shareOnFacebook:)];
	//facebookButton.style = UIBarButtonItemStyleBordered;
	[buttons addObject:facebookButton];
	
	// create a standard save button
	UIBarButtonItem *twitterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"twitter.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(shareOnTwitter:)];

	[buttons addObject:twitterButton];
	
	
	self.navigationItem.rightBarButtonItems=buttons;
	
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-gray-pattern.png"]];
	
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
	
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return img;
}

-(IBAction)shareOnTwitter:(id)sender{
	
	if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
		SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
		
		UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-90, self.view.bounds.size.height-30, 90, 30)];
		[appName setBackgroundColor:[UIColor clearColor]];
		[appName setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0]];
		[appName setTextColor:[UIColor colorWithRed:76.0/255.0 green:66.0/255.0 blue:61.0/255.0 alpha:1.0]];
		appName.shadowColor = [UIColor whiteColor];
		appName.shadowOffset = CGSizeMake(0.0, 1);
		[appName setText:@"Whenapp"];
		
		[self.view addSubview:appName];
		[self.legalView removeFromSuperview];
		UIImage *imageToShare = [self imageWithView:self.view];
		[self.view addSubview:legalView];
		[appName removeFromSuperview];
		DateHelper *help = [[DateHelper alloc] init];
		NSString *time = [help fullDateFromDictionary:self.moment.date];
		
        [controller setInitialText:[[NSString alloc] initWithFormat:@"%@ - %@",self.moment.title,time]];
		[controller addImage:imageToShare];
        [self presentViewController:controller animated:YES completion:Nil];
    }else{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You have to set-up a Twitter Account first. Do it on System Preferences and then go back here." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
		[alert show];
	}
}

-(IBAction)shareOnFacebook:(id)sender{
	
	if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
		SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
		
		UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-90, self.view.bounds.size.height-30, 90, 30)];
		[appName setBackgroundColor:[UIColor clearColor]];
		[appName setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0]];
		[appName setTextColor:[UIColor colorWithRed:76.0/255.0 green:66.0/255.0 blue:61.0/255.0 alpha:1.0]];
		appName.shadowColor = [UIColor whiteColor];
		appName.shadowOffset = CGSizeMake(0.0, 1);
		[appName setText:@"Whenapp"];
		
		[self.view addSubview:appName];
		[self.legalView removeFromSuperview];
		UIImage *imageToShare = [self imageWithView:self.view];
		[self.view addSubview:legalView];
		[appName removeFromSuperview];
		DateHelper *help = [[DateHelper alloc] init];
		NSString *time = [help fullDateFromDictionary:self.moment.date];
		
        [controller setInitialText:[[NSString alloc] initWithFormat:@"%@ - %@",self.moment.title,time]];
		[controller addImage:imageToShare];
        [self presentViewController:controller animated:YES completion:Nil];
    }else{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You have to set-up a Facebook Account first. Do it on System Preferences and then go back here." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
		[alert show];
	}
}

-(IBAction)popNavigationController:(id)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	
	[[UIApplication sharedApplication]
	 setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
	
	//self.navigationController.navigationBar.translucent = NO;
	//[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
	//[[UIApplication sharedApplication] setStatusBarHidden:NO];
	//self.wantsFullScreenLayout = NO;
	//[self.view setNeedsDisplay];
	
    [super viewWillAppear:YES];
	// Do any additional setup after loading the view.
	
	NSLog(@"ViewWillAppear...%@",self.moment);
	
	if(self.eventUpdated){
		
		self.eventUpdated=NO;
		
		[self.viewImage removeFromSuperview];
		self.viewImage=nil;
		[self.titleLabel removeFromSuperview];
		self.titleLabel=nil;
		[self.labelTime removeFromSuperview];
		self.labelTime=nil;
		[self.map removeFromSuperview];
		self.map=nil;
		
	}
	
	if(!self.viewImage){
		float titleLabelOrigin=0;
		
		if(self.moment.fullImage!=nil && ![moment.fullImage isEqualToString:@""]){
			[self addImageView];
			titleLabelOrigin=150;
		}
		
		[self addTitleLabelOnY:titleLabelOrigin];
		
		[self addDateLabelOnY:titleLabelOrigin];
		
		map = [[MKMapView alloc] initWithFrame:CGRectMake(0, titleLabelOrigin+self.titleLabel.bounds.size.height+self.labelTime.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.viewImage.bounds.size.height-self.titleLabel.bounds.size.height-self.labelTime.bounds.size.height)];
		
		map.zoomEnabled=YES;
		map.userInteractionEnabled=YES;
		map.delegate=self;
		map.scrollEnabled=NO;
		
		CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.moment.latitude floatValue] longitude:[self.moment.longitude floatValue]];
		
		self.point = [[MapAnnotation alloc] initWithCoordinate:location.coordinate];
		
		self.posicion = [[MKPinAnnotationView alloc] initWithAnnotation: self.point reuseIdentifier: @"myPin"];
		self.posicion.draggable=YES;
		self.posicion.selected=YES;
		
		[map addAnnotation:self.point];
		
		//self.point = [[MapAnnotation alloc] initWithCoordinate:location.coordinate];
		MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.point.coordinate, 2000, 2000);
		
		[map setRegion:region animated:YES];
		
		//self.point = [[MapAnnotation alloc] initWithCoordinate:location.coordinate]; // Or whatever coordinates...
		
		//self.posicion = [[MKPinAnnotationView alloc] initWithAnnotation: self.point reuseIdentifier: @"myPin"];
		
		[self.view insertSubview:map belowSubview:self.titleLabel];
		
		
		
		//[self centerOnUserLocation];
		legalView = nil;
		for (UIView *subview in map.subviews) {
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
	
}

- (void) viewImageFullScreen:(UIGestureRecognizer *)sender{
	NSLog(@"Image tapped");
	
	FullImageVC *fullImgVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"FullImageView"];
	
	fullImgVC.imageName=self.moment.fullImage;
	fullImgVC.eventName=self.moment.title;
	
	//self.topBarHeight=self.navigationController.navigationBar.bounds.size.height;
	
	//[self.navigationController setNavigationBarHidden:YES];
	
	[self.navigationController pushViewController:fullImgVC animated:YES];
	
}

- (void) addImageView{
	
	//[self.view setNeedsLayout];
	
	NSData *jpgData = [NSData dataWithContentsOfFile:self.moment.fullImage];
	UIImage *img = [UIImage imageWithData:jpgData];
	
	
	self.originalImageViewSize=CGRectMake(0, 0.0, self.view.bounds.size.width, 150.0f);
	
	self.viewImage = [[UIImageView alloc] initWithFrame:self.originalImageViewSize];
	//NSLog(@"frame = %@\n", NSStringFromCGRect(self.viewImage.bounds));
	
	self.viewImage.image= img;
	//self.viewImage.layer.cornerRadius=10.0;
	[self.viewImage setContentMode:UIViewContentModeScaleAspectFill];
	self.viewImage.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
	[self.viewImage setClipsToBounds:YES];
	
	viewImage.userInteractionEnabled=YES;
	
	//¿Puede funcionar con perform(selector)?
	UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewImageFullScreen:)];
	tapImage.numberOfTapsRequired = 1;
	[self.viewImage addGestureRecognizer:tapImage];
	
	[self.view addSubview:self.viewImage];
	
}

- (void) addTitleLabelOnY:(float) originalPosition{
	
	CGSize maximumSize = CGSizeMake(300, 9999);
	
	UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0];
	
	CGSize dateStringSize = [self.moment.title sizeWithFont:titleFont
										constrainedToSize:maximumSize
											lineBreakMode:NSLineBreakByWordWrapping];
	
	
	CGRect titleFrame = CGRectMake(0, originalPosition, self.view.bounds.size.width, dateStringSize.height);
	
	self.titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
	self.titleLabel.numberOfLines=0;
	self.titleLabel.font=titleFont;
	self.titleLabel.textColor=[UIColor whiteColor];
	self.titleLabel.shadowColor = [UIColor blackColor];
	self.titleLabel.shadowOffset = CGSizeMake(0.0, 1);
	self.titleLabel.text= self.moment.title;
	self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.titleLabel.textAlignment=NSTextAlignmentCenter;
	self.titleLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-orange-pattern.png"]];
	
	if(self.viewImage){
		[self.view insertSubview:self.titleLabel belowSubview:self.viewImage];
	}else{
		[self.view addSubview:self.titleLabel];
	}
}

- (void) addDateLabelOnY:(float) originalPosition{
	
	DateHelper *help = [[DateHelper alloc] init];
	NSString *time = [help fullDateFromDictionary:self.moment.date];
	
	CGSize maximumSize = CGSizeMake(300, 9999);
	
	UIFont *dateFont = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
	
	CGSize dateStringSize = [time sizeWithFont:dateFont
							 constrainedToSize:maximumSize
								 lineBreakMode:NSLineBreakByWordWrapping];
	
	CGRect dateFrame = CGRectMake(0, originalPosition+self.titleLabel.bounds.size.height, self.view.bounds.size.width, dateStringSize.height);
	
	self.labelTime = [[UILabel alloc] initWithFrame:dateFrame];
	self.labelTime.numberOfLines=0;
	self.labelTime.font = dateFont;
	self.labelTime.text= time;
	self.labelTime.textColor = [UIColor grayColor];
	self.labelTime.lineBreakMode = NSLineBreakByWordWrapping;
	self.labelTime.textAlignment=NSTextAlignmentCenter;
	
	if (self.viewImage) {
		[self.view insertSubview:self.labelTime belowSubview:self.viewImage];
	}else{
		[self.view addSubview:self.labelTime];
	}
}

-(IBAction)editAction:(id)sender{
	//[self performSegueWithIdentifier:@"editEvent" sender:self];
	NSLog(@"%@",@"editEvent segue");
	//UINavigationController *nav = [[self.storyboard instantiateViewControllerWithIdentifier:@"AddMoment"] navigationController];
	
	UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"AddMomentNav"];
	
	AddNewTVC *vc = (AddNewTVC*)[[nav viewControllers] objectAtIndex:0];
	
	vc.moment = self.moment;
	vc.delegate=self;
	vc.title=@"Edit moment";
	
	vc.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
	
	[self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	
	NSLog(@"%@",@"Prepareforsegue");
    if ([[segue identifier] isEqualToString:@"editEvent"])
    {
		NSLog(@"%@",@"editEvent segue");
		UINavigationController *nav = [segue destinationViewController];
		
        AddNewTVC *vc = (AddNewTVC*)[[nav viewControllers] objectAtIndex:0];
        vc.moment = self.moment;
		vc.delegate=self;
		vc.title=@"Edit moment";
    }
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addItemViewController:(AddNewTVC *)controller didFinishUpdatingExistingMoment:(Moment*) e{
	self.moment=e;
	self.eventUpdated=YES;
	NSLog(@"didFinishUpdatingExistingEvent...");
	//[self.tableView reloadData];
	//[self.tableView setNeedsLayout];
}

@end

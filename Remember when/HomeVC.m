//
//  HomeVC.m
//  Remember when
//
//  Created by René Fernández on 06/05/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import "HomeVC.h"

#import "CoreDataManager.h"
#import "Moment.h"
#import "AppDelegate.h"
#import "MomentDetailVC.h"
#import "DateHelper.h"

#import <QuartzCore/QuartzCore.h>

@interface HomeVC ()

@end

@implementation HomeVC

@synthesize lastMoment,firstMoment;
@synthesize scrollView, noMomentsLabel;

/**
 Cuando se carga vista se configura el scrollview y el fondo de la vista
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
	[self setNeedsStatusBarAppearanceUpdate];
	
	
	
	//Scrollview
	self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	self.scrollView.delegate =self;
	[self.scrollView setScrollEnabled:YES];
	[self.scrollView setBounces:YES];
	scrollView.clipsToBounds = YES;
	self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg.png"]];
	
	//Vista
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg.png"]];
	
}

/**
 Se configura los momentos
 */
-(void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	
	/*[[UIApplication sharedApplication]
	 setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];*/
	
	if(self.lastMoment || self.firstMoment){
		for (UIView *view in self.scrollView.subviews) {
			[view removeFromSuperview];
		}
		[self.scrollView removeFromSuperview];
	}
	
	CoreDataManager* sharedManager = [CoreDataManager sharedInstance];

	self.firstMoment = [sharedManager getFirstMoment];
	self.lastMoment= [sharedManager getLastMoment];
	
	NSInteger tag= 1;
	float previousHeight=0.0;
	if(self.lastMoment){
		NSLog(@"%@",self.lastMoment.title);
		NSLog(@"previousHeight: %f",previousHeight);
		previousHeight = [self addMomentBlockWithMargin:10 headerFontSize:22 dateFontSize:16 previousHeight:previousHeight forMoment:self.lastMoment andTitle:@"Your last moment" momentViewTag:&tag];
		tag++;
	}
	if(self.firstMoment && ![self.firstMoment isEqual:self.lastMoment]){
		NSLog(@"previousHeight: %f",previousHeight);
		previousHeight = [self addMomentBlockWithMargin:10 headerFontSize:22 dateFontSize:16 previousHeight:previousHeight forMoment:self.firstMoment andTitle:@"Your first moment" momentViewTag:&tag];
		NSLog(@"previousHeight: %f",previousHeight);

	}
	
    //Mostrar un texto indicando que todavía no hay momentos añadidos.
	if(!self.firstMoment && !self.lastMoment){
		NSLog(@"No ments found: Displaying no moments label...");
		[self displayNoMomentsLabel];
	}else{
        //Si hay momentos, se quita la etiqueta.
		[self.noMomentsLabel removeFromSuperview];
	}
	
	CGSize scrollViewContentSize = CGSizeMake(self.view.bounds.size.width, previousHeight+self.tabBarController.tabBar.bounds.size.height+self.navigationController.navigationBar.bounds.size.height+10);
		
	[self.scrollView setContentSize:scrollViewContentSize];
	
	[self.view addSubview:self.scrollView];
		
}

-(void) pushToEventDetailedView:(UIGestureRecognizer *)sender{
	
	NSLog(@"Event tapped");
	
	MomentDetailVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MomentDetailVC"];
	Moment *m;
	switch (sender.view.tag) {
		case 1:
			
			m = self.lastMoment;
			break;
		case 2:
			
			m = self.firstMoment;
			break;
			
		default:
			return;
	}
	
	controller.moment= m;
	
	controller.hidesBottomBarWhenPushed = YES;
	
	[self.navigationController pushViewController:controller animated:YES];
	
}

- (void) displayNoMomentsLabel{
	
	//Moment title
	//float maximumWidth = self.scrollView.bounds.size.width-40;
	//CGSize maximumSize = CGSizeMake(maximumWidth, 9999);
	
	NSString *labelText = @"You have no moments yet, why don't you add your first one?";
	
	UIFont *titleFont = [UIFont fontWithName:@"Noteworthy-Light" size:31.0];
	/*CGSize labelStringSize = [labelText sizeWithFont:titleFont
									constrainedToSize:maximumSize
										lineBreakMode:NSLineBreakByWordWrapping];*/
	
	CGRect titleFrame = CGRectMake(20,
								   0,
								   self.scrollView.bounds.size.width-40,
								   self.scrollView.bounds.size.height-self.tabBarController.tabBar.bounds.size.height-self.navigationController.navigationBar.bounds.size.height);
	
	self.noMomentsLabel = [[UILabel alloc] initWithFrame:titleFrame];
	self.noMomentsLabel.numberOfLines=0;
	self.noMomentsLabel.textColor=[UIColor grayColor];
	self.noMomentsLabel.font=titleFont;
	self.noMomentsLabel.text= labelText;
	self.noMomentsLabel.shadowColor = [UIColor blackColor];
	self.noMomentsLabel.shadowOffset = CGSizeMake(0.0, 1);
	self.noMomentsLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.noMomentsLabel.textAlignment=NSTextAlignmentCenter;
	self.noMomentsLabel.backgroundColor = [UIColor clearColor];
	//End title
	
	[self.scrollView addSubview:self.noMomentsLabel];
	
}




- (float) addMomentBlockWithMargin:(float) margin headerFontSize:(float) headerFontSize dateFontSize:(float) dateFontSize previousHeight:(float) previousHeight forMoment:(Moment*) moment andTitle:(NSString*) title momentViewTag:(NSInteger*) viewTag{
	
	//Setting up header...
	UILabel *eventHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
																		  0,
																		  self.scrollView.bounds.size.width - 2*margin,
																		  headerFontSize)];
	//[eventHeaderLabel setTextColor:[UIColor whiteColor]];
	[eventHeaderLabel setBackgroundColor:[UIColor clearColor]];
	[eventHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:headerFontSize]];
	[eventHeaderLabel setTextColor:[UIColor colorWithRed:76.0/255.0 green:66.0/255.0 blue:61.0/255.0 alpha:1.0]];
	eventHeaderLabel.shadowColor = [UIColor whiteColor];
	eventHeaderLabel.shadowOffset = CGSizeMake(0.0, 1);
	
	[eventHeaderLabel setText:title];
	//Header end
	NSLog(@"Imagen FullSC: %@",moment.fullImage);
	float imageWidth;
	if(moment.fullImage != nil && ![moment.fullImage isEqualToString:@""]){
		NSLog(@"imageWidth=100");
		 imageWidth=100;
	}else{
		imageWidth=0;
	}
	
	
	//Moment title
	float maximumWidth = self.scrollView.bounds.size.width-imageWidth-2*margin;
	UILabel *titleLabel;
	CGSize maximumSize = CGSizeMake(maximumWidth, 9999);
	UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0];
	CGSize dateStringSize = [moment.title sizeWithFont:titleFont
								   constrainedToSize:maximumSize
									   lineBreakMode:NSLineBreakByWordWrapping];
	
	CGRect titleFrame = CGRectMake(imageWidth,
								   0,
								   self.scrollView.bounds.size.width-imageWidth-2*margin,
								   dateStringSize.height);
	
	titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
	titleLabel.numberOfLines=0;
	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.font=titleFont;
	titleLabel.text= moment.title;
	titleLabel.shadowColor = [UIColor blackColor];
	titleLabel.shadowOffset = CGSizeMake(0.0, 1);
	titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
	titleLabel.textAlignment=NSTextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-orange-pattern.png"]];
	//End title
	
	//Setting up date
	UILabel *timeLabel;
	DateHelper *help = [[DateHelper alloc] init];
	NSString *time = [help fullDateFromDictionary:moment.date];
	
	//CGSize maximumSize = CGSizeMake(300, 9999);
	
	UIFont *dateFont = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
	
	dateStringSize = [time sizeWithFont:dateFont
							 constrainedToSize:maximumSize
								 lineBreakMode:NSLineBreakByWordWrapping];
	
	CGRect dateFrame = CGRectMake(imageWidth,
								  titleLabel.bounds.size.height+titleLabel.bounds.origin.y,
								  self.scrollView.bounds.size.width-imageWidth-2*margin,
								  dateStringSize.height);
	
	timeLabel = [[UILabel alloc] initWithFrame:dateFrame];
	timeLabel.numberOfLines=0;
	timeLabel.font = dateFont;
	timeLabel.text= time;
	timeLabel.textColor = [UIColor grayColor];
	timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
	timeLabel.textAlignment=NSTextAlignmentCenter;
	//End date
	
	//Setting up image view
	float imageHeight=titleLabel.bounds.size.height+timeLabel.bounds.size.height;
	//if(imageHeight<50){
		imageHeight=100;
	//}
	
	
	UIImageView *eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
	NSData *jpgData = [NSData dataWithContentsOfFile:moment.fullImage];
	UIImage *img = [UIImage imageWithData:jpgData];
	eventImageView.image = img;

	float eventViewHeight=0;
	
	float titleAndLabelHeight = titleLabel.bounds.size.height+timeLabel.bounds.size.height;
	
	if(imageHeight>titleAndLabelHeight){
		eventViewHeight=imageHeight;
	}else{
		eventViewHeight=titleAndLabelHeight;
	}
	
	//eventViewHeight=titleLabel.bounds.size.height+timeLabel.bounds.size.height;
	NSLog(@"title+label: %f",eventViewHeight);
	
	UIView *eventView;
	eventView = [[UIView alloc] initWithFrame:CGRectMake(0,
														 eventHeaderLabel.bounds.size.height+margin,
														 self.scrollView.bounds.size.width - 2*margin,
														 eventViewHeight)];
	[eventView setBackgroundColor:[UIColor whiteColor]];
	//End white container
	
	[eventView addSubview:eventImageView];
	[eventView addSubview:titleLabel];
	[eventView addSubview:timeLabel];
	
	eventView.layer.cornerRadius = 5.0;
	eventView.layer.borderColor = [[UIColor colorWithRed:0.831 green:0.831 blue:0.831 alpha:1] CGColor];
	eventView.layer.borderWidth = 1.0;
	eventView.layer.masksToBounds = YES;
	
	//Event main section
	UIView *eventSection;
	eventSection = [[UIView alloc] initWithFrame:CGRectMake(margin,
														 previousHeight+margin,
														 self.scrollView.bounds.size.width-2*margin,
														 eventHeaderLabel.bounds.size.height+eventView.bounds.size.height)];
	
	
	[eventSection addSubview:eventHeaderLabel];
	[eventSection addSubview:eventView];
	[eventSection setBackgroundColor:[UIColor clearColor]];
	[eventSection setTag:*viewTag];
	
	[self.scrollView addSubview:eventSection];
	//End main section
	UITapGestureRecognizer *tapImage;
	tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToEventDetailedView:)];

	tapImage.numberOfTapsRequired = 1;
	[eventSection addGestureRecognizer:tapImage];

	return  eventSection.bounds.size.height + eventSection.bounds.origin.y+previousHeight+2*margin;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end

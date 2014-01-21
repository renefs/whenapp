//
//  MomentTableVC.m
//  Remember when
//
//  Created by René Fernández on 11/02/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import "MomentTableVC.h"
#import "CoreDataManager.h"
#import "Moment.h"

#import "DateHelper.h"
#import "MomentDetailVC.h"

#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"

@interface MomentTableVC ()

@end

@implementation MomentTableVC

@synthesize moments,timerIsStopped,momentsImages;

@synthesize tableView,originalTableHeight,originalTableWidth,originalBounds;

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext;


- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Moment" inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    managedObjectContext=app.managedObjectContext;
	
	/*self.originalTableWidth=self.tableView.frame.size.width;
	 self.originalTableHeight=self.tableView.frame.size.height-self.tabBarController.tabBar.frame.size.height;
	 self.originalBounds=self.tableView.frame;
	 */
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-self.navigationController.navigationBar.frame.size.height) style:UITableViewStylePlain];
	
	//self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	self.tableView.delegate=self;
	self.tableView.dataSource=self;
	
	self.originalBounds=self.tableView.frame;
	self.tableView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.tableView];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg.png"]];
	
	//NSLog(@"Original de la view: alto:%f, ancho: %f",self.view.bounds.size.height,self.view.bounds.size.width);
	NSLog(@"Original de la tableView: alto:%f, ancho: %f",self.tableView.bounds.size.height,self.tableView.bounds.size.width);
	
	backButton = self.editButtonItem;
	//[backButton setImage:[UIImage imageNamed:@"158-wrench-2.png"]];
	//[backButton setImage:[UIImage imageNamed:@"09-arrow-west.png"] forState:UIControlStateNormal];
	//[backButton addTarget:self action:@selector(popNavigationController:) forControlMoments:UIControlMomentTouchUpInside];
	
	
	
	//self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	
	self.timerIsStopped=NO;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}

	self.title=@"Your moments";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.fetchedResultsController = nil;
}

/*- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:kLARSAdObserverKeyPathIsAdVisible]) {
        NSLog(@"Observing keypath \"%@\"", keyPath);
        
        BOOL anyAdsVisible = [change[NSKeyValueChangeNewKey] boolValue];
        if (anyAdsVisible) {
            NSLog(@"Ad is visible");
			
			self.tableView.frame=CGRectMake(0,
											//[LARSAdController sharedManager].containerView.frame.size.height
											0,
											self.originalBounds.size.width,
											self.originalBounds.size.height-[LARSAdController sharedManager].containerView.frame.size.height);
        }
        else{
            NSLog(@"Ad not visible");
			self.tableView.frame=self.originalBounds;
		}
		
		[self.view.superview setNeedsLayout];
		
	}
}*/

-(void) viewDidAppear:(BOOL)animated{
	
	[super viewDidAppear:animated];
	
	NSLog(@"viewWDIDAppear: Home");
	
	//[[LARSAdController sharedManager] addAdContainerToViewInViewController:self.navigationController];
	
	/*[[LARSAdController sharedManager] addObserver:self
                                       forKeyPath:kLARSAdObserverKeyPathIsAdVisible
                                          options:NSKeyValueObservingOptionNew
                                          context:nil];*/
	
	/*if([LARSAdController sharedManager].isAdVisible){
		
		NSLog(@"Ad IS visible");
		NSLog(@"Original: alto:%f, ancho: %f",self.tableView.bounds.size.height,self.tableView.bounds.size.width);
		NSLog(@"Bounds: alto:%f, ancho: %f",self.tableView.bounds.size.height,self.tableView.bounds.size.width);
		NSLog(@"Nuevo: alto:%f, ancho: %f",self.tableView.frame.size.height-[LARSAdController sharedManager].containerView.frame.size.height,self.tableView.frame.size.width);
		self.tableView.frame=CGRectMake(0,
										//[LARSAdController sharedManager].containerView.frame.size.height
										0,
										self.originalBounds.size.width,
										self.originalBounds.size.height-[LARSAdController sharedManager].containerView.frame.size.height);
	}else{*/
		NSLog(@"Ad is NOT visible");
		self.tableView.frame=self.originalBounds;
	//}
	
	//[self.tableView reloadData];
	[self.view.superview setNeedsLayout];
	
}

- (void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	
	//[[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
	NSLog(@"viewWillAppear: Home");
	
	if([[[self fetchedResultsController] fetchedObjects]count]>0 ){
		self.navigationItem.leftBarButtonItem = backButton;
	}
	
	self.timerIsStopped=NO;
	//[self.tableView reloadData];
	[self updateTime];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Moment *Moment = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = Moment.title;
    
	DateHelper *dateHelper = [[DateHelper alloc] init];
	
	NSString* dateLeft = [dateHelper fullDateFromDictionary:Moment.date];
	
	cell.detailTextLabel.text = dateLeft;
    
    cell.imageView.image = [UIImage imageWithData:Moment.thumbnail];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *table = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [table insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			
			if([[[self fetchedResultsController] fetchedObjects]count]<=0 ){
				self.navigationItem.leftBarButtonItem = nil;
			}
			
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[table cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [table deleteRowsAtIndexPaths:[NSArray
										   arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [table insertRowsAtIndexPaths:[NSArray
										   arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}


-(void)updateTime{
	
	if(!self.timerIsStopped){
		NSLog(@".");
		[self.tableView reloadData];
		[self performSelector:@selector(updateTime) withObject:self afterDelay:60.0];
	}
	
	
}

-(void) viewWillDisappear:(BOOL)animated{
	
	[super viewWillDisappear:animated];
	NSLog(@"viewWillDissapear");
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateTime) object:nil];
	self.timerIsStopped= YES;
	//self.title = @" ";
	
	//[[LARSAdController sharedManager] removeObserver:self forKeyPath:kLARSAdObserverKeyPathIsAdVisible];
	//[[AdsManager sharedInstance] removeBanner];
	
}

/*
 Disabling editing on slide.
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.editing;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //SimpleEditableListAppDelegate *controller = (SimpleEditableListAppDelegate *)[[UIApplication sharedApplication] delegate];
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    
    [self.tableView beginUpdates];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		Moment *Moment = [self.fetchedResultsController objectAtIndexPath:indexPath];
		CoreDataManager *manager = [CoreDataManager sharedInstance];
		
		[manager removeMoment:Moment];
		
    }
    [self.tableView endUpdates];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
	
    if (editing) {
        //addButton.enabled = NO;
		NSLog(@"Editing");
		self.timerIsStopped= YES;
		[self.editButtonItem setImage:[UIImage imageNamed:@"09-arrow-west.png"]];
		[self.editButtonItem setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:236.0/255.0 green:99.0/255.0 blue:31.0/255.0 alpha:1.0]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
		//[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateTime) object:nil];
    } else {
        //addButton.enabled = YES;
		NSLog(@"End Editing");
		self.timerIsStopped = NO;
		[self updateTime];
		[self.editButtonItem setImage:[UIImage imageNamed:@"158-wrench-2.png"]];
		//[self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
    }
}


- (UIImage *)imageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"ROW SELECTED");
	
	MomentDetailVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MomentDetailVC"];
	
	Moment *e = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	controller.Moment= e;
	
	controller.hidesBottomBarWhenPushed = YES;
	
	[self.navigationItem.backBarButtonItem setBackgroundImage:[UIImage imageNamed:@"bg-strange-pattern.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	
	[self.navigationController pushViewController:controller animated:YES];
}

@end

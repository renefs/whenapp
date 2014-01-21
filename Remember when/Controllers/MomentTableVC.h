//
//  EventTableVC.h
//  Remember when
//
//  Created by René Fernández on 11/02/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
//#import "AdsManager.h"



@class CoreDataManager,AppDelegate;

@interface MomentTableVC : UIViewController<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>{
	
	UIBarButtonItem *backButton;
}

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

// Reference to the original UITableView.
@property (nonatomic, retain) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *moments;
@property (strong,nonatomic) NSMutableArray *momentsImages;

@property (nonatomic) BOOL timerIsStopped;

@property (nonatomic) float originalTableHeight;
@property (nonatomic) float originalTableWidth;

@property (nonatomic) CGRect originalBounds;

-(void)updateTime;

@end

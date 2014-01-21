//
//  AddNewTVC.h
//  Remember when
//
//  Created by René Fernández on 12/02/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetAlarmTVC.h"
#import "MapAnnotation.h"
#import "Moment.h"

#import <MapKit/MapKit.h>

@class AbstractActionSheetPicker;
@class CoreDataManager,AppDelegate;

@class AddNewTVC;

@protocol AddNewTVCDelegate <NSObject>
- (void)addItemViewController:(AddNewTVC *)controller didFinishUpdatingExistingMoment:(Moment*) m;
@end

@interface AddNewTVC : UITableViewController <UINavigationControllerDelegate,UITextFieldDelegate,MKMapViewDelegate,CLLocationManagerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate>{
	CLLocationManager *locationManager;
	CLLocation *location;
}

@property (nonatomic, weak) id <AddNewTVCDelegate> delegate;

@property (nonatomic,strong) MKPinAnnotationView *posicion;
@property (nonatomic,strong) MapAnnotation *point;

@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSDate *selectedTime;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) IBOutlet UIView *daContainer;

//@property (strong, nonatomic) IBOutlet UITableViewCell *cellReminder;

@property (nonatomic,strong) Moment *moment;
@property (nonatomic,strong) UIImage *fullImage;
@property (nonatomic,strong) UIImage *thumbnail;

//@property (nonatomic, retain) NSDate *selectedDateAlarm;
//@property (nonatomic, retain) NSDate *selectedTimeAlarm;
//@property (nonatomic) BOOL alarmOn;

@property (nonatomic, retain) AbstractActionSheetPicker *actionSheetPicker;


@property (strong, nonatomic) IBOutlet UITableViewCell *cellMomentTitle;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellImage;

//@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellDate;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTime;

@property (strong, nonatomic) IBOutlet UITextField *textMoment;

@property (nonatomic,strong) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellMap;

/**
 A la hora de editar un Momento se pone a verdadero
 */
@property (nonatomic) BOOL editingExistingMoment;

/**
 Muestra el Action Sheet de selección de imágenes
 */
- (void)showImagesActionSheet;


/**
 Se ejecuta por medio del delegado cuando se ha seleccionado una fecha.
 @param selectedDate date
 */
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element;
-(void)createGestureRecognizers;
- (void)handleCellDateTap:(UIGestureRecognizer *)sender;


@end

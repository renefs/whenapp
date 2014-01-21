//
//  EventDetailVC.h
//  Remember when
//
//  Created by René Fernández on 24/04/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"
#import "AddNewTVC.h"
#import "MapAnnotation.h"

@interface MomentDetailVC : UIViewController<AddNewTVCDelegate,MKMapViewDelegate>

@property (strong,nonatomic) Moment *moment;

@property (nonatomic) CGRect originalImageViewSize;
@property (nonatomic) BOOL isFullScreen;
@property (nonatomic) BOOL eventUpdated;

@property (strong,nonatomic) IBOutlet UILabel *titleLabel;
@property (strong,nonatomic) IBOutlet UILabel *labelTime;
@property (strong,nonatomic) IBOutlet UIImageView *viewImage;


@property (nonatomic,strong) MKPinAnnotationView *posicion;
@property (nonatomic,strong) MapAnnotation *point;
@property (nonatomic,strong) MKMapView *map;
@property (nonatomic,strong) UIView *legalView;

/**
 Al estar personalizado el botón back, debe añadírsele un selector para hacer pop a la vista actual manualmente.
 */
-(IBAction)popNavigationController:(id)sender;

- (void) viewImageFullScreen:(UIGestureRecognizer *)sender;

/**
 Al cargar la vista de edición del Moment, se le asigna como delegada esta clase para que pueda recibir las actualizaciones en el caso de que se modifique y guarde el estado.
 @param controller Controlador de la pantalla de creación/edición de Moment que se instanciará.
 @param m Moment que se le pasará al controlador AddNewTVC para ser modificado.
 */
- (void)addItemViewController:(AddNewTVC *)controller didFinishUpdatingExistingMoment:(Moment*) e;

/**
 Genera una imagen a partir de la vista individual del Moment.
 @param view La vista que se convertirá en UIImage.
 */
- (UIImage *) imageWithView:(UIView *)view;

/**
 Comparte en Twitter El título del Moment, el tiempo y la imagen.
 */
-(IBAction)shareOnTwitter:(id)sender;
/**
 Comparte en Facebook El título del Moment e imprime la UIView como imagen.
 */
-(IBAction)shareOnFacebook:(id)sender;


/**
 Añade una UIImageView a la vista, en la que se muestra la imagen del Moment, pero no se muestra entera.
 Sobre esta ImageView se puede pulsar para ver la imagen en pantalla completa.
 */
- (void) addImageView;

/**
 Añade la label con el título a partir de una posición (y) determinada. La poisición varía en función del tamaño de la imagen.
 @param originalPosition Posición y origen
 */
- (void) addTitleLabelOnY:(float) originalPosition;

/**
 Añade la label con la fecha a partir de una posición (y) determinada. La posición varía en función del alto de la label de título.
 @param originalPosition Posición y origen
 */
- (void) addDateLabelOnY:(float) originalPosition;

/**
 Al pulsar en el botón de edición abre la vista de edición del Moment, pasándole sus datos.
 */
-(IBAction)editAction:(id)sender;

@end

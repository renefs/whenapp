//
//  HomeVC.h
//  Remember when
//
//  Created by René Fernández on 06/05/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Moment;
@class AppDelegate;

/**
 Controladora de la pantalla de inicio.
 */
@interface HomeVC : UIViewController <UIScrollViewDelegate>

/*
 Dependiendo de la altura de los Momentos (por ejemplo títulos, tiempo, etc) será necesario
 hacer scroll y el contenido saldrá de la pantalla.
 */
@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
/*
 Momento para la sección "Last moment".
 */
@property (strong,nonatomic) Moment *lastMoment;
/*
 Momento para la sección "First moment".
 */
@property (strong,nonatomic) Moment *firstMoment;

/*
 Etiqueta que se muestra cuando no hay ningún momento.
 */
@property (strong,nonatomic) UILabel *noMomentsLabel;

/**
 Añade un bloque con la información de un momento: imagen, título y tiempo que ha pasado desde el mismo.
 @param margin Márgenes que tendrá el bloque con respecto al borde de la pantalla.
 @param headerFontSize Tamaño de la fuente tel título del bloque (Your first moment).
 @param dateFontSize Tamaño de la fuente de la fecha.
 @param previousHeight Altura acumulada de los bloques anteriores (para establecer la posición de cada bloque). Se actualiza con el retorno del bloque anterior.
 @param moment Momento del que se mostrará la información.
 @param title Texto del título del bloque.
 @param viewTag Identificador del bloque para establecer un selector que responda al pulsar cada uno.
 
 @return Tamaño del bloque actual + posición inicial (y)
 */
- (float) addMomentBlockWithMargin:(float) margin
					headerFontSize:(float) headerFontSize
					  dateFontSize:(float) dateFontSize
					previousHeight:(float) previousHeight
						 forMoment:(Moment*) moment
						  andTitle:(NSString*) title
					 momentViewTag:(NSInteger*) viewTag;


/**
 Método que se establece como selector de cada bloque para que lleve a la vista detallada de cada momento.
 @param sender Dependiendo del bloque que se pulse, llevará a la vista detallada de un momento diferente. Qué momento es se sabe gracias al tag del sender del evento. (Se realiza un switch).
 */
-(void) pushToEventDetailedView:(UIGestureRecognizer *)sender;


@end

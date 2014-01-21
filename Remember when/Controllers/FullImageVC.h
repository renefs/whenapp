//
//  FullImageVC.h
//  Remember when
//
//  Created by René Fernández on 14/05/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Controla la vista de imagen a pantalla completa (cuando se pulsa una imagen en la vista de evento individual)
 */
@interface FullImageVC : UIViewController{
	
	/*
	 La imagen se mostrará dentro de esta vista de imagen
	*/
	UIImageView *imageView;
	
}
/*
 Se necesita al variar el estado de la barra de navegación mostrada/oculta
 */
@property (nonatomic) BOOL isNavigationHidden;
/*
 Usada para obtener del disco el archivo de la imagen.
 */
@property (strong,nonatomic) NSString *imageName;

/*
 Se mostrará en la barra de navegación.
 */
@property (strong,nonatomic) NSString *eventName;


/**
 Al tener un botón back personalizado, hay que implementar este botón para volver atrás en el sistema de vistas.
 */
-(IBAction)popNavigationController:(id)sender;

/**
 Cambia el estado de la barra de navegación entre visible y oculta.
 */
- (void) displayNavigationBar:(UIGestureRecognizer *)sender;

@end

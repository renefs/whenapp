//
//  FullImageVC.m
//  Remember when
//
//  Created by René Fernández on 14/05/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import "FullImageVC.h"

@interface FullImageVC ()

@end

@implementation FullImageVC

@synthesize imageName,isNavigationHidden,eventName;

/**
 Al desaparecer la vista, la barra de navegación deja de ser traslúcida.
 */
-(void)viewWillDisappear:(BOOL)animated{
	
	
	NSLog(@"viewDidDissappear...");
	
	self.navigationController.navigationBar.translucent = NO;
	
	[super viewWillDisappear:animated];
}


/**
 Personalización de la vista: color de fondo, botón back, título y se configura la imagen
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Color de fondo
	self.view.backgroundColor = [UIColor blackColor];
	
	//Botón back
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	[backButton setImage:[UIImage imageNamed:@"09-arrow-west.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(popNavigationController:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

	//Título en la barra de navegación
	self.title=self.eventName;
	
	//Imagen
	NSData *jpgData = [NSData dataWithContentsOfFile:self.imageName];
	UIImage *img = [UIImage imageWithData:jpgData];
	imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	imageView.image= img;
	
	//Líneas necesarias para que la imagen se ajuste al ancho, pero manteniendo proporciones
	[imageView setContentMode:UIViewContentModeScaleAspectFit];
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
	[imageView setClipsToBounds:YES];
	
	imageView.userInteractionEnabled=YES;
	
	//Se establece la acción al pulsar la imagen
	//¿Podría funcionar con perform(selector)?
	UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayNavigationBar:)];
	tapImage.numberOfTapsRequired = 1;
	[imageView addGestureRecognizer:tapImage];
	
	[self.view addSubview:imageView];
	
}

/**
 Configuración de la barra de navegación: se muestra por defecto, se pone traslúcida y se hace que la vista
 ocupe toda la pantalla.
 */
-(void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	
	NSLog(@"viewDidDissappear...");
	[self.navigationController setNavigationBarHidden:NO];
	//self.navigationController.navigationBar.translucent = YES;
	
	[[UIApplication sharedApplication]
	 setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
	
	//?
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	self.isNavigationHidden=NO;
	//self.wantsFullScreenLayout = YES;
}


- (void) displayNavigationBar:(UIGestureRecognizer *)sender{
	NSLog(@"Image tapped");
	
	[UIView animateWithDuration:0.3 animations:^{
		if(isNavigationHidden){
			//self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
			[[UIApplication sharedApplication] setStatusBarHidden:NO];
			[self.navigationController setNavigationBarHidden:NO];
		}else{
			[self.navigationController setNavigationBarHidden:YES];
			[[UIApplication sharedApplication] setStatusBarHidden:YES];
		}
		
	}];
	
	isNavigationHidden=!isNavigationHidden;
	
}


-(IBAction)popNavigationController:(id)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

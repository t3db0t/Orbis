//
//  OrbisAppDelegate.m
//  Orbis
//
//  Created by Ted Hayes on 3/3/10.
//  Copyright Limina.Studio 2010. All rights reserved.
//

#import "OrbisAppDelegate.h"
#import "OrbisViewController.h"

@implementation OrbisAppDelegate

@synthesize window;
//@synthesize viewController;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    //[window addSubview:viewController.view];
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[navigationController release];
    //[viewController release];
    [window release];
    [super dealloc];
}


@end

//
//  OrbisAppDelegate.h
//  Orbis
//
//  Created by Ted Hayes on 3/3/10.
//  Copyright Limina.Studio 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrbisViewController;

@interface OrbisAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    //OrbisViewController *viewController;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
//@property (nonatomic, retain) IBOutlet OrbisViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end


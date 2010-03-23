//
//  PlaylistViewController.h
//  Orbis
//
//  Created by Ted Hayes on 3/15/10.
//  Copyright 2010 Limina.Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlaylistViewController : UITableViewController <UITableViewDelegate> {
	NSMutableArray *playlist;
	//IBOutlet UIButton *editButton;
	IBOutlet UIViewController *mainViewController;
}

@end

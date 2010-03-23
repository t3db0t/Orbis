//
//  OrbisViewController.h
//  Orbis
//
//  Created by Ted Hayes on 3/3/10.
//  Copyright Limina.Studio 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"

@interface OrbisViewController : UIViewController {
	IBOutlet UIView *secondaryView;
	AsyncSocket *mySocket;
	IBOutlet UIButton *pauseButton;
	IBOutlet UIButton *playButton;
	IBOutlet UIView *buttonContainerView;
	IBOutlet UITableView *playlistTableView;
	
	IBOutlet UILabel *currentTrackLabel;
	IBOutlet UILabel *currentArtistLabel;
	
	UIBarButtonItem *playlistButton;
	UIBarButtonItem *circleButton;
	
	NSInteger volume;
	NSInteger playlistLength;
	NSInteger currentTime;
	NSInteger totalTime;
	
	NSString *currentArtist;
	NSString *currentTitle;
	NSString *currentFile;	// for use when no "artist" and "title" entries present
	NSString *fileString;
	
	NSInteger currentView;
	
	//NSMutableArray *playlistArray;
}

@property(retain, nonatomic) AsyncSocket *mySocket;

-(void)flipToPlaylist;
-(void)flipToControls;
-(IBAction)touchPauseButton:(id)sender;
-(void)parseStatusWithString:(NSString *)string;

@end


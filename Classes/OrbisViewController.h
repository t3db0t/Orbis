//
//  OrbisViewController.h
//  Orbis
//
//  Created by Ted Hayes on 3/3/10.
//  Copyright Limina.Studio 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"

typedef enum {
	PLAY,
	PAUSE
} playStateSetting;

typedef enum {
	CONTROLS,
	PLAYLIST
} currentViewSetting;

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
	//NSMutableString *currentFile;	// for use when no "artist" and "title" entries present
	
	NSInteger currentView;
	
	playStateSetting currentPauseButtonState;
	playStateSetting currentPlayState;
	playStateSetting lastPlayState;
}

//@property(retain, nonatomic) AsyncSocket *mySocket;

-(void)flipToPlaylist;
-(void)flipToControls;
-(IBAction)touchPauseButton:(id)sender;
-(void)parseStatusWithString:(NSString *)string;
-(void)togglePauseButton;
-(void)togglePauseButtonTo:(playStateSetting)state;

@end


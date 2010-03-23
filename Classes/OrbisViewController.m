//
//  OrbisViewController.m
//  Orbis
//
//  Created by Ted Hayes on 3/3/10.
//  Copyright Limina.Studio 2010. All rights reserved.
//

#import "OrbisViewController.h"
#import "OrbisView.h"

@implementation OrbisViewController

//@synthesize mySocket;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	currentView = 0;

	// nav controller stuff
	playlistButton = [[[UIBarButtonItem alloc]
					   initWithImage:[UIImage imageNamed:@"playlist_button.png"]
					   style:UIBarButtonItemStylePlain
					   target:self
					   action:@selector(switchView)]
					  retain];
	
	circleButton = [[[UIBarButtonItem alloc]
					 initWithImage:[UIImage imageNamed:@"circle_button.png"]
					 style:UIBarButtonItemStylePlain
					 target:self
					 action:@selector(switchView)]
					retain];
	
	//[[self navigationItem] setLeftBarButtonItem:self.editButtonItem animated:YES];
	
	[[self navigationItem] setRightBarButtonItem:playlistButton animated:YES];
	
	self.navigationItem.title = @"Orbis";
	
	///// Play/Pause Button /////
	// sets to pause first
	
	currentPauseButtonState = PAUSE;
	[playButton removeFromSuperview];
	NSLog(@"initializing cPBState to: %d", currentPauseButtonState);
	
	///// SOCKET /////
	
	mySocket = [[AsyncSocket alloc] initWithDelegate:self];
	[mySocket retain];
	
	NSError *err;
	[mySocket connectToHost:@"crowsnest" onPort:6600 error:&err];
}

-(void)switchView{
	
	//SLog(@"self.view kindOfClass: %@", [self.view isKindOfClass]);
	
	if (currentView == 0) {
		
		currentView = 1;
		
		[[self navigationItem] setLeftBarButtonItem:self.editButtonItem animated:YES];
		[[self navigationItem] setRightBarButtonItem:circleButton animated:YES];
		
		self.navigationItem.title = @"Playlist";
		
		[self flipToPlaylist];
	}
	
	else if (currentView == 1) {
		
		currentView = 0;
		
		[[self navigationItem] setLeftBarButtonItem:nil animated:YES];
		[[self navigationItem] setRightBarButtonItem:playlistButton animated:YES];
		
		self.navigationItem.title = @"Orbis";
		
		[self flipToControls];
	}
	
	
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	NSLog(@"OrbisViewController.setEditing");
	NSLog(@"should set editing mode to %@", editing?@"YES":@"NO");
	[super setEditing:editing animated:animated]; 
	[playlistTableView setEditing:editing animated:animated];
}

- (void)pollServer{
	NSData *writeData = [@"status\ncurrentsong\n" dataUsingEncoding:NSUTF8StringEncoding]; 
	[mySocket writeData:writeData withTimeout:-1 tag:0];
	[mySocket readDataWithTimeout:0.5 tag:0];
}

- (void)updateView {
	[[self view] setTimeCurrent:currentTime];
	[[self view] setTimeTotal:totalTime];
	
	[currentArtistLabel setText:currentArtist];
	[currentTrackLabel setText:currentTitle];
	
	[[self view] setNeedsDisplay];
}

- (void)flipToPlaylist{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:[self view]
							 cache:YES];
	[[self view] addSubview:secondaryView];
	[UIView commitAnimations];
}

- (void)flipToControls{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
						   forView:[self view]
							 cache:YES];
	[secondaryView removeFromSuperview];
	[UIView commitAnimations];
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
	NSLog(@"AsyncSocket didConnectToHost: %@ port: %d",host, port);
	//[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1.0 tag:0];
	[sock readDataWithTimeout:0.5 tag:0];
	
	// initialize playlist TableView
	
	//[self initTable];
	
	[self pollServer];
	
	// Start Polling timer
	
	[NSTimer scheduledTimerWithTimeInterval:0.5 
									 target:self 
								   selector:@selector(pollServer) 
								   userInfo:nil 
									repeats:YES];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData*)data withTag:(long)tag {
	NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	// Parse data
	[self parseStatusWithString:result];
	[result release];
}

-(void)parseStatusWithString:(NSString *)statusString {

	NSScanner *theScanner;
	
	theScanner = [NSScanner scannerWithString:statusString];
	
	if ([statusString rangeOfString:@"volume:"].location != NSNotFound) {
		NSString *stateString;
		
		[theScanner scanString:@"volume:" intoString:NULL];
		[theScanner scanInteger:&volume];
		
		[theScanner scanUpToString:@"playlistlength:" intoString:NULL];
		[theScanner scanString:@"playlistlength:" intoString:NULL];
		[theScanner scanInteger:&playlistLength];
		
		[theScanner scanUpToString:@"state:" intoString:NULL];
		[theScanner scanString:@"state:" intoString:NULL];
		[theScanner scanUpToString:@"\n" intoString:&stateString];
		
		if ([stateString isEqualToString:@"play"]) {
			currentPlayState = PLAY;
		} else if ([stateString isEqualToString:@"pause"]) {
			currentPlayState = PAUSE;
		}
		
		[theScanner scanUpToString:@"time:" intoString:NULL];
		[theScanner scanString:@"time:" intoString:NULL];
		[theScanner scanInteger:&currentTime];
		
		[theScanner scanString:@":" intoString:NULL];
		[theScanner scanInteger:&totalTime];
	}

	if ([statusString rangeOfString:@"file:"].location != NSNotFound) {
		NSString *fileString;
		NSString *tempTitle = @"";
		
		[theScanner scanUpToString:@"file:" intoString:NULL];
		[theScanner scanString:@"file:" intoString:NULL];
		[theScanner scanUpToString:@"\n" intoString:&fileString];
		
		[theScanner scanUpToString:@"Artist:" intoString:NULL];
		[theScanner scanString:@"Artist:" intoString:NULL];
		
		if(currentArtist != nil) [currentArtist release];
		[theScanner scanUpToString:@"\n" intoString:&currentArtist];
		[currentArtist retain];
		
		[theScanner scanUpToString:@"Title:" intoString:NULL];
		[theScanner scanString:@"Title:" intoString:NULL];
		
		[theScanner scanUpToString:@"\n" intoString:&tempTitle];
		if(currentTitle != nil) [currentTitle release];
		
		if ([tempTitle isEqualToString:@""]) {
			currentTitle = [fileString lastPathComponent];
		} else {
			currentTitle = tempTitle;
		}
		[currentTitle retain];
	}
	[self updateView];
	
	// update pause button state
	if (currentPlayState != lastPlayState) {
		if (currentPlayState == PLAY && currentPauseButtonState != PAUSE) {
			[self togglePauseButtonTo:PAUSE];
		}
		if (currentPlayState == PAUSE && currentPauseButtonState != PLAY) {
			[self togglePauseButtonTo:PLAY];
		}
	}
	lastPlayState = currentPlayState;
}

- (void)sendPause {
	NSData *writeData = [@"pause\r\n" dataUsingEncoding:NSUTF8StringEncoding]; 
	[mySocket writeData:writeData withTimeout:-1 tag:0];
	[mySocket readDataWithTimeout:0.5 tag:0];
}

- (IBAction)touchPauseButton:(id)sender {
	[self sendPause];
	[self togglePauseButton];
}

-(void)togglePauseButton {
	
	if(currentPauseButtonState == PAUSE)
	{
		[self togglePauseButtonTo:PLAY];
	}
	else
	{
		[self togglePauseButtonTo:PAUSE];
	}
}

-(void)togglePauseButtonTo:(playStateSetting)state {
	if (currentPauseButtonState == state) {
		return;
	}
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	if (state == PLAY) {
		// Show PLAY button
		currentPauseButtonState = PLAY;
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:buttonContainerView cache:YES]; 
		
		[buttonContainerView addSubview:playButton];
		[pauseButton removeFromSuperview];
	}
	else
	{
		// Show PAUSE button
		currentPauseButtonState = PAUSE;
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:buttonContainerView cache:YES]; 
		
		[buttonContainerView addSubview:pauseButton];
		[playButton removeFromSuperview];
	}
	[UIView commitAnimations];
	NSLog(@"set currentPauseButtonState to: %d", currentPauseButtonState);
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock {
	NSLog(@"onSocketDidDisconnect: sock: %@",sock);
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
	NSLog(@"onSocket:willDisconnectWithError: %@",err);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[mySocket release];
	[currentArtist release];
	[currentTitle release];
	
    [super dealloc];
}

@end

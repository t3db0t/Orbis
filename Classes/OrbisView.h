//
//  OrbisView.h
//  Orbis
//
//  Created by Ted Hayes on 3/3/10.
//  Copyright 2010 Limina.Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrbisView : UIView {
	CGColorSpaceRef rgb;
	CGGradientRef gradient;
	CGColorRef shadowColor;
	float timeCurrent;
	float timeTotal;
	//IBOutlet UILabel *currentTrackLabel;
	//IBOutlet UILabel *currentArtistLabel;
	//IBOutlet UIViewController *viewController;
}

@property (nonatomic) float timeCurrent;
@property (nonatomic) float timeTotal;
//@property (nonatomic, retain) IBOutlet UILabel *currentArtistLabel;
//@property (nonatomic, retain) IBOutlet UILabel *currentTrackLabel;

@end
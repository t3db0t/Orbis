//
//  OrbisView.m
//  Orbis
//
//  Created by Ted Hayes on 3/3/10.
//  Copyright 2010 Limina.Studio. All rights reserved.
//

#import "OrbisView.h"
//#import "OrbisViewController.h"

@implementation OrbisView

@synthesize timeCurrent;
@synthesize timeTotal;
//@synthesize currentArtistLabel;
//@synthesize currentTrackLabel;

- (void) awakeFromNib {
	NSLog(@"OrbisView::awakeFromNib");
	rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[] =
	{
		204.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00,
		29.0 / 255.0, 156.0 / 255.0, 215.0 / 255.0, 1.00,
		0.0 / 255.0,  50.0 / 255.0, 126.0 / 255.0, 1.00,
	};
	gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	float shadowColorValues[] = {0, 0, 0, 1};
	shadowColor = CGColorCreate (rgb, shadowColorValues);
	CGColorSpaceRelease(rgb);
}

- (void)drawRect:(CGRect)rect {
	int edgebuf = 40;
	int volbuf = 50;
	int cx = rect.size.width / 2;
	int cy = rect.size.height / 2;
	int radiusProgress = cx - edgebuf;
	int radiusVolume = radiusProgress - volbuf;
	
	CGContextRef ctxt = UIGraphicsGetCurrentContext();
	
	CGPoint start, end;
	start = CGPointMake(0.0, 0.0);
	end = CGPointMake(0.0, 480.0);
	CGContextDrawLinearGradient(ctxt, gradient, start, end, 0);
	
	CGContextSetRGBStrokeColor(ctxt, 0.3, 0.3, 0.3, 0.4);
	CGContextSetLineWidth(ctxt, 25.0);
	
	CGContextSaveGState(ctxt);
		//CGContextSetShadow(ctxt, CGSizeMake(0, 0), 15);
		CGContextSetShadowWithColor(ctxt, CGSizeMake(0, 0), 15, shadowColor);
		CGContextAddEllipseInRect(ctxt, CGRectMake(cx - radiusProgress, cy - radiusProgress, radiusProgress*2, radiusProgress*2));
		CGContextStrokePath(ctxt);
	CGContextRestoreGState(ctxt);
	
	CGContextSetRGBStrokeColor(ctxt, 0.0, 0.5, 0.9, 0.8);
	CGContextSetLineWidth(ctxt, 20.0);
	
	CGContextSaveGState(ctxt);
		float currentAngle = ((self.timeCurrent / self.timeTotal) * 2 * M_PI) + (-M_PI/2);
		CGContextAddArc(ctxt, cx, cy, radiusProgress, -M_PI/2, currentAngle, 0);
		CGContextStrokePath(ctxt);
	CGContextRestoreGState(ctxt);
	
	CGContextSetRGBStrokeColor(ctxt, 0.3, 0.3, 0.3, 0.2);
	CGContextSetLineWidth(ctxt, 20.0);
	
	CGContextSaveGState(ctxt);
		//CGContextSetShadow(ctxt, CGSizeMake(0, 0), 15);
		CGContextSetShadowWithColor(ctxt, CGSizeMake(0, 0), 15, shadowColor);
		CGContextAddEllipseInRect(ctxt, CGRectMake(cx - radiusVolume, cy - radiusVolume, radiusVolume*2, radiusVolume*2));
		CGContextStrokePath(ctxt);
	CGContextRestoreGState(ctxt);
}


- (void)dealloc {
    [super dealloc];
}


@end

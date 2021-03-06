
/*
     File: DrawMouseBoxView.m
 Abstract: Dims the screen and allows user to select a rectangle with a cross-hairs cursor
  Version: 2.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "DrawMouseBoxView.h"


@implementation DrawMouseBoxView
{
	NSPoint _mouseDownPoint;
	NSRect _selectionRect;
    NSTextField *selectionDimensions;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
	return YES;
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}


- (void)mouseDown:(NSEvent *)theEvent
{
	_mouseDownPoint = [theEvent locationInWindow];
    
    selectionDimensions = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, 200, 20)];
    
    [selectionDimensions setBezeled:NO];
    [selectionDimensions setDrawsBackground:NO];
    [selectionDimensions setEditable:NO];
    [selectionDimensions setSelectable:NO];
    [selectionDimensions setFont:[NSFont fontWithName:@"HelveticaNeue" size:18]];
    [selectionDimensions setTextColor:[NSColor whiteColor]];
    
    [self addSubview:selectionDimensions];
}

- (void)mouseUp:(NSEvent *)theEvent
{
	NSPoint mouseUpPoint = [theEvent locationInWindow];
	NSRect selectionRect = NSMakeRect(
		MIN(_mouseDownPoint.x, mouseUpPoint.x), 
		MIN(_mouseDownPoint.y, mouseUpPoint.y), 
		MAX(_mouseDownPoint.x, mouseUpPoint.x) - MIN(_mouseDownPoint.x, mouseUpPoint.x),
		MAX(_mouseDownPoint.y, mouseUpPoint.y) - MIN(_mouseDownPoint.y, mouseUpPoint.y));
	[self.delegate drawMouseBoxView:self didSelectRect:selectionRect];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSPoint curPoint = [theEvent locationInWindow];
	NSRect previousSelectionRect = _selectionRect;
	_selectionRect = NSMakeRect(
		MIN(_mouseDownPoint.x, curPoint.x), 
		MIN(_mouseDownPoint.y, curPoint.y), 
		MAX(_mouseDownPoint.x, curPoint.x) - MIN(_mouseDownPoint.x, curPoint.x),
		MAX(_mouseDownPoint.y, curPoint.y) - MIN(_mouseDownPoint.y, curPoint.y));
    
    int roundedWidth = round(2.0f * _selectionRect.size.width) / 2.0f;
    int roundedHeight = round(2.0f * _selectionRect.size.height) / 2.0f;
    
    NSString *dimensions = [NSString stringWithFormat:@"Selection %d x %d", roundedWidth, roundedHeight];
    
    [selectionDimensions setStringValue:dimensions];
    
	[self setNeedsDisplayInRect:NSUnionRect(_selectionRect, previousSelectionRect)];
}

- (void)drawRect:(NSRect)dirtyRect 
{
	[[NSColor blackColor] set];
	NSRectFill(dirtyRect);
	[[NSColor whiteColor] set];
	NSFrameRect(_selectionRect);
}

@end

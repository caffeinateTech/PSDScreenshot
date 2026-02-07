//
//  AppDelegate.h
//  PSDScreenshot
//
//  Created by Rares Tamas on 3/22/16.
//  Copyright © 2016 Rares Tamas. All rights reserved.
//

#import "AboutWindowController.h"
#import "MAAttachedWindow.h"
#import <Cocoa/Cocoa.h>

@class IWGlobalHotkey;

@interface AppDelegate : NSObject <NSApplicationDelegate> {

  AboutWindowController *aboutController;

  IWGlobalHotkey *hotKey;

  MAAttachedWindow *attachedWindow;

  NSStatusItem *statusItem;

  NSMenu *mainMenu;

  BOOL popupShowed, timedScreenshotEnabled;

  NSString *pathForPSD;

  NSTimer *screenshotTimer;

  NSProgressIndicator *statusBarSpinner;

  int time;
}

// attached window
@property(retain) MAAttachedWindow *attachedWindow;
;

@property(assign) BOOL popupShowed;

@property(weak) IBOutlet NSView *popupView;

// settings window
@property(weak) IBOutlet NSWindow *settingsWindow;

@property(weak) IBOutlet NSButton *loginCheckBox;

@property(weak) IBOutlet NSTextField *pathLabel;

@property(weak) IBOutlet NSButton *timedScreenshotCheckBox;

@property(weak) IBOutlet NSSlider *timeSlider;

@property(weak) IBOutlet NSTextField *timeLabel;

@property(weak) IBOutlet NSButton *soundCheckBox;

// Settings Window Controls
- (IBAction)clickedSettings:(id)sender;

- (IBAction)clickedStartAtLogin:(id)sender;

- (IBAction)clickedChangeSavedFolder:(id)sender;

- (IBAction)clickedTimedScreenshot:(id)sender;

- (IBAction)clickedTimeSlider:(id)sender;

- (IBAction)clickedSoundCheckBox:(id)sender;

// About Window Control
- (IBAction)clickedAbout:(id)sender;

@end

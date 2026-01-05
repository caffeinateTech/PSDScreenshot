//
//  AppDelegate.m
//  PSDScreenshot
//
//  Created by Rares Tamas on 3/22/16.
//  Copyright © 2016 Rares Tamas. All rights reserved.
//

#import "AppDelegate.h"
#import "IWGlobalHotkey.h"
#import "PSDWriter.h"
#import <Carbon/Carbon.h>
#import <QuartzCore/QuartzCore.h>
#import <ScreenCaptureKit/ScreenCaptureKit.h>
#import <ServiceManagement/ServiceManagement.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize popupView, attachedWindow, popupShowed;

@synthesize settingsWindow, loginCheckBox, pathLabel, timedScreenshotCheckBox,
    timeLabel, timeSlider, soundCheckBox;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

  // get user desktop path
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory,
                                                       NSUserDomainMask, YES);
  NSString *userDesktopPath = [paths objectAtIndex:0];

  [[NSUserDefaults standardUserDefaults]
      registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithBool:YES],
                                         @"firstTimeRunning",
                                         [NSNumber numberWithBool:NO], @"login",
                                         userDesktopPath, @"pathForPSD",
                                         [NSNumber numberWithInt:30],
                                         @"timerSeconds",
                                         [NSNumber numberWithBool:1],
                                         @"soundState", nil]];
  [[NSUserDefaults standardUserDefaults] synchronize];

  // NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
  //[[NSUserDefaults standardUserDefaults]
  // removePersistentDomainForName:appDomain];

  popupShowed = NO;
  timedScreenshotEnabled = NO;

  // LOGIN
  BOOL tmpLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
  [loginCheckBox setState:tmpLogin];

  pathForPSD =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"pathForPSD"];
  [pathLabel setStringValue:pathForPSD];

  BOOL tmpSoundState =
      [[NSUserDefaults standardUserDefaults] boolForKey:@"soundState"];
  [soundCheckBox setState:tmpSoundState];

  time = (int)[[NSUserDefaults standardUserDefaults]
      integerForKey:@"timerSeconds"];
  [timeSlider setIntValue:time];
  [timeLabel
      setStringValue:[NSString stringWithFormat:@"Timer: %i seconds", time]];

  [self prepareStatusItem];

  [self checkForFirstRun];

  [self checkOSXVersion];

  [self prepareHotKey];
}

// ==========================
// prepare and enable hot key
// ==========================
- (void)prepareHotKey {

  hotKey = [IWGlobalHotkey
      globalHotKeyWithKey:@"6"
                modifiers:[NSArray arrayWithObjects:IWGLOBALHOTKEY_COMMAND,
                                                    IWGLOBALHOTKEY_SHIFT, nil]
                   target:self
                   action:@selector(doScreenshot)]; // takeScreenshot

  if ([hotKey installHotKey]) {

    // NSLog(@"Installing the %@ hotkey", hotKey.stringCommand);
  }
}

// ====================================================================
// check OS X version for dark mode in yosemite (change tab icon color)
// ====================================================================
- (void)checkOSXVersion {

  // For dark mode in yosemite
  if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_9) {

  } else {

    [statusItem.image setTemplate:YES];
  }
}

// ================================
// prepare menu icon for status bar
// ================================
- (void)prepareStatusItem {

  statusItem = [[NSStatusBar systemStatusBar]
      statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setMenu:mainMenu];
  [statusItem setHighlightMode:YES];
  [statusItem setEnabled:YES];
  [statusItem setToolTip:@"PSDScreenshot"]; // app name
  [statusItem setImage:[NSImage imageNamed:@"MenuBarIcon.png"]];
  [[statusItem image] setTemplate:YES];
  [statusItem setTarget:self];
  [statusItem setAction:@selector(openPopUp:)];
}

// ========================
// show popUp from menu bar
// ========================
- (void)openPopUp:(id)sender {

  if (popupShowed == NO) {

    NSRect frame = [[statusItem valueForKey:@"window"] frame];

    NSPoint pt = NSMakePoint(NSMidX(frame), NSMinY(frame));
    attachedWindow = [[MAAttachedWindow alloc] initWithView:popupView
                                            attachedToPoint:pt
                                                   inWindow:nil
                                                     onSide:MAPositionBottom
                                                 atDistance:5.0];

    attachedWindow.appDelegateObject = self;

    [attachedWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];

    popupShowed = YES;
  } else {

    [attachedWindow orderOut:nil];

    popupShowed = NO;
  }
}

// ==========================================
// check if app is running for the first time
// ==========================================
- (void)checkForFirstRun {

  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstTimeRunning"] ==
      YES) {

    [self openPopUp:nil];

    //[self savePanel];

    BOOL firstTimeRun = NO;

    [[NSUserDefaults standardUserDefaults] setBool:firstTimeRun
                                            forKey:@"firstTimeRunning"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self showSavePanelFirstTime];
  }
}

- (void)showSavePanelFirstTime {

  NSOpenPanel *myOpenPanel = [NSOpenPanel openPanel];
  [myOpenPanel setCanChooseFiles:NO];
  [myOpenPanel setCanCreateDirectories:YES];
  [myOpenPanel setCanChooseDirectories:YES];
  [myOpenPanel setPrompt:@"Choose Destination"];

  [myOpenPanel beginWithCompletionHandler:^(NSInteger result) {
    if (result == NSFileHandlingPanelOKButton) {

      NSString *selectedPath = [[myOpenPanel URL] path];

      pathForPSD = selectedPath;

      [pathLabel setStringValue:pathForPSD];

      [[NSUserDefaults standardUserDefaults] setObject:pathForPSD
                                                forKey:@"pathForPSD"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (result == NSModalResponseCancel) { // aici

      // run a modal alert
      NSAlert *alert = [[NSAlert alloc] init];
      [alert addButtonWithTitle:@"OK"];
      [alert setMessageText:@"Please choose destination."];
      [alert runModal];

      [self showSavePanelFirstTime];
    }
  }];
}

#pragma Settings Controls

// =======================
// present settings window
// =======================
- (IBAction)clickedSettings:(id)sender {

  [settingsWindow setOpaque:NO];
  [settingsWindow setBackgroundColor:[NSColor clearColor]];
  [settingsWindow makeKeyAndOrderFront:self];
}

// ===============================
// enable/disable timed screenshot
// ===============================
- (IBAction)clickedTimedScreenshot:(id)sender {

  timedScreenshotEnabled = [timedScreenshotCheckBox state];
}

// ====================
// change timer seconds
// ====================
- (IBAction)clickedTimeSlider:(id)sender {

  time = [timeSlider intValue];

  [timeLabel
      setStringValue:[NSString stringWithFormat:@"Timer: %i seconds", time]];

  [[NSUserDefaults standardUserDefaults] setInteger:time
                                             forKey:@"timerSeconds"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

// =========================
// start app at login on/off
// =========================
- (IBAction)clickedStartAtLogin:(id)sender {

  BOOL checkBoxLogin = [sender state];

  [[NSUserDefaults standardUserDefaults] setBool:checkBoxLogin forKey:@"login"];
  [[NSUserDefaults standardUserDefaults] synchronize];

  if (!SMLoginItemSetEnabled(
          (__bridge CFStringRef) @"veghTamas.PSDScreenshotHelper",
          (BOOL)[sender state])) {
    //  NSLog(@"login item is not succesful");
  }
}

// =========================
// present (open) SAVE panel
// =========================
- (IBAction)clickedChangeSavedFolder:(id)sender {

  [self savePanel];
}

// ===========================
// create and show NSOpenPanel
// ===========================
- (void)savePanel {

  NSOpenPanel *myOpenPanel = [NSOpenPanel openPanel];
  [myOpenPanel setCanChooseFiles:NO];
  [myOpenPanel setCanCreateDirectories:YES];
  [myOpenPanel setCanChooseDirectories:YES];
  [myOpenPanel setPrompt:@"Choose Destination"];

  [myOpenPanel beginWithCompletionHandler:^(NSInteger result) {
    if (result == NSFileHandlingPanelOKButton) {

      NSString *selectedPath = [[myOpenPanel URL] path];

      pathForPSD = selectedPath;

      [pathLabel setStringValue:pathForPSD];

      [[NSUserDefaults standardUserDefaults] setObject:pathForPSD
                                                forKey:@"pathForPSD"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
  }];
}

- (IBAction)clickedSoundCheckBox:(id)sender {

  BOOL soundState = [soundCheckBox state];

  [[NSUserDefaults standardUserDefaults] setBool:soundState
                                          forKey:@"soundState"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - About

// ===========================================
// alloc and present about controller (window)
// ===========================================
- (IBAction)clickedAbout:(id)sender {

  aboutController = [[AboutWindowController alloc]
      initWithWindowNibName:@"AboutWindowController"];

  [aboutController showWindow:self];
}

// ===========================================
// get the screen that currently has focus
// ===========================================
- (NSScreen *)getFocusedScreen {
  // Get the frontmost application
  NSRunningApplication *frontApp =
      [[NSWorkspace sharedWorkspace] frontmostApplication];

  // Get all windows for the frontmost application
  CFArrayRef windowListRef = CGWindowListCopyWindowInfo(
      kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
  NSArray *windows = CFBridgingRelease(windowListRef);

  for (NSDictionary *windowInfo in windows) {
    NSString *ownerName = windowInfo[(NSString *)kCGWindowOwnerName];
    NSNumber *windowLayer = windowInfo[(NSString *)kCGWindowLayer];

    // Check if this window belongs to the frontmost app and is a normal window
    // (layer 0)
    if ([ownerName isEqualToString:frontApp.localizedName] &&
        [windowLayer intValue] == 0) {
      // Get window bounds
      NSDictionary *bounds = windowInfo[(NSString *)kCGWindowBounds];
      CGRect windowRect;
      CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)bounds,
                                             &windowRect);

      // Find which screen contains this window
      for (NSScreen *screen in [NSScreen screens]) {
        if (NSIntersectsRect(NSRectFromCGRect(windowRect), screen.frame)) {
          return screen;
        }
      }
    }
  }

  // Fallback to main screen if we can't determine focused screen
  return [NSScreen mainScreen];
}

// ===============================================
// show flash animation on specified screen
// ===============================================
- (void)showFlashOnScreen:(NSScreen *)screen {
  // Create a borderless, fullscreen window for the flash effect
  NSWindow *flashWindow =
      [[NSWindow alloc] initWithContentRect:screen.frame
                                  styleMask:NSWindowStyleMaskBorderless
                                    backing:NSBackingStoreBuffered
                                      defer:NO
                                     screen:screen];

  [flashWindow setBackgroundColor:[NSColor whiteColor]];
  [flashWindow setAlphaValue:0.0];
  [flashWindow setOpaque:NO];
  [flashWindow setLevel:NSScreenSaverWindowLevel]; // Above everything except
                                                   // screen saver
  [flashWindow setIgnoresMouseEvents:YES];
  [flashWindow makeKeyAndOrderFront:nil];

  // Animate the flash
  [NSAnimationContext
      runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.1; // Fast fade in
        [[flashWindow animator] setAlphaValue:0.4];
      }
      completionHandler:^{
        // Then fade out
        [NSAnimationContext
            runAnimationGroup:^(NSAnimationContext *context) {
              context.duration = 0.2; // Slower fade out
              [[flashWindow animator] setAlphaValue:0.0];
            }
            completionHandler:^{
              // Close the window after animation
              [flashWindow close];
            }];
      }];
}

#pragma mark - Screenshot func

// =========================
// check if timer is enabled
// =========================
- (void)doScreenshot {

  if (timedScreenshotEnabled == YES) {

    if (screenshotTimer != nil) {

      time = [timeSlider intValue];
      [screenshotTimer invalidate];
      screenshotTimer = nil;
    }

    screenshotTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(onTick)
                                                     userInfo:nil
                                                      repeats:YES];

    [statusItem setLength:40.0];
    [statusItem setTitle:[NSString stringWithFormat:@"%i", time]];
  } else {

    [self takeScreenshot];
  }
}

// ===================================================================
// when timer is enabled change status item length and take screenshot
// ===================================================================
- (void)onTick {

  time--;

  BOOL soundState = [soundCheckBox state];

  if (soundState == 1) {

    [[NSSound soundNamed:@"bipSound"] play];
  }

  [statusItem setLength:40.0];
  [statusItem setTitle:[NSString stringWithFormat:@"%i", time]];

  if (time <= 0) {

    time = [timeSlider intValue];

    [statusItem setLength:20.0];

    [self takeScreenshot];

    if (screenshotTimer != nil) {

      [screenshotTimer invalidate];
      screenshotTimer = nil;
    }
  }
}

// ================================================================================
// take multiple screesnhots from desktop "layers" and transform them into PSD
// file
// ================================================================================
- (void)takeScreenshot {

  BOOL soundState = [soundCheckBox state];

  if (soundState == 1) {
    [[NSSound soundNamed:@"shutterSound"] play];
  }

  // Get the currently focused screen
  NSScreen *focusedScreen = [self getFocusedScreen];

  // Get screen dimensions with scale factor for retina displays
  float scaleFactor = focusedScreen.backingScaleFactor;
  float screenWidth = focusedScreen.frame.size.width * scaleFactor;
  float screenHeight = focusedScreen.frame.size.height * scaleFactor;

  // Store focused screen for flash animation later
  __block NSScreen *screenForFlash = focusedScreen;

  // Get shareable content (windows) using ScreenCaptureKit
  if (@available(macOS 12.3, *)) {
    [SCShareableContent getShareableContentWithCompletionHandler:^(
                            SCShareableContent *_Nullable content,
                            NSError *_Nullable error) {
      if (error) {
        NSLog(@"Error getting shareable content: %@",
              error.localizedDescription);
        return;
      }

      // Initialize a new PSD writer with the desired canvas size
      PSDWriter *w = [[PSDWriter alloc]
          initWithDocumentSize:CGSizeMake(screenWidth, screenHeight)];

      // Get all on-screen windows
      NSArray<SCWindow *> *windows = content.windows;

      // Filter for windows on the focused screen only
      NSMutableArray<SCWindow *> *focusedScreenWindows = [NSMutableArray array];
      CGRect focusedScreenRect = NSRectToCGRect(focusedScreen.frame);

      for (SCWindow *window in windows) {
        if (window.isOnScreen) {
          // Check if window intersects with focused screen bounds
          CGRect windowFrame = window.frame;
          if (CGRectIntersectsRect(windowFrame, focusedScreenRect)) {
            [focusedScreenWindows addObject:window];
          }
        }
      }

      // Create dispatch group to wait for all async captures
      dispatch_group_t captureGroup = dispatch_group_create();

      // Array to hold captured layers info (we'll process in reverse order
      // later)
      NSMutableArray *capturedLayers = [NSMutableArray array];

      // Capture each window on the focused screen
      for (NSInteger i = 0; i < focusedScreenWindows.count; i++) {
        SCWindow *window = focusedScreenWindows[i];

        dispatch_group_enter(captureGroup);

        // Create content filter for this specific window
        SCContentFilter *filter =
            [[SCContentFilter alloc] initWithDesktopIndependentWindow:window];

        // Create configuration for screenshot
        SCStreamConfiguration *config = [[SCStreamConfiguration alloc] init];
        config.width = screenWidth;
        config.height = screenHeight;
        config.showsCursor = NO;

        // Capture the window
        [SCScreenshotManager
            captureImageWithFilter:filter
                     configuration:config
                 completionHandler:^(CGImageRef _Nullable sampleBuffer,
                                     NSError *_Nullable error) {
                   if (error) {
                     NSLog(@"Error capturing window: %@",
                           error.localizedDescription);
                     dispatch_group_leave(captureGroup);
                     return;
                   }

                   if (sampleBuffer) {
                     // Store the captured image data with window info
                     NSString *ownerName =
                         window.owningApplication
                             ? window.owningApplication.applicationName
                             : @"Unknown";
                     NSString *windowTitle = window.title ? window.title : @"";

                     NSDictionary *layerInfo = @{
                       @"image" : (__bridge id)sampleBuffer,
                       @"name" : ownerName,
                       @"title" : windowTitle,
                       @"index" : @(i)
                     };

                     @synchronized(capturedLayers) {
                       [capturedLayers addObject:layerInfo];
                     }
                   }

                   dispatch_group_leave(captureGroup);
                 }];
      }

      // When all captures are complete, create the PSD
      dispatch_group_notify(captureGroup, dispatch_get_main_queue(), ^{
        // Sort layers by index in reverse order (back to front)
        NSArray *sortedLayers = [capturedLayers
            sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1,
                                                           NSDictionary *obj2) {
              NSInteger idx1 = [obj1[@"index"] integerValue];
              NSInteger idx2 = [obj2[@"index"] integerValue];
              // Reverse order for back-to-front layering
              return [@(idx2) compare:@(idx1)];
            }];

        // Add all layers to PSD
        for (NSDictionary *layerInfo in sortedLayers) {
          CGImageRef cgImage = (__bridge CGImageRef)layerInfo[@"image"];
          NSString *layerName =
              [NSString stringWithFormat:@"%@", layerInfo[@"name"]];

          [w addLayerWithCGImage:cgImage
                         andName:layerName
                      andOpacity:1.0
                       andOffset:CGPointZero];
        }

        // Create the PSD data
        NSData *psd = [w createPSDData];

        NSString *psdFileName = [NSString
            stringWithFormat:@"Screenshot %@.psd", [self returnDateString]];
        NSString *writePsdToFile =
            [NSString stringWithFormat:@"%@/%@", pathForPSD, psdFileName];

        // Write the PSD data to disk
        [psd writeToFile:writePsdToFile atomically:NO];

        NSLog(@"PSD saved to: %@", writePsdToFile);

        // Show flash animation on the focused screen
        [self showFlashOnScreen:screenForFlash];
      });
    }];
  } else {
    // Fallback for older macOS versions (pre-12.3)
    NSLog(@"ScreenCaptureKit requires macOS 12.3 or later");

    // Show alert to user
    dispatch_async(dispatch_get_main_queue(), ^{
      NSAlert *alert = [[NSAlert alloc] init];
      [alert setMessageText:@"macOS Version Too Old"];
      [alert setInformativeText:@"ScreenCaptureKit requires macOS 12.3 or "
                                @"later. Please update your system."];
      [alert addButtonWithTitle:@"OK"];
      [alert runModal];
    });
  }
}

// =====================================
// create psd file from screenshot image
// =====================================
- (CGImageRef)newCGImageForNSImage:(NSImage *)i {

  CGImageSourceRef source =
      CGImageSourceCreateWithData((CFDataRef)[i TIFFRepresentation], NULL);
  CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
  CFRelease(source);

  return imageRef;
}

// ====================
// return time and date
// ====================
- (NSString *)returnDateString {

  NSDate *currDate = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
  NSString *dateString = [dateFormatter stringFromDate:currDate];

  return dateString;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

@end

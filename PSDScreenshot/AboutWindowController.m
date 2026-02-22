//
//  AboutWindowController.m
//  Capsy
//
//  Created by Rares Tamas on 3/14/16.
//  Copyright © 2016 Rares Tamas. All rights reserved.
//

#import "AboutWindowController.h"

@interface AboutWindowController ()

@end

@implementation AboutWindowController

@synthesize websiteBtn, mailBtn;

- (void)windowDidLoad {
  [super windowDidLoad];

  [self changeTextColorOfButtons:websiteBtn andColor:[NSColor linkColor]];
  [self changeTextColorOfButtons:mailBtn andColor:[NSColor linkColor]];
}

- (IBAction)clickedRate:(id)sender {

  [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/psdscreenshot/id1097516723?mt=12"]];
}

- (IBAction)clickedWebsite:(id)sender {

  [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"https://www.caffeinatetech.com"]];
}

- (IBAction)clickedMail:(id)sender {

  [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"mailto:office@caffeinatetech.com"]];
}

- (void)changeTextColorOfButtons:(NSButton *)buttons andColor:(NSColor *)myColor {

  NSColor *color = myColor;
  NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[buttons attributedTitle]];
  NSRange titleRange = NSMakeRange(0, [colorTitle length]);
  [colorTitle addAttribute:NSForegroundColorAttributeName
                     value:color
                     range:titleRange];
  [buttons setAttributedTitle:colorTitle];
}



@end

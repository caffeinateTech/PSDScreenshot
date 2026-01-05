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

@synthesize websiteBtn, facebookBtn, mailBtn;

- (void)windowDidLoad {
    
    [super windowDidLoad];
    
    [self.window setOpaque: NO];
    [self.window setBackgroundColor:[NSColor clearColor]];
    
    [self changeTextColorOfButtons:websiteBtn andColor:[NSColor blueColor]];
    [self changeTextColorOfButtons:facebookBtn andColor:[NSColor blueColor]];
    [self changeTextColorOfButtons:mailBtn andColor:[NSColor blueColor]];
}


// ===========================
// Send user to a specific app
// ===========================
- (IBAction)clickedIcon:(id)sender {
    
    NSButton *myBtn = (NSButton *)sender;
    
    if (myBtn.tag == 0) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/easycalculator/id1036245180?mt=12"]];
    }
    else if (myBtn.tag == 1) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/meme-creator/id1081432627?mt=12"]];
    }
    else if (myBtn.tag == 2) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/falling-hearts/id1080403671?mt=12"]];
    }
    else if (myBtn.tag == 3) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/periodictableelements/id1077419184?mt=12"]];
    }
    else if (myBtn.tag == 4) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/stayfocused/id1088252294?mt=12"]];
    }
    else if (myBtn.tag == 5) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/battery-tracker/id1033924023?mt=12"]];
    }
    else if (myBtn.tag == 6) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/banking-calculators/id1083446787?mt=12"]];
    }
    else if (myBtn.tag == 7) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/corporatefinancecalc/id1086077368?mt=12"]];
    }
    else if (myBtn.tag == 8) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/leaf-guide/id1065885760?mt=12"]];
    }
    else if (myBtn.tag == 9) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/snowfall/id1068219430?mt=12"]];
    }
    else if (myBtn.tag == 10) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/backgroundclock/id1060642287?mt=12"]];
    }
    else if (myBtn.tag == 11) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/statistical-calculations/id1076180705?mt=12"]];
    }
    else if (myBtn.tag == 12) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/generalfinancecalc/id1088307437?mt=12"]];
    }
    else if (myBtn.tag == 13) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/easytabcalculator/id1053527037?mt=12"]];
    }
    else if (myBtn.tag == 14) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/financial-calculators/id1091582799?mt=12"]];
    }
    else if (myBtn.tag == 15) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/stocksbondscalc/id1089995958?mt=12"]];
    }
    else if (myBtn.tag == 16) {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/capsy/id1093804328?mt=12"]];
    }
}



// ============
// Rate our app
// ============
- (IBAction)clickedRate:(id)sender {
    
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"macappstore://itunes.apple.com/us/app/psdscreenshot/id1097516723?mt=12"]];
}



// ===================
// Present our website
// ===================
- (IBAction)clickedWebsite:(id)sender {
    
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"http://gremlinssoft.wordpress.com"]];
}



// ====================
// Present our facebook
// ====================
- (IBAction)clickedFacebook:(id)sender {
    
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"https://www.facebook.com/gremlinssoft/"]];
}



// =================
// Send mail to roby
// =================
- (IBAction)clickedMail:(id)sender {
    
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"mailto:veghferencrobert@yahoo.com"]];
}



// ================================
// Change text color of the buttons
// ================================
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

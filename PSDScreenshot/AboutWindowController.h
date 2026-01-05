//
//  AboutWindowController.h
//  Capsy
//
//  Created by Rares Tamas on 3/14/16.
//  Copyright © 2016 Rares Tamas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AboutWindowController : NSWindowController {
    
}

@property (strong) IBOutlet NSButton *websiteBtn;

@property (strong) IBOutlet NSButton *facebookBtn;

@property (strong) IBOutlet NSButton *mailBtn;


- (IBAction)clickedIcon:(id)sender;

- (IBAction)clickedRate:(id)sender;

- (IBAction)clickedWebsite:(id)sender;

- (IBAction)clickedFacebook:(id)sender;

- (IBAction)clickedMail:(id)sender;


@end

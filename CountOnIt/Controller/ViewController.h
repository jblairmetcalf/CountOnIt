//
//  ViewController.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

/*
 Upgrade for themes
 open drawer with pan and threshold
 smaller restore purchases icon
 http://upwave.com/trackit/getstarted
 pause button of sorts
 If cancel out of in app purchase give alert
 
 Ask Michael: bounds instead of frame
 
 http://mitmproxy.org/
 
 app site
 
 -- -- -- -- --
 
 Dice
 Stack exchange, stack overflow
 Black pixel
 
 -- -- -- -- --
 
 individual reminders per tally: time and pattern
 translate: http://www.ibabbleon.com/
 add date to chart
 guided rate app like lumosity
 habit infographics
 chart doesnt scale well when large
 undo?
 bounce easing? UIViewAnimationOptionCurveEaseOut
 play locked sound?
 
 sync across devices
 
 reuse code
 search can be improved
 finalize array before begin end row animations
 managed context will solve search problems
 
 -- -- -- -- --
 
 #define
 
 ipad
 clean up code
 Search field in table view?
 select which to export?
 
 textfield does not resign after back to export from review export
 x out y for a goal
 go through code to find resuable
 add reminders to welcome/tour screen
 weird last scroll on welcome not tour
 nsstringlocalize
 ?stitch counts?
 global settings preferences?
 appirater?
 buggy instructions animation?
 bounds instead of frame
 gesture on all applicable screens?
 2 down at same time?
 view instructions in settings?
 restart animations: Arrow on unsleep?
 instruction animation? scroll to fast instructions
 colors to global
 show arrow on noTallies if inactive
 double check sorting: If on that side then scroll to recently edited
 introspection
 Reset timer on become active?
 Dismiss screens on sleep
 Export in nav bar?
 
 2014-03-03 17:25:25.445 TapTally[800:60b] *** Assertion failure in -[UIViewAnimation initWithView:indexPath:endRect:endAlpha:startFraction:endFraction:curve:animateFromCurrentPosition:shouldDeleteAfterAnimation:editing:], /SourceCache/UIKit/UIKit-2903.23/UITableViewSupport.m:2661
 2014-03-03 17:25:25.454 TapTally[800:60b] *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Cell animation stop fraction must be greater than start fraction'
 *** First throw call stack:
 (0x2fb73f4b 0x39f036af 0x2fb73e25 0x3051bfe3 0x324e414f 0x324e7a9f 0x324e2033 0x324e1adb 0x324b9ab3 0x52d0d 0x3231ba85 0x32454567 0x52bbb 0x2fb36119 0x2faaa257 0x3048fc2d 0x3049450b 0x62785 0x703e1 0x324fedcd 0x324fec15 0x324038bb 0x324b6f7b 0x32366fb9 0x322df1f3 0x2fb3f1cd 0x2fb3cb71 0x2fb3ceb3 0x2faa7c27 0x2faa7a0b 0x34786283 0x3234b049 0x762e9 0x3a40bab7)
 libc++abi.dylib: terminating with uncaught exception of type NSException
 
 warning to no text in textfield
 "Feb 24 14:22:27 Js-MacBook-Pro.local TapTally[865] <Error>: CGContextSetFillColorWithColor: invalid context 0x0. This is a serious error. This application, or a library it uses, is using an invalid context  and is thereby contributing to an overall degradation of system stability and reliability. This notice is a courtesy: please fix this problem. It will become a fatal error in an upcoming update."
 */

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface ViewController : GAITrackedViewController

extern NSString *const WelcomeComplete;
extern NSString *const ShowAddTally;

@end

/*
 restoreCompletedTransactions
 
 If pinned or locked on edit:
 [[NSNotificationCenter defaultCenter] postNotificationName:TallyPinnedChanged object:self];
 
 DL puracheable ids, ask Michael about hardcaode in app ids
 
 apple $5
 
 correct vimeo screen
 
 \\ try it on ipad
 correct init settings
 break it
 
 CountOnIt: Track and chart habits and goals
 set correct app id?
 update itunesconnect
 
 schemes
 testflight sdk
 http://www.raywenderlich.com/48750/testflight-sdk-tutorial
 
 design: unlimited tallies & exports + daily reminders
 restore, check no internet connection
 In app purachse for more counters and export:
 http://www.raywenderlich.com/21081/introduction-to-in-app-purchases-in-ios-6-tutorial
 demo users: http://docs.xamarin.com/guides/ios/application_fundamentals/in-app_purchasing/part_2_-_store_kit_overview_and_retreiving_product_information/
 rewrite in app purchase code
 limit use
 modal screen
 update in app purchase with demo users
 
 CountOnIt-Info.plist
 Bundle identifier
 com.jblairmetcalf.${PRODUCT_NAME:rfc1034identifier}
 
 iOS 6?
 support@counton.it
 upload to tesflight
 class: ASIdentifierManager
 selector: advertisingIdentifier
 framework: AdSupport.framework
 http://www.raywenderlich.com/53459/google-analytics-ios
 https://developers.google.com/analytics/devguides/collection/ios/v3/
 google analytics
 update screens to CountOnIt
 Reexport welcome with top three things to count
 settings: self ad, like substantial, in settings
 TapTally - Keep count and track goals
 Change app name: HabitTap, Habitap, *TapItHabit, TapHabit
 taptally.com
 TapToTally
 http://stackoverflow.com/questions/4954015/how-to-change-xcode-project-name
 rebuild with TapToTally
 Less apparent x on hints
 swipe an item\nto
 Restart animations
 60*60*24
 Slow down, two videos, tap longer
 Delay welcome, hints
 reset counter
 check alerts
 deselect rate app
 daily reminders: add text to welcome/tour:
 http://stackoverflow.com/questions/10328168/how-to-create-reminder-for-some-time-like-remind-me-in-30-mins-in-iphone
 Rate app, view tour, contact support
 x on hints
 Scroll up and down on either
 check empty x on search/all
 Done! 1.0f
 Export Chart not Tallies
 Break hints: number repeated named
 "You're all set!"
 check gradients
 Hints along the way
 Sort list before export
 Check empty in export
 Put PictNotes on phone
 Search result no change
 name chart
 // square hint
 Make tally buttons larger
 Width on search tf
 text follow cursor
 Fade out many tallies
 Text field x not working
 contact support in settings
 rate app in settings
 Combine welcome and tour classes
 Sell in welcome
 // com.jblairmetcalf.${PRODUCT_NAME:rfc1034identifier}
 http://www.raywenderlich.com/48750/testflight-sdk-tutorial
 Louder and different sounds
 Longer tour with quick exit
 sounds: http://stackoverflow.com/questions/4215891/how-to-play-a-sound-in-objective-c-iphone-coding
 TapTally Development Provisioning Profile
 http://wiki.gxtechnical.com/commwiki/servlet/hwiki?HowTo:+Creating+a+Provisioning+Profile+for+iOS+Development,
 http://help.testflightapp.com/customer/portal/articles/1333914
 Rate app: http://stackoverflow.com/questions/16896075/rate-this-app-in-ios
 less instructions
 view tour?
 no results view
 // tobedelted
 double tap to zoom in export image
 search:
 - (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
 global foucs changed on drawer
 dont open if open
 Scroll up animates content offset
 all values equal zero
 draw chart
 scroll down instruction
 export tallies
 code data or plist
 http://goaheadwithiphonetech.blogspot.com/2011/09/how-to-create-nsmanagedobjectcontext.html
 
 http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
 UITableViewCellAccessoryCheckmark
 reuse cell code
 ExportTalliesCell > ExportTalliesViewCell
 contentOffsetForHeader?
 search dismiss keyboard
 TallyValueView -> TextFieldView
 return (self.scrollView.contentOffset.x * 2.0f + width) / (width * 2.0f);
 return self.scrollView.contentOffset.x/width;
 instructions
 switchButton.onTintColor?
 Hold shouldn't work on locked
 Tally pinned changed
 -1 bring to front
 custom action sheets
 http://stackoverflow.com/questions/17946358/how-to-customize-uiactionsheet-ios
 http://stackoverflow.com/questions/16650787/ios-6-uiactivityviewcontroller-items
 http://stackoverflow.com/questions/13907156/uiactivityviewcontroller-taking-a-long-time-to-present
 
 cross fade toggle views
 reverse all delete and add tallies
 dont do tallies.count
 quirks with scroll and deleting
 quirk with deleting
 start up bug with drawer
 update AI file
 sharedInstance
 TalliesRemovedTally -> TallyDeleted?
 optimize reloadData: talliesReloadedData: be specific with which cell changed
 nice delete and add animation
 If no tallies, then disable settings
 Touch table view bg to close drawer?
 // delete should be action sheet not alert?
 unanimate get started arrow?
 scroll to recently edited
 first hold one then two bug
 add dates to fake data
 // when side scroll between details scroll to cell
 scroll to new counter
 reset all counters
 delete all counters
 sort
 Can not delete locked
 arrow in parent fade out view
 Lock still not in corner
 Init show empty
 Remove since ago, use in
 review new screens
 update prettyDate NSTimer
 commas
 ... on 2000 on many cell
 hold down to fast
 // - (void)talliesReloadedData:(NSNotification *)notification{[self toggleViews];}
 // TallyTextButton : UIView -> UIButton
 IBAction
 check colors
 empty doesnt always show
 add sound
 SoundEffect *tickSound = [[SoundEffect alloc] initWithContentsOfFile: @"/System/Library/Audio/UISounds/Tock.caf"];
 NSArray *array = [filemanager contentsOfDirectoryAtPath:@"/System/Library/Audio/UISounds/" error:nil];
 self.soundNamesArray = array;
 http://iphonedevwiki.net/index.php/AudioServices
 http://stackoverflow.com/questions/14294581/how-to-play-a-sound-effect-with-audioservices-objective-c
 Preferences to Global
 reset user defaults function
 get date correct
 http://stackoverflow.com/questions/1054558/vertically-align-text-within-a-uilabel
 http://stackoverflow.com/questions/4382976/multiline-uilabel-with-adjustsfontsizetofitwidth
 http://stackoverflow.com/questions/19145078/ios-7-sizewithattributes-replacement-for-sizewithfontconstrainedtosize
 limit title length with ...
 make pixel perfect
 X on textfield
 check locked: drawer, colors, pinned, locked
 locked in edit?
 // vibration?
 UIViewContentModeScale, UIViewContentModeScaleAspectFill
 global padding, radius, distance, duration, multiplier
 float to CGFloat
 scroll to top with status bar
 // cell edit mode?
 // scrollViewWillBeginDragging to class
 // many cell selected?
 // locked and pinned colors?
 settings
 http://www.informit.com/articles/article.aspx?p=2091958
 // click drawer to close
 locked overlay
 // Pulse lock on press
 // settings singleton?
 .count
 new settings icons
 adjust preferences
 get started arrow: grey, timed, memory
 match drawer icon layout
 get started arrow
 settings
 close drawer after clicking lock
 locked and unlocked
 // on press depression animation
 swipe gestures to cancel
 fix edit hieght
 simplify add edit
 edit screen
 pinned
 need #import <QuartzCore/QuartzCore.h> ?
 export icons and launch screen as vector
 optimize Card background
 < Tallies ! TapTally
 no increment if drawer open
 back out gradients
 make back edit tally an arrow
 Back out drawer
 hide drawer
 if (self.isLarge) {
 page control
 remove "page" from scrollview
 no select cell
 re export app icon and launch images
 replace notifications with delegate
 crashes when clicking plus minus: incrementUp notification on second modal then plus
 include fonts
 edit screen
 counters to tallies, counter to tally
 redesign
 background colors
 brand fonts
 
 UIColor *GlobalColorNavigationBar = [UIColor colorWithHexString:@"#"];
 UIColor *GlobalColorDarkText;
 UIColor *GlobalColorTint;
 UIColor *GlobalColorBlue;
 UIColor *GlobalColorLightBlue;
 UIColor *GlobalColorGreen;
 UIColor *GlobalColorLightGreen;
 UIColor *GlobalColorYellow;
 UIColor *GlobalColorOrange;
 UIColor *GlobalColorPink;
 UIColor *GlobalColorPurple;
 
 Navigation Bar:
 f6f6f6
 246, 246, 246
 
 Dark Text:
 4c4c4c
 76, 76, 76
  
 Link:
 ff2956
 255, 41, 86
 
 Colors:
 
 459ba8
 69, 155, 168
 
 5ab6cc
 90, 182, 204
 
 79c267
 121, 194, 103
 
 b6cc35
 182, 204, 53
 
 f2cc2e
 242, 204, 46
 
 f28c33
 242, 140, 51
 
 e868a2
 232, 104, 162
 
 bf62a6
 191, 98, 166
 
 #define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
*/
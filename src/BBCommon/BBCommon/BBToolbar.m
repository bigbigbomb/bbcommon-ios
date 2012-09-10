//
// Created by brian on 9/10/12.
//
//


#import "BBToolbar.h"

#define kNextPreviousTag 10001
#define kDoneButtonTag 10002


@interface BBToolbar ()
@property(nonatomic, retain, readwrite) NSArray *controls;

@end

@implementation BBToolbar
@synthesize controls = _controls;


#pragma mark - Static

+ (id)newInputAccessoryToolbar:(NSArray *)controls {
    BBToolbar *toolbar = [[BBToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];

    NSMutableArray *items = [NSMutableArray array];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.momentary = YES;
    [segmentedControl addTarget:toolbar action:@selector(accessoryNextPreviousTap:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segmentedButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    segmentedButton.tag = kNextPreviousTag;
    [items insertObject:segmentedButton atIndex:0];
    segmentedControl.selectedSegmentIndex = -1;

    [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:toolbar action:@selector(accessoryDoneTap:)];
    button.tag = kDoneButtonTag;
    [items addObject:button];

    toolbar.items = items;
    toolbar.controls = controls;
    [segmentedControl release];
    [segmentedButton release];
    [button release];


    // Wire up event handling for the controls
    for (id control in controls) {
        if (![control respondsToSelector:@selector(setInputAccessoryView:)])
            continue;

        [toolbar removeTargetsForControl:control];

        [control performSelector:@selector(setInputAccessoryView:) withObject:toolbar];
        if ([control respondsToSelector:@selector(addTarget:action:forControlEvents:)])
            [control addTarget:toolbar action:@selector(accessoryEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];

        if ([control conformsToProtocol:@protocol(UITextInputTraits)]) {
            id<UITextInputTraits> text = control;
            if (text.returnKeyType == UIReturnKeyNext)
                [control addTarget:toolbar action:@selector(accessoryEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:toolbar selector:@selector(accessoryEditingDidBegin:) name:UITextViewTextDidBeginEditingNotification object:nil];

    return toolbar;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    for (id control in self.controls)
        [self removeTargetsForControl:control];

    [_controls release];
    [super dealloc];
}

#pragma mark - Private

- (void)accessoryEditingDidBegin:(id)sender {
    NSLog(@"AccessoryEditingDidBegin");
    id sendingControl = sender;
    if ([sender isKindOfClass:[NSNotification class]])
        sendingControl = ((NSNotification *)sender).object;

    NSInteger indexOfSender = [self.controls indexOfObject:sendingControl];
    BOOL previousControlIsEnabled = YES;
    BOOL nextControlIsEnabled = YES;
    if (indexOfSender > 0) {
        id previousControl = [self.controls objectAtIndex:(NSUInteger) (indexOfSender - 1)];
        if ([previousControl respondsToSelector:@selector(isEnabled)]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                    [[previousControl class] instanceMethodSignatureForSelector:@selector(isEnabled)]];
            [invocation setSelector:@selector(isEnabled)];
            [invocation setTarget:previousControl];
            [invocation invoke];
            [invocation getReturnValue:&previousControlIsEnabled];
        }
    }
    if (indexOfSender < self.controls.count - 1) {
        id nextControl = [self.controls objectAtIndex:(NSUInteger) (indexOfSender + 1)];
        if ([nextControl respondsToSelector:@selector(isEnabled)]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                    [[nextControl class] instanceMethodSignatureForSelector:@selector(isEnabled)]];
            [invocation setSelector:@selector(isEnabled)];
            [invocation setTarget:nextControl];
            [invocation invoke];
            [invocation getReturnValue:&nextControlIsEnabled];
        }
    }

    UISegmentedControl *segmented = (UISegmentedControl *) [self buttonWithTag:kNextPreviousTag].customView;
    if (indexOfSender == 0) {
        [segmented setEnabled:NO forSegmentAtIndex:0];
        [segmented setEnabled:nextControlIsEnabled forSegmentAtIndex:1];
    } else if (indexOfSender == self.controls.count - 1) {
        [segmented setEnabled:previousControlIsEnabled forSegmentAtIndex:0];
        [segmented setEnabled:NO forSegmentAtIndex:1];
    } else {
        [segmented setEnabled:previousControlIsEnabled forSegmentAtIndex:0];
        [segmented setEnabled:nextControlIsEnabled forSegmentAtIndex:1];
    }
}

- (void)accessoryEditingDidEndOnExit:(id)sender {
    [self nextControl];
}

- (void)accessoryNextPreviousTap:(UISegmentedControl *)sender {
    if ([sender selectedSegmentIndex] == 0)
        [self previousControl];
    else if ([sender selectedSegmentIndex] == 1)
        [self nextControl];
}

- (NSInteger)indexOfFirstResponder {
    NSInteger selectedIndex = -1;
    for (NSUInteger i = 0; i < self.controls.count; i++) {
        if ([[self.controls objectAtIndex:i] performSelector:@selector(isFirstResponder)]) {
            selectedIndex = i;
            break;
        }
    }
    return selectedIndex;
}

- (void)previousControl {
    NSInteger selectedIndex = [self indexOfFirstResponder];
    if (selectedIndex > 0) {
        id previousControl = [self.controls objectAtIndex:(NSUInteger) (selectedIndex - 1)];
        [self makeControlFirstResponder:previousControl];
    }
}

- (void)nextControl {
    NSInteger selectedIndex = [self indexOfFirstResponder];
    if (selectedIndex <= self.controls.count - 2) {
        id nextControl = [self.controls objectAtIndex:(NSUInteger) (selectedIndex + 1)];
        [self makeControlFirstResponder:nextControl];
    }
}

- (void)makeControlFirstResponder:(UIResponder *)control {
    if (control.canBecomeFirstResponder)
        [control becomeFirstResponder];
    else
        [self accessoryDoneTap:nil];
}

- (void)accessoryDoneTap:(UIBarButtonItem *)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (UIBarButtonItem *)buttonWithTag:(NSInteger)tag {
    id control = nil;
    for (UIBarButtonItem *item in self.items) {
        if ([item respondsToSelector:@selector(tag)] && item.tag == tag) {
            control = item;
            break;
        }
    }
    return control;
}

- (void)removeTargetsForControl:(id)control {
    if (![control respondsToSelector:@selector(setInputAccessoryView:)]) return;

    UIToolbar *existing = [control performSelector:@selector(inputAccessoryView)];
    if (existing != nil) {
        if ([control respondsToSelector:@selector(removeTarget:action:forControlEvents:)]) {
            [control removeTarget:existing action:@selector(accessoryEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
            [control removeTarget:existing action:@selector(accessoryEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
    }
}


@end
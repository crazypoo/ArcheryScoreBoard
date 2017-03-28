//
//  InterfaceController.m
//  TargetInfo Extension
//
//  Created by 邓杰豪 on 2017/3/28.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *stepLabel;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error
{
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新，
        [self.stepLabel setText:[message objectForKey:@"STEP"]];
        NSLog(@"%@",[message objectForKey:@"STEP"]);
    });
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"李四1111",@"STEP", nil];

    replyHandler(dic);
}

@end



//
//  ViewController.m
//  Pthread分享
//
//  Created by 魏琦 on 16/6/24.
//  Copyright © 2016年 com.drcacom.com. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
@interface ViewController ()

@end

@implementation ViewController

void * run (void* param) {
    
    for (NSInteger i = 0; i < 5000 ; i ++) {
        NSLog(@"------buttonClick-----%zd ---%@",i,[NSThread currentThread]);
        
    }
    return NULL;
}

- (IBAction)buttonClick:(id)sender {
    /**
     *  主线程执行复杂操作,会卡死主线程
     *
     *  @return <#return value description#>
     */
//    for (NSInteger i = 0; i < 500000 ; i ++) {
//        NSLog(@"------buttonClick-----%zd ---%@",i,[NSThread currentThread]);
//        
//    }
    pthread_t thread;
    pthread_create(&thread, NULL, run, NULL);
    pthread_t thread2;
    pthread_create(&thread2, NULL, run, NULL);
    
    
    //线程的执行是由cpu来调度的,执行的顺序是不可控制的.
    /**
     *  buttonClick-----5242 ---<NSThread: 0x7fc701c08c60>{number = 3, name = (null)}
     2016-06-24 13:11:19.716 Pthread分享[5431:142972] ------buttonClick-----5228 ---<NSThread: 0x7fc701f885c0>{number = 2, name = (null)}
     2016-06-24 13:11:19.723 Pthread分享[5431:142972] ------buttonClick-----5229 ---<NSThread: 0x7fc701f885c0>{number = 2, name = (null)}
     2016-06-24 13:11:19.723 Pthread分享[5431:142973] ------buttonClick-----5243 ---<NSThread: 0x7fc701c08c60>{number = 3, name = (null)}
     */
    
}

@end

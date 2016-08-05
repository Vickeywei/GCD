//
//  main.m
//  子进程和父进程
//
//  Created by 魏琦 on 16/6/20.
//  Copyright © 2016年 com.drcacom.com. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        pid_t fpid; //fpid表示fork函数返回的值
        int count=0;
        fpid=fork();
        if (fpid < 0)
            printf("error in fork!");
        else if (fpid == 0) {
            printf("i am the child process, my process id is %d\n",getpid());
            
            printf("我是爹的儿子\n");//对某些人来说中文看着更直白。
            count++;
        }
        else {
            printf("i am the parent process, my process id is %d\n",getpid());
            printf("我是孩子他爹\n");
            count++;
        }
        printf("统计结果是: %d\n",count);
    }
    return 0;
}

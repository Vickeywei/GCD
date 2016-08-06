GCD 多线程编程


1.线程和进程

1.1 线程:线程是进程的基本单元,进程中所有要执行的任务,都在线程和进程中执行.


1.2 进程:就是一个运行的程序.

2.多线程实现的多种方案

2.1 Pthread 基于c语言的多线程实现方法,而且该种方案跨平台,可移植性非常高,适用于windows/linux/unix等多种操作系统

2.2 NSThread 是一套面向对象的多线程实现方案,属于oc语言范畴,使用简单方便.但线程的生命周期需要程序员手动管理,所以一般用的较少.

2.3 GCD(今天的主角),它是一套基于c语言实现的多线程方案,但是他的使用难度非常简单,结合了oc中blocks的特性,使得使用起来非常方便,而且他的生命周期系统已经帮我们管理了,我们只需要将所要执行的代码段放入到相应的队列当中.

2.4 NSOperation 基于GCD,他是在GCD的基础上封装了GCD.而且提供了了一些简单易用的方法.

3.串行队列和并发队列

3.1 系统为我们提供了5个队列,一个全局队列,四个并发队列(全局并发队列),全局队列属于串行队列,全局并发队列属于并发队列.

3.2 串行队列的特点:先进先出,等待任务结束后,再继续执行

3.3 并发队列的特点:不会等待任务的结束.并发的执行处理操作.

3.4 我们还可以通过dispatch_queue_creat来创建属于自己的队列,我们创建的队列都存在着一个目标队列.

4.同步和异步

4.1 在当前线程的串行队列,向当前线程的串行队列中提交同步任务,不会开辟新的线程,会在当前线程执行.

4.2.如果给主队列提交异步任务,不会开辟新的线程去执行,会在主线程按照FIFO的规则执行.

4.3所以从上所述,可以看出串行队列的规律就是先进先出,同步任务不会开辟新的线程,异步任务会开启新的线程.

4.4主调度队列是全局可用的串行队列，在程序的主线程上执行任务.

4.5  在当前线程的全局队列中提交同步任务,不会开辟新的线程去执行.会在当前线程执行,并且有卡顿现象.

4.6 在当前线程的串行队列中提交异步任务,会开辟新的线程执行,并且按照先进先出的顺序序列化执行.

4.7 在当前线程的全局队列中提交异步任务,会开辟新的线程去执行,而且是并发执行,执行的顺序由系统决定.不会影响主线程

5.主线程锁死的原因

5.1 直接在主队列中提交同步任务.

5.2 在主队列的异步任务执行任务中提交同步任务到主队列

6.目标队列

6.1 只有全局并发队列和主队列才能执行blcok.所有其他的队列都必须以这两种队列中的一种为目标队列.

6.2 我们自身创建的队列,在队列上提交的任务并不会在该队列执行,而是会将该blcok重新放入到目标队列去执行.

6.3 利用dispatch_set_target_queue不仅可以修改队列的优先级,还可以修改队列的目标队列.(开发中不常用)

7.dispatch_after函数

7.1该函数的作用是在指定时间追加处理到dispatch_queue中.并不是我们常常理解的在几秒钟后执行处理.

7.2在参数中的dispatch_time函数和dispatch_walltime:dispatch_time函数常用于计算相对时间.dipatch_walltime常用于计算绝对时间.

7.3dispatch_time函数指定的时间,并不完全是绝对的,因为当前线程执行的任务过多时,会有延迟性.而且主线程的处理操作本身就有一定的延迟.所以这个指定时间是不确定的.

7.4所以这个函数的使用要分情况而视,如果有关UI操作,不管你是在什么线程,只要提交到主队列.如果不包含UI操作,如延迟缓存就可以开辟新的线程去执行.

8.dispatch_once函数:主要用于单例(不在过多讲述)

9.dispatch_sync和dispatch_async函数

9.1dispatch_sync同步的将要执行的任务提交到queue中,不会开辟新的线程去执行.

9.2dispatch_async异步的将要执行的任务提交到queue中,会开辟新的线程执行

10.dispatch_apply

10.1这个函数是dispatch_sync函数和dispatch_group函数的组合.

10.2首先我们看到它是dispatch_sync函数,所以绝对不能将其提交到主队列当中

10.3作用:将指定次数的block追加到queue中去执行,并且其他操作必须等待,全部任务执行完成后再执行其他操作.(防止数据竞争)

11.dispatch_barrier_async

11.1作用:实现高效率的数据库访问和文件访问(避免数据竞争)

11.2如果该函数出现在写入文件和读取文件的任务的中间,就会等待前面的任务全部执行完毕,才开始执行,等该函数执行完毕,后面的读取操作又开始执行.使得中间写入的数据有效.

12.dispatch_group函数

12.1.作用:在Dispatch_Queue中追加多个处理全部执行结束后,想执行一些结束处理.使用dispatch_group可以完成该功能.

12.2.dispatch_group_notify函数作用监听dispatch_group中追加的处理是否全部执行完毕,如果执行完毕,就将结束的处理提交到这个dispatch_queue中.

12.3.dispatch_group_wait 函数等待全部任务结束后执行

12.4.dispatch_group_notify函数可以将任务提交到不同的队列上.

13.dispatch_supend和dispatch_resume

13.1当追加的处理较多时,在追加处理的过程中,想挂起某个队列,不让其任务继续执行,可以使用dispatch_supend.

13.2如果想恢复刚才暂停的队列可以使用dispatch_resume函数

14.dispatch_source

14.1这个函数是基于XNU内核的,处理的事件有:变量增加,变量OR,MACH端口发送,MACH端口接收,检测与进程有关的事件,读取文件映像,接收信号,定时器,文件系统变更,可写入文件映像,检测内存压力

14.2开发iOS应用我们能触及到的最常见的就是timer事件,也就是定时器事件.所以其他事件,有兴趣的朋友可以自行查看XNU内核编程和开发等相关资料.



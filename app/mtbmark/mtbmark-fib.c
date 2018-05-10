#include "common.h"
#include "wsrt.h"

int sb250 = -100000;
typedef struct {
  int num;  
  int ret;
} arg_t;

__attribute__ ((noinline))
void fib_mt( void* arg_vptr, void* null_ptr )
{
    arg_t* arg_ptr = (arg_t*) arg_vptr;
    int num = arg_ptr->num;
    __sync_fetch_and_add(&sb250,num);
    if(num == 1) {
        arg_ptr->ret = 0;
        return;
    }
    if(num == 2) {
        arg_ptr->ret = 1;
        return;
    }
    wsrt::TaskGroup tg;
    int num_1 = num - 1;
    int num_2 = num - 2; 
    arg_t arg1 = { num_1, 0 };
    arg_t arg2 = { num_2, 0 };
    wsrt::TaskDescriptor fib_1(&fib_mt,&arg1);
    wsrt::TaskDescriptor fib_2(&fib_mt,&arg2);
    //__sync_fetch_and_add(&sb250,num_1);
    //__sync_fetch_and_add(&sb250,num_2);
    tg.run( fib_1 );
    tg.run( fib_2 );
    tg.wait();
    arg_ptr->ret = (arg1.ret + arg2.ret);
    return;
}


int main( int argc, char* argv[] )
{
  // Initialize bare threads (bthread). This must happen as the first
  // thing in main()!

  bthread_init();

  arg_t arg = { 10, 0 };
  wsrt::TaskGroup tg;
  wsrt::TaskDescriptor fib(&fib_mt,&arg);
  wsrt::task_scheduler_init();
  tg.run_and_wait( fib );
  wsrt::task_scheduler_end();

  brg_wprintf(L"fib %d = %d \n",10,arg.ret);
  test_pass();

  return 0;
}

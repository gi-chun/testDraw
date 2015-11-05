/*
 *  antidebugger.h
 *  SHINHANBANK
 *
 *  Created by SongI 한 on 10. 11. 24..
 *  Copyright 2010 finger. All rights reserved.
 *
 */


#import <dlfcn.h>
#import <sys/types.h>

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif  // !defined(PT_DENY_ATTACH)


void disable_gdb();
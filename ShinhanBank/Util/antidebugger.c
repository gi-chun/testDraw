/*
 *  antidebugger.c
 *  SHINHANBANK
 *
 *  Created by SongI 한 on 10. 11. 24..
 *  Copyright 2010 finger. All rights reserved.
 *
 */

#include "antidebugger.h"


void disable_gdb() {
	void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
	ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
	ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
	dlclose(handle);
}
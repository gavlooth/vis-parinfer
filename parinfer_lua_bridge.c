#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

 //We declare a function pointer for the function to import (int myfunction(int) )
 typedef const char * (*external_function)(const char *);

static int run_parinfer (lua_State *L) {

  //We open the shared object
  void* dlh = dlopen("/usr/local/lib/libcparinfer.so", RTLD_LAZY );
  if (dlh == NULL) {
    fprintf(stderr, "%s", dlerror());
    exit(1);
  }

  //We resolve the function symbol to use
  external_function prf  = dlsym(dlh, "run_parinfer");

  //check and fetch the arguments
    const char *json_obj= luaL_checkstring (L, 1);

    //push the results
    lua_pushstring (L, prf (json_obj));

    //return number of results
    return 1;
}


static const struct luaL_Reg parinfer_lua_bridge [] = {
      {"runParinfer", run_parinfer},
      {NULL, NULL}  /* sentinel */
    };


int luaopen_parinfer_lua_bridge (lua_State *L){
    luaL_newlib(L, parinfer_lua_bridge);
    return 1;
}



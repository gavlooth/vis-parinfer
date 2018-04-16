#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

 //We declare a function pointer for the function to import (int myfunction(int) )

extern const char *  run_parinfer (const char *  input);

static int run__parinfer (lua_State *L) {
  //check and fetch the arguments
    const char *json_obj= luaL_checkstring (L, 1);

    //push the results
    lua_pushstring (L, run_parinfer (json_obj));

    //return number of results
    return 1;
}


static const struct luaL_Reg libparinferlua[] = {
      {"runParinfer", run__parinfer},
      {NULL, NULL}  /* sentinel */
    };


int luaopen_libparinferlua (lua_State *L){
    luaL_newlib(L, libparinferlua);
    return 1;
}



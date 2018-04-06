#import <substrate.h>

void (*old__ZN8CPPClass11CPPFunctionEPKc) (void *, const char *);

void new__ZN8CPPClass11CPPFunctionEPKc(void *hiddenThis, const char *arg0)
{
    if (strcmp(arg0, "This is a short C function!") == 0) old__ZN8CPPClass11CPPFunctionEPKc(hiddenThis, "This is a hijacked short C function form new__ZN8CPPClass11CPPFunctionEPKc!");
    else old__ZN8CPPClass11CPPFunctionEPKc(hiddenThis, "This is a hijacked C++ function!");
}

void (*old_CFunction) (const char *);

void new_CFunction(const char *arg0)
{
    old_CFunction("This is a hijacked C function!"); // Call the original CFunction
}

void (*old_ShortCFunction) (const char *);

void new_ShortCFunction(const char *arg0)
{
    old_ShortCFunction("This is a hijacked short C function from new_ShortCFunction!"); // Call the original ShortCFunction
}

%ctor
{
    @autoreleasepool
    {
        MSImageRef image = MSGetImageByName("/Application/iOSRETargetApp.app/iOSRETargetApp");
        void *__ZN8CPPClass11CPPFunctionEPKc = MSFindSymbol(image, "__ZN8CPPClass11CPPFunctionEPKc");
        if (__ZN8CPPClass11CPPFunctionEPKc) NSLog(@"iOSRE: Found CPPFunction!");
        MSHookFunction((void *)__ZN8CPPClass11CPPFunctionEPKc, (void *)&new__ZN8CPPClass11CPPFunctionEPKc, (void **)old__ZN8CPPClass11CPPFunctionEPKc);

        void *_CFunction = MSFindSymbol(image, "_CFunction");
        if (_CFunction) NSLog(@"iOSRE: Found CFunction!");
        MSHookFunction((void *)_CFunction, (void *)&new_CFunction, (void **)new_ShortCFunction);

        void *_ShortCFunction = MSFindSymbol(image, "_ShortCFunction");
        if (_ShortCFunction) NSLog(@"iOSRE: Found ShortCFunction!");
        MSHookFunction((void *)_ShortCFunction, (void *)&new_ShortCFunction, (void **)&old_ShortCFunction); // This MSHookFunction will fail because ShortCFunction is too short to be hooked
    }
}




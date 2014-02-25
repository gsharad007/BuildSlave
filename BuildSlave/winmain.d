module winmain;

import core.runtime;
import core.sys.windows.windows;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;


extern (Windows)
int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
    int result;

    void exceptionHandler(Throwable e)
    {
        throw e;
    }

    try
    {
        Runtime.initialize();

        result = myWinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow);

        Runtime.terminate();
    }
    catch (Throwable o)		// catch any uncaught exceptions
    {
        MessageBoxA(null, cast(char *)o.toString(), "Error", MB_OK | MB_ICONEXCLAMATION);
        result = 0;		// failed
    }

    return result;
}

int myWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
    auto display = new Display;
    auto shell = new Shell;
    shell.open();

    while (!shell.isDisposed)
        if (!display.readAndDispatch())
            display.sleep();

    display.dispose();

    return 0;
}

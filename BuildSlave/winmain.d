module winmain;

import core.runtime;
import core.sys.windows.windows;
import std.file;
import std.path;
import std.conv;
import std.exception;
import BuildSlave.Config;
import BuildSlave.UI.UI;


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

        scope Config cfg = new Config(to!string(lpCmdLine));

        string workingDir = absolutePath(Config.GetVariableOrDefaultValue("WorkingDir", "."));
        enforce(exists(workingDir), "Working Directory is non-existant");
        chdir(workingDir);

        bool showUI = !(Config.Contains("build") || Config.Contains("sync") || Config.Contains("preprocess"));

        if(showUI)
            result = UIShell.Show();

        Runtime.terminate();
    }
    catch (Throwable o)		// catch any uncaught exceptions
    {
        MessageBoxA(null, cast(char *)o.toString(), "Error", MB_OK | MB_ICONEXCLAMATION);
        result = 0;		// failed
    }

    return result;
}


//int main()
//{
//    int result = 0;
//    
//    try
//    {
//        dwt.widgets.Display.Display display = new dwt.widgets.Display.Display();
//        
//        //@  Other application initialization code here.
//        
//        UIShell eshell = new UIShell(display);
//        eshell.shell.open();
//        while(!eshell.shell.isDisposed())
//        {
//            if(!display.readAndDispatch())
//                display.sleep();
//        }
//        display.dispose();
//    }
//    catch(Object o)
//    {
//        dwt.widgets.MessageBox.MessageBox.showError(o.toString(), "Fatal Error");
//        
//        result = 1;
//    }
//    
//    return result;
//}

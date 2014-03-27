/*
Generated by Entice Designer
Entice Designer written by Christopher E. Miller
www.dprogramming.com/entice.php
*/
module BuildSlave.UI.Status;

import std.file;
import std.path;
import std.algorithm;
import std.array;
import std.string;
import std.conv;
import std.process;
import std.concurrency;
import std.datetime;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.TabFolder;
import org.eclipse.swt.widgets.TabItem;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.List;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.widgets.MessageBox;
//import org.eclipse.swt.widgets.Listener;
//import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.events.SelectionListener;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.layout.RowLayout;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.custom.SashForm;
import BuildSlave.UI.Base;
import BuildSlave.Config;


// This is really void* in SWT but I think 
alias void* HANDLE;

class UIStatusItem : UIBase
{
    bool initialized = false;
    bool terminateButton = false;

    string title;
    org.eclipse.swt.widgets.Text.Text txtStatus;
    org.eclipse.swt.widgets.Button.Button btnTerminate;
    org.eclipse.swt.widgets.ProgressBar.ProgressBar progressBar;
    Tid threadId;

    this(Composite parent)
    {
        super(parent);
    }

    override public void preInitialize()
    {
    }

    override public void initialize()
    {
        if(!initialized)
            createUI(this.UIBase.Composite);
        checkDependencies();
    }

    override public void postInitialize()
    {
    }

    override public bool checkDependencies()
    {
        return true;
    }

    private void createUI(Composite canvas)
    {
        GridLayout gl = new GridLayout();
        canvas.setLayout(gl);
        //gl.marginWidth = 0;
        //gl.marginHeight = 0;
        gl.horizontalSpacing = 0;
        gl.verticalSpacing = 0;
        //gl.marginWidth = 0;
        //gl.marginHeight = 0;
        gl.numColumns = 2;

        //~SWT org.eclipse.swt.widgets.Text.Text=txtStatus
        txtStatus = new org.eclipse.swt.widgets.Text.Text(canvas,SWT.BORDER|SWT.MULTI|SWT.H_SCROLL|SWT.V_SCROLL|SWT.READ_ONLY);
        GridData gridDataStatus = new GridData(GridData.FILL_BOTH);
        gridDataStatus.horizontalSpan = 2;
        txtStatus.setLayoutData(gridDataStatus);
        //txtStatus.setBounds(2, 2, 466, 92);

        Font initialFont = txtStatus.getFont();
        FontData[] fontData = initialFont.getFontData();
        for (int i = 0; i < fontData.length; i++) {
            fontData[i].setName("Consolas");
        }
        Font newFont = new Font(display, fontData);
        txtStatus.setFont(newFont);

        if(terminateButton)
        {
            //~SWT org.eclipse.swt.widgets.ProgressBar.ProgressBar=progressBar
            progressBar = new org.eclipse.swt.widgets.ProgressBar.ProgressBar(canvas, SWT.SMOOTH|SWT.HORIZONTAL|SWT.INDETERMINATE);
            GridData gridDataProgressBar = new GridData(GridData.FILL_HORIZONTAL);
            progressBar.setLayoutData(gridDataProgressBar);
            //progressBar.setBounds(12, 410, 500, 23);

            //~SWT org.eclipse.swt.widgets.Button.Button=btnTerminate push
            btnTerminate = new org.eclipse.swt.widgets.Button.Button(canvas,SWT.PUSH);
            btnTerminate.setText("X");
            //btnTerminate.setLayoutData(gridDataButton);
            //btnTerminate.setBounds(352, 196, 160, 88);
            //btnTerminate.addSelectionListener(new BuildListener(this) );
        }
    }

    public void addTerminationListner(SelectionListener listener)
    {
        checkWidget ();
        if (listener is null) error (SWT.ERROR_NULL_ARGUMENT);
        btnTerminate.addSelectionListener(listener);
    }

    public void appendLine(string text)
    {
        txtStatus.append((cast(TimeOfDay)Clock.currTime()).toString() ~ ": " ~ text ~ "\n");
    }
}

class UIStatus : UIBase
{
    bool initialized = false;

    // Do not modify or move this block of variables.
    //~Entice Designer variables begin here.
    org.eclipse.swt.widgets.TabFolder.TabFolder tabStatuses;
    //~Entice Designer variables end here.

    //int[] statusIndices;
    int nextIndex = 1;
    UIStatusItem[int] statusItems;

    static UIStatus instance;
    static UIStatus get()
    {
        assert(instance, "UIStatus hasn't been created yet.");
        return instance;
    }

    this(Composite parent)
    {
        super(parent);
        instance = this;
    }

    override public void preInitialize()
    {
    }

    override public void initialize()
    {
        if(!initialized)
            createUI(this.UIBase.Composite);
        checkDependencies();
    }

    override public void postInitialize()
    {
    }

    override public bool checkDependencies()
    {
        return true;
    }

    private void createUI(Composite canvas)
    {
        canvas.setLayout(new FillLayout());

        //~SWT org.eclipse.swt.widgets.TabFolder.TabFolder=tabStatuses
        tabStatuses = new org.eclipse.swt.widgets.TabFolder.TabFolder(canvas,SWT.BOTTOM);

        canvas.layout();
        canvas.pack();
    }

    public int addStatus(string title, string command = "", const int waitFor = 0)
    {
        int idx = nextIndex;
        nextIndex++;

        UIStatusItem preTask = statusItems.get(waitFor, null);

        auto statusItem = new UIStatusItem(tabStatuses);
        statusItems[idx] = statusItem;
        statusItem.preInitialize();
        auto tabItem = new TabItem(tabStatuses, SWT.NONE);
        tabItem.setText(title);
        tabItem.setControl(statusItem);
        statusItem.terminateButton = command.length != 0;
        statusItem.initialize();

        if(command.length != 0)
        {
            statusItem.appendLine("Running Command: " ~ command);
            int statusHandle = cast(int)&statusItem;
            if(preTask is null)
                statusItem.threadId = spawn(&addProcess, statusHandle, title, command, Tid(), "");
            else
                statusItem.threadId = spawn(&addProcess, statusHandle, title, command, preTask.threadId, preTask.title);
            std.concurrency.register(title, statusItem.threadId);
        }
        //send(id, statusItem);


        //auto msg = receiveOnly!(int, UIStatusItem)();
        //statusItems[idx] = msg[1];
        //return msg[0];
        statusItem.postInitialize();
        tabStatuses.setSelection(tabItem);

        this.layout();
        //this.pack();

        return idx;
    }

    //static private void addStatusImpl(HANDLE statusHandle, string title, string command = "", int waitFor = 0)
    //{
    //    //auto msg = receiveOnly!(UIStatusItem)();
    //    //UIStatusItem item = msg[0];
    //
    //    //send(ownerTid, idx, item);
    //
    //    if(command.length != 0)
    //    {   
    //        Tid id;
    //        if(b is null)
    //            addProcess(statusHandle, command, null, null);
    //        else
    //            addProcess(statusHandle, command, b.processPipe.pid(), b.title);
    //    }
    //}

    public void appendLine(const int id, string text)
    {
        UIStatusItem statusItem = statusItems.get(id, null);
        assert(statusItem, "Trying to write text '" ~ text ~ "' to an invalid Status Item." );

        statusItem.appendLine(text);
    }
}

//static private void appendText(HANDLE handle, string text)
//{
//    import org.eclipse.swt.widgets.Display;
//    import org.eclipse.swt.widgets.Control;
//    import org.eclipse.swt.internal.win32.OS;
//
//    int getCodePage () {
//        if (OS.IsUnicode) return OS.CP_ACP;
//        CHARSETINFO csi;
//        auto cs = OS.GetTextCharset(handle);
//        OS.TranslateCharsetInfo( cast(DWORD*)cs, &csi, OS.TCI_SRCCHARSET);
//        return csi.ciACP;
//    }
//
//    //checkWidget ();
//    // SWT extension: allow null string
//    //if (string is null) error (SWT.ERROR_NULL_ARGUMENT);
//    text = Display.withCrLf(text);
//    int length = OS.GetWindowTextLength (handle);
//    //if (hooks (SWT.Verify) || filters (SWT.Verify)) {
//    //    text = verifyText (text, length, length, null);
//    //    if (text is null) return;
//    //}
//    OS.SendMessage (handle, OS.EM_SETSEL, length, length);
//    LPCTSTR buffer = StrToTCHARz (getCodePage(), text);
//    /*
//    * Feature in Windows.  When an edit control with ES_MULTILINE
//    * style that does not have the WS_VSCROLL style is full (i.e.
//    * there is no space at the end to draw any more characters),
//    * EM_REPLACESEL sends a WM_CHAR with a backspace character
//    * to remove any further text that is added.  This is an
//    * implementation detail of the edit control that is unexpected
//    * and can cause endless recursion when EM_REPLACESEL is sent
//    * from a WM_CHAR handler.  The fix is to ignore calling the
//    * handler from WM_CHAR.
//    */
//    //ignoreCharacter = true;
//    OS.SendMessage (handle, OS.EM_REPLACESEL, 0, cast(void*)buffer);
//    //ignoreCharacter = false;
//    OS.SendMessage (handle, OS.EM_SCROLLCARET, 0, 0);
//}

static private void addProcess(int statusHandle, string title, string command, Tid waitFor, string waitForTitle)
{
    //if(waitFor == Tid.init)
    //{
    //    auto blocker = tryWait(waitFor);
    //    if(!blocker.terminated)
    //    {
    //        appendText(statusHandle, "Waiting for " ~ waitForTitle ~ "...\n");
    //        wait(waitFor);
    //    }
    //    if(blocker.status != 0)
    //    {
    //        appendText(statusHandle, "ERROR: Process " ~ waitForTitle ~ " did not finish properly. Terminating Self.\n");
    //        return;
    //    }
    //}

    string finalCommand = escapeShellCommand(command);
    auto pipes = pipeShell(finalCommand, Redirect.all, null, std.process.Config.suppressConsole);
    scope(exit) wait(pipes.pid);

    UIStatusItem* status = cast(UIStatusItem*)statusHandle;

    foreach(str; pipes.stdout.byLine)
    {
        string s = to!string(str);
        status.appendLine(s);
    }

    foreach(str; pipes.stderr.byLine)
    {
        string s = to!string(str);
        status.appendLine(s);
    }

}
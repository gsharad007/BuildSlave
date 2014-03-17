/*
    Generated by Entice Designer
    Entice Designer written by Christopher E. Miller
    www.dprogramming.com/entice.php
*/
module BuildSlave.UI.Build;

import std.file;
import std.path;
import std.algorithm;
import std.format;
import std.range;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.TabFolder;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.widgets.ProgressBar;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.events.SelectionListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import BuildSlave.UI.Base;
import BuildSlave.Config;


class UIBuild : UIBase
{
    bool initialized = false;
    // Do not modify or move this block of variables.
    //~Entice Designer variables begin here.
    org.eclipse.swt.widgets.Button.Button[] chkBuilds;
    org.eclipse.swt.widgets.Button.Button[] chkProjects;
    org.eclipse.swt.widgets.Button.Button[] chkConfigurations;
    org.eclipse.swt.widgets.Button.Button[] chkPlatforms;
    org.eclipse.swt.widgets.Button.Button button4;
    org.eclipse.swt.widgets.Button.Button button5;
    org.eclipse.swt.widgets.Button.Button button6;
    org.eclipse.swt.widgets.Button.Button btnBuild;
    org.eclipse.swt.widgets.Button.Button button9;
    org.eclipse.swt.widgets.Button.Button button10;
    org.eclipse.swt.widgets.ProgressBar.ProgressBar progressBar1;
    org.eclipse.swt.widgets.Text.Text text1;
    org.eclipse.swt.widgets.Label.Label label1;
    //~Entice Designer variables end here.
    
    
    this(Composite parent)
    {
        super(parent);

        //initializeUIBuild(display);
        
        //@  Other UIBuild initialization code here.
        
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

    private void createUI(Composite container)
    {
        // Do not manually modify this function.
        //~Entice Designer 0.8.5.02 code begins here.
        //~DWT org.eclipse.swt.widgets.Button.Button=button9 check
        button9 = new org.eclipse.swt.widgets.Button.Button(container, SWT.CHECK);
        button9.setText("FastBuild");
        button9.setSelection(true);
        button9.setBounds(36, 204, 75, 23);
        //~DWT org.eclipse.swt.widgets.Button.Button=button10 check
        button10 = new org.eclipse.swt.widgets.Button.Button(container, SWT.CHECK);
        button10.setText("Parallel Builds");
        button10.setBounds(36, 228, 107, 23);
        //~DWT org.eclipse.swt.widgets.ProgressBar.ProgressBar=progressBar1
        progressBar1 = new org.eclipse.swt.widgets.ProgressBar.ProgressBar(container, SWT.NONE);
        progressBar1.setBounds(4, 332, 472, 23);
        //~DWT org.eclipse.swt.widgets.Text.Text=text1
        text1 = new org.eclipse.swt.widgets.Text.Text(container, SWT.BORDER|SWT.SINGLE|SWT.WRAP);
        text1.setBounds(4, 284, 472, 48);
        //~DWT org.eclipse.swt.widgets.Label.Label=label1
        label1 = new org.eclipse.swt.widgets.Label.Label(container, SWT.LEFT);
        label1.setText("Output");
        label1.setBounds(12, 268, 100, 23);
        //~SWT org.eclipse.swt.widgets.Button.Button=btnBuild push
        btnBuild = new org.eclipse.swt.widgets.Button.Button(container,SWT.PUSH);
        btnBuild.setText("Build");
        btnBuild.setBounds(340, 196, 144, 88);
        btnBuild.addSelectionListener(new BuildListener(this) );
        //~Entice Designer 0.8.5.02 code ends here.

        PopulateBuildOptions(container);
    }

    private void PopulateBuildOptions(Composite container)
    {
        //for (size_t i = 0; i < chkConfigurations.length; i++)
        //    delete chkConfigurations[i];
        string[] slnFiles;
        string[] builds;
        string[] projects;
        string[] configs = [ "Release", "Debug", "Profile", "Retail", "Master" ];
        string[] platforms = [ "Win32", "X64", "XBox 360", "PS3", "PS4", "XBox One" ];

        // Get Builds
        {
            // Iterate a directory in depth
            string solutionDir = absolutePath(Config.GetVariableOrDefaultValue("SolutionDir", ""));
            string prettyNameFormat = Config.GetVariableOrDefaultValue("SolutionPrettyName", "");
            auto slnDirEntries = filter!`endsWith(a.name, ".sln")`(dirEntries(solutionDir, SpanMode.shallow));
            //builds.length = walkLength(slnFiles);
            foreach (string name; slnDirEntries)
            {
                slnFiles ~= absolutePath(name);
                string fileName = baseName(name, ".sln");
                string prettyName;
                if(prettyNameFormat.empty || !formattedRead(fileName, prettyNameFormat, &prettyName))
                   prettyName = fileName;
                builds ~= prettyName;
            }
        }

        // Get Projects
        {
            string projectConfig = Config.GetVariable("StartupProjects");
            projects = split(projectConfig, ",");
        }

        //// Get Configs and Platforms
        //{
        //    string[] prjFiles;
        //    foreach(sln; slnFiles)
        //    {
        //        auto f = File(filename);
        //        scope(exit) f.close();
        //        foreach (line; f.byLine())
        //        {
        //            line.indexOf(projects ~ ".vcxproj", 0, CaseSensitive.no);
        //        }
        //    }
        //}

        int column = 0;
        chkBuilds.length = builds.length;
        for (size_t i = 0; i < builds.length; i++)
        {
            //~DWT org.eclipse.swt.widgets.Button.Button=chkConfigurations check
            chkBuilds[i] = new org.eclipse.swt.widgets.Button.Button(container, SWT.CHECK);
            chkBuilds[i].setText(builds[i]);
            chkBuilds[i].setBounds(20 + column * 120, 20 + i*20, 120, 23);
        }
        ++column;
        chkProjects.length = projects.length;
        for (size_t i = 0; i < projects.length; i++)
        {
            //~DWT org.eclipse.swt.widgets.Button.Button=chkProjects check
            chkProjects[i] = new org.eclipse.swt.widgets.Button.Button(container, SWT.CHECK);
            chkProjects[i].setText(projects[i]);
            chkProjects[i].setBounds(20 + column * 120, 20 + i*20, 120, 23);
        }
        ++column;
        chkConfigurations.length = configs.length;
        for (size_t i = 0; i < configs.length; i++)
        {
            //~DWT org.eclipse.swt.widgets.Button.Button=chkConfigurations check
            chkConfigurations[i] = new org.eclipse.swt.widgets.Button.Button(container, SWT.CHECK);
            chkConfigurations[i].setText(configs[i]);
            chkConfigurations[i].setBounds(20 + column * 120, 20 + i*20, 120, 23);
        }
        ++column;
        chkPlatforms.length = platforms.length;
        for (size_t i = 0; i < platforms.length; i++)
        {
            //~DWT org.eclipse.swt.widgets.Button.Button=chkConfigurations check
            chkPlatforms[i] = new org.eclipse.swt.widgets.Button.Button(container, SWT.CHECK);
            chkPlatforms[i].setText(platforms[i]);
            chkPlatforms[i].setBounds(20 + column * 120, 20 + i*20, 120, 23);
        }
        ////~DWT org.eclipse.swt.widgets.Button.Button=button2 check
        //button2 = new org.eclipse.swt.widgets.Button.Button(container, SWT.CHECK);
        //button2.setText("Debug");
        //button2.setBounds(20, 76, 75, 23);
        ////~DWT org.eclipse.swt.widgets.Button.Button=button3 check
        //button3 = new org.eclipse.swt.widgets.Button.Button(container, SWT.CHECK);
        //button3.setText("Win32");
        //button3.setBounds(108, 44, 75, 23);
        ////~DWT org.eclipse.swt.widgets.Button.Button=button4 check
        //button4 = new org.eclipse.swt.widgets.Button.Button(container, SWT.CHECK);
        //button4.setText("X64");
        //button4.setBounds(108, 84, 75, 23);
        ////~DWT org.eclipse.swt.widgets.Button.Button=button5 check
        //button5 = new org.eclipse.swt.widgets.Button.Button(container, SWT.CHECK);
        //button5.setText("Editor");
        //button5.setBounds(212, 84, 75, 23);
        ////~DWT org.eclipse.swt.widgets.Button.Button=button6 check
        //button6 = new org.eclipse.swt.widgets.Button.Button(container, SWT.CHECK);
        //button6.setText("Game");
        //button6.setBounds(244, 52, 75, 23);
    }

    private class FastBuildListener : org.eclipse.swt.events.SelectionListener.SelectionListener
    {
        void widgetSelected(SelectionEvent e)
        {
        }

        void widgetDefaultSelected(SelectionEvent e)
        {
        }
    };

    private class BuildListener : SelectionAdapter
    {
        UIBuild ui;
        this(UIBuild ui)
        {
            this.ui = ui;
        }
        override public void widgetSelected(SelectionEvent e)
        {
            //Stdout("selected").newline;
        }
    }
}


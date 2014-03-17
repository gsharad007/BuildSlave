module BuildSlave.Config;

import std.stdio;
import std.file;
import std.path;
import std.array;
import std.string;
import std.algorithm;
import std.conv;
import std.exception;


class Config
{
    shared static private string[string] variables;
    static private string[]       modifiedVariables;

    private string curDirectory;

    this(string lpCmdLine)
    {
        curDirectory = getcwd();
        LoadConfig(lpCmdLine);
    }

    ~this()
    {
        SaveConfig(curDirectory);
    }

    static public void LoadConfig(string lpCmdLine)
    {
        auto cmdSplit = split(lpCmdLine, " -");
        //auto tpCmd = map!(a => )(cmdSplit);
        string[string] cmdVariables;

        foreach(t; cmdSplit)
        {
            auto pair = split(chompPrefix(t, "-"), "=");
            enforce(pair.length, "Invalid Config Arguments.");
            Config.Insert(pair[0], pair[1]);
        }

        string userConfigFile = absolutePath(Config.GetVariableOrDefaultValue("usercfg", "BuildSlave.user.cfg"));
        if(exists(userConfigFile))
        {
            auto tp = enforce(slurp!(string, string)(userConfigFile, "%s=%s"));
            foreach(k; tp)
            {
                Config.AddOnly(k[0], k[1]);
                modifiedVariables ~= k[0];
            }
        }

        string configFile = absolutePath(Config.GetVariableOrDefaultValue("cfg", "BuildSlave.cfg"));
        if(exists(configFile))
        {
            auto tp = enforce(slurp!(string, string)(configFile, "%s=%s"));
            foreach(k; tp)
                Config.AddOnly(k[0], k[1]);
        }

        Config.variables.rehash; // for faster lookups
    }

    static public void SaveConfig(string curDirectory)
    {
        // TODO: This doesn't work for some reason and crashes internally.
        // I think its to do with the fact that the string is larger than what
        // string.length suggests.
        //sort(modifiedVariables);
        //string userCfg = "";
        //foreach(k; uniq(modifiedVariables))
        //{
        //    string val = GetVariable(k).dup;
        //    //string cfg = k;
        //    //cfg ~= "=";
        //    //cfg ~= val[0 .. val.length];
        //    //cfg ~= "\n";
        //    userCfg ~= format("%s=%s\n", k, val);
        //}
        //string configFile = absolutePath(curDirectory ~ "/" ~ Config.GetVariableOrDefaultValue("usercfg", "BuildSlave.user.cfg"));
        //std.file.write(configFile, userCfg);
    }

    static public string GetVariable(string key)
    {
        key = toLower(key);
        return variables[key];
    }

    static public void SetVariable(string key, string value)
    {
        key = toLower(key);
        variables[key] = value;
        modifiedVariables ~= key;
    }

    static public string GetVariableOrDefaultValue(string key, string defValue)
    {
        key = toLower(key);
        return variables.get(key, defValue);
    }

    static private void AddOnly(string key, string value)
    {
        if(!Config.Contains(key))
            Config.Insert(key, value);
    }

    static private void Insert(string key, string value)
    {
        writeln(key, "=", value);
        key = toLower(key);
        variables[key] = value;
    }

    static public bool Contains(string key)
    {
        key = toLower(key);
        return (key in variables) !is null;
    }
}
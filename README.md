# profh

Helper tools for enriching Dyalog APL's profiling capabilities (i.e. `⎕PROFILE` and `]PROFILE`).

## Features
- "Single touch" flame/icicle graph visualization via [speedscope](https://github.com/jlfwong/speedscope)--a third-party, browser-based, interactive tool implemented locally (no network access required). Invoked via a `]speedscope` user command.
- Line-level reporting. While flame graphs typically roll-up to the function level, APL's conciseness and expressiveness typically means relatively more is happening in a single line of code, and it is therefore advantageous to have a finer-grained view of the profile.

---

## Getting Started

Copy the contents of this repository into a directory monitored by Dyalog's user command system, and trigger a refresh of the user command system if needed for any pre-existing Dyalog sessions. See below for OS-specific examples.

### Example Windows Installation

Issue the following commands using the command prompt:
```cmd
curl -L https://github.com/higg/profh/archive/main.zip --create-dirs --output %userprofile%\Documents\MyUCMDs\profh.zip
tar -x -f %userprofile%\Documents\MyUCMDs\profh.zip -m -C %userprofile%\Documents\MyUCMDs && del %userprofile%\Documents\MyUCMDs\profh.zip
```

### Example Mac or Linux Installation

Issue the following commands using the terminal:

```bash
curl -L https://github.com/higg/profh/archive/main.tar.gz --create-dirs --output $HOME/MyUCMDs/profh.tar.gz
tar -x -f $HOME/MyUCMDs/profh.tar.gz -m -C $HOME/MyUCMDs && rm $HOME/MyUCMDs/profh.tar.gz
```

### Custom Installation 

The examples above install the tool set into the default location for user commands for their respective operating systems. Alternatively, they may be installed to a custom location (see Dyalog's [guide](https://docs.dyalog.com/latest/User%20Commands%20User%20Guide.pdf) for more details).

### Verifying Installation

Issuing `]? profh` to the Dyalog interpreter will verify the installation.

If correctly installed, the interpreter will display the user commands associated with this tool set (including "speedscope").

If the interpreter reports "No commands or groups match profh", then the tool set has not been discovered by Dyalog. Note that any previously running interpreter instances may require the `]ureset` user command to be issued in order to recognize the new command group.



## Configuration

The default values of any command switches or modifiers can be locally overridden via a JSON configuration file. The contents of that file are treated as a mapping of switch or modifier names to default values of appropriate type. To include a command switch by default, include an entry for the switch, and set the value to `1` (NB: `1`, not `true`).

The file should be called `ConfigLocal.json`, and should placed in dirrectory named `profh-cfg` which is peer to the project installation directory (e.g. `%userprofile%\Documents\MyUCMDs\profh-cfg` or `$HOME/MyUCMDs/profh-cfg`)

Example file contents can be found below:

```json
{
	"browser": "chrome",
	"keepTemp": 1
}
```

## Caveats
- The initial invocation of a user command in this package triggers a code import into the `⎕SE.PROFH` namespace, potentially causing a conflict if that namespace is used by the application being profiled.
- Utilities in this toolkit may create and/or delete files and directories in a system temporary directory suitable for user files (e.g. `c:/users/<username>/AppData/Local/Temp/PROFH` on Windows or `/tmp/PROFH` on other operating systems).

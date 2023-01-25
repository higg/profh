# profh
(under construction) //!

Helper tools for enriching Dyalog APL's profiling capabilities (i.e. `⎕PROFILE` and `]PROFILE`).

## Features
- "Single touch" flame/icicle graph visualization via [speedscope](https://github.com/jlfwong/speedscope)--a third-party, browser-based, interactive tool implemented locally (no network access required). Invoked via a `]speedscope` user command.
- Line-level reporting. While flame graphs typically roll-up to the function level, APL's conciseness and expressiveness typically means relatively more is happening in a single line of code, and it is therefore advantageous to have a finer-grained view of the profile.

---

## Getting Started

Copy the contents of this repository into a directory monitored by Dyalog's user command system, and trigger a refresh of the user command system if needed for any pre-existing Dyalog sessions. See below for OS-specific examples.

### Example Windows Installation

Issue the following commands using the command prompt:
```bash
curl -L https://github.com/higg/profh/archive/main.zip --create-dirs --output %userprofile%\Documents\myUCMDs\profh.zip
tar -x -f %userprofile%\Documents\myUCMDs\profh.zip -m -C %userprofile%\Documents\myUCMDs && del %userprofile%\Documents\myUCMDs\profh.zip
```

### Example Mac or Linux Installation

Issue the following commands using the terminal:

```bash
curl -L https://github.com/higg/profh/archive/main.zip --create-dirs --output 
$HOME/myUCMDs/profh.zip
tar -x -f $HOME/myUCMDs/profh.zip -m -C $HOME\Documents\myUCMDs && del $HOME\myUCMDs\profh.zip
```

### Custom Installation 

The examples above install the tool set into the default location for user commands for their respective operating systems. Alternatively, they may be installed to a custom location (see Dyalog's [guide](https://docs.dyalog.com/latest/User%20Commands%20User%20Guide.pdf) for more details).

### Verifying Installation

Issuing `]? profh` to the Dyalog interpreter will verify the installation.

If correctly installed, the interpreter will display the user commands associated with this tool set (including "speedscope").

If the interpreter reports "No commands or groups match profh", then the tool set has not been discovered by Dyalog. Note that any previously running interpreter instances may require the `]ureset` user command to be issued in order to recognize the new command group.



## Configuration

//!
- config.local
- move from src to /cfg?

## Caveats
- The initial invocation of the `]speedscope` user command triggers a code import into the `⎕SE.PROFH` namespace, potentially causing a conflict if that namespace is used by the application being profiled.
- //! Writes and delete temporary files

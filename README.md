# profh
(under construction) //!

Helper tools for Dyalog APL's profiling capabilities (i.e. `⎕PROFILE` and `]PROFILE`).

## Features
- Flame/Icicle visual support through integration with SpeedScope //!
- Line level accounting //!

---

## Getting Started

Copy the contents of this repository into a directory monitored by Dyalog's user command system, and trigger a refresh of the user command system if needed for any pre-existing Dyalog sessions. See below for OS-specific examples.

### Example Windows Installation

Issue the following commands using the command prompt:
<nobr>

`curl -L https://github.com/higg/profh/archive/main.zip --create-dirs --output %userprofile%\Documents\myUCMDs\profh.zip` <br>
`tar -x -f %userprofile%\Documents\myUCMDs\profh.zip -m -C %userprofile%\Documents\myUCMDs && del %userprofile%\Documents\myUCMDs\profh.zip`
</nobr>

### Example Mac or Linux Installation

Issue the following commands using the terminal:
<nobr>

`curl -L https://github.com/higg/profh/archive/main.zip --create-dirs --output 
$HOME/myUCMDs/profh.zip` <br>
`tar -x -f $HOME/myUCMDs/profh.zip -m -C $HOME\Documents\myUCMDs && del $HOME\myUCMDs\profh.zip`
</nobr>

### Custom Installation 

The examples above install the tool set into the default location for user commands for their respective operating systems. Alternatively, they may be installed to a custom location (see Dyalog's [guide](https://docs.dyalog.com/latest/User%20Commands%20User%20Guide.pdf) for more details).

### Verifying Installation

Issuing the following user command to the Dyalog interpreter will verify the installation: 

`   ]? profh`

If correctly installed, the interpreter will display the user commands associated with this tool set (including "SpeedScope").

If the interpreter reports "No commands or groups match profh", then the tool set has not been discovered by Dyalog. Note that any previously running interpreter instances may require the `]ureset` user command to be issued in order to recognize the new 



## Configuration

//!
- config.local
- move from src to /cfg?

## Caveats
- //! Occupies ⎕SE.profh namespace
- //! Writes and delete temporary files
- //! SpeedScope is launches in a third party browser, but is entirely local
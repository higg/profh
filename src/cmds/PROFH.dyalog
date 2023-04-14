:Namespace PROFH
    ⍝
    ⍝ --- User command template ------------------------------------------------
    ⍝

    ⎕IO←1 ⋄ ⎕ML←1

    ∇ r ← List                          ⍝ Lists commands in this group
        r←_cmds
    ∇
    
    Run←{(_findCmd ⊃⍵).Run _prh 2⊃⍵}    ⍝ Runs given user command, bootstraps
    Help←{(_findCmd ⍵).Help ⍺}          ⍝ Displays help at given level
    _findCmd←{_cmds⊃⍨_cmds.Name⍳⊂⍵}     ⍝ Returns command object with given name
    _grp←{⍵↓⍨⊃⌽⍸'.'=⍵}⍕⎕THIS            ⍝ Use namespace name as default Group

    _prh←⊢                              ⍝ Pre-run hook: can be overridden by
                                        ⍝ defining _preRunHook as a monadic
                                        ⍝ taking and returning Run's input
                                        ⍝ (potentially altered).
                                        ⍝
                                        ⍝ Intended use case is side-effects
                                        ⍝ related to system bootstrapping. 

    
    _cmd←{                              ⍝ Builds default ucmd object with given name, group
        r←⎕NS⍬
        nyi←⍵∘{⍺,' not yet implemented'}
        r.(Name Group Parse Desc)←⍵ _grp '' (nyi ⍬)
        r.Run←nyi
        r.Help←{⊃,/HelpText↑⍨⍵+1}       ⍝ Prints from HelpText according to level
        r.HelpText←⊂⊂nyi ⍬              ⍝ List of string lists (outer list by help level)
        r
    }

    _buildCmds←{                        ⍝ Builds all custom commands in this namespace
        f←{⍵/[1]⍨2≤+/∧\'_'=⍵}⎕NL 3      ⍝ Namespace functions starting with __
        f←f/⍨¨⍥↓' '≠f                   ⍝ Split into string vector, removing blanks
        {(⍎⍵)_cmd 2↓⍵}¨f                ⍝ Create default cmd objects, invoke custom builders
    }


    ∇ r ← _init                         ⍝ Initializes namespace (supports redefinition)
        _cmds←_buildCmds ⍬              ⍝ Build command objects

        :If 3=⊃⎕NC '_preRunHook'        ⍝ User custom pre-run hook, if provided
          _prh←_preRunHook{_←⍺⍺ ⍵ ⋄ ⍵}
        :Endif
        r←1                             ⍝ Dummy result (namespace semantics)
    ∇


    ⍝
    ⍝ --- Custom command builders, hooks, and helpers --------------------------
    ⍝
    ⍝ Be aware:
    ⍝
    ⍝   - each builder function must start with '__'
    ⍝
    ⍝   - function name after '__' determines command name (e.g. __foo -> ]foo)
    ⍝
    ⍝   - builder functions are provided a dictionary (namespace), and are
    ⍝     expected to populate the following fields:
    ⍝
    ⍝           - Group     As per normal user command template, defaults to the
    ⍝                       name of this namespace
    ⍝
    ⍝           - Parse     As per normal user command template, defaults to ''
    ⍝
    ⍝           - Desc      As per normal user command template
    ⍝
    ⍝           - Run       Monadic function taking 'input' parameter (2⊃⍵) from
    ⍝                       normal template's top-level Run function
    ⍝
    ⍝           - Help      Monadic function taking 'level' parameter (⍺) from
    ⍝                       normal template's top-level Help function
    ⍝                       //! Describe HelpText, default implementation for Help
    ⍝

    
    __Speedscope←{
        ⍵.Run←speedscope
        ⍵.Desc←'Visualize performance profile data with speedscope'
        ⍵.Parse ←'9999S -browser=chrome firefox edge url -keepTemp -showCmd -zoom∊¯.',⎕D,' '
        ⍵.Parse,←'-topFn= -cpu -msScale∊¯.e',⎕D,' '

        ⍵.HelpText←{
            ⎕IO←0 ⋄ h←3↑⊂⍬

            h[0],←⊂⊂'Processes collected profiling data and renders it using speedscope--a 3rd-party,'
            h[0],←⊂⊂'fully-local, interactive flame graph visualization tool.'
            h[0],←⊂⊂''
            h[0],←⊂⊂'  ]speedscope [<expr> [<expr> ...]] [-browser={chrome|firefox|edge}] [-cpu]'
            h[0],←⊂⊂'       [-keepTemp] [-msScale=<num>] [-topFn=<value>] [-zoom=<num>]'
            h[1],←⊂⊂''
            h[1],←⊂⊂'This command takes any number of APL expressions as arguments. These'
            h[1],←⊂⊂'expressions are executed and profiled in sequence, and the aggregated profile'
            h[1],←⊂⊂'data is passed to speedscope for visualization. If no expressions are provided,'
            h[1],←⊂⊂'speedscope is passed the pre-existing contents of ⎕PROFILE''s data buffers, if'
            h[1],←⊂⊂'any.'
            h[1],←⊂⊂''
            h[1],←⊂⊂'Please note that if any expressions are provided, the previous contents of'
            h[1],←⊂⊂'⎕PROFILE''s buffers are purged.'
            h[1],←⊂⊂''
            h[1],←⊂⊂'Modifiers:'
            h[1],←⊂⊂''
            h[1],←⊂⊂'-browser=<value>   If present, specifies the browser used to host speedscope.'
            h[1],←⊂⊂''
            h[1],←⊂⊂'                   If one of "chrome", "firefox" or "edge" is specified,'
            h[1],←⊂⊂'                   speedscope is launched in the specified browser.'
            h[1],←⊂⊂''
            h[1],←⊂⊂'                   For use with other browsers, "url" can specified. In this'
            h[1],←⊂⊂'                   case, a local URL will be displayed which can be copied and'
            h[1],←⊂⊂'                   used to manually navigate a browser.'
            h[1],←⊂⊂''
            h[1],←⊂⊂'                   If this modifier is omitted, HtmlRenderer is used.'
            h[1],←⊂⊂''
            h[1],←⊂⊂''
            h[1],←⊂⊂'-cpu               When set, profiling is based on CPU timer, otherwise elapsed'
            h[1],←⊂⊂'                   time. Ignored if no expression is provided'
            h[1],←⊂⊂''
            h[1],←⊂⊂''
            h[1],←⊂⊂'-keepTemp          When provided, any temporary export files created during'
            h[1],←⊂⊂'                   previous invocations are retained. Otherwise they are'
            h[1],←⊂⊂'                   deleted.'
            h[1],←⊂⊂''
            h[1],←⊂⊂''
            h[1],←⊂⊂'-msScale=<num>     Specifies the scaling factor applied at presentation of'
            h[1],←⊂⊂'                   millisecond timing values collected by ⎕PROFILE. After'
            h[1],←⊂⊂'                   values are scaled they are rounded up to the nearest'
            h[1],←⊂⊂'                   integer, as speedscope only displays whole numbers.'
            h[1],←⊂⊂''
            h[1],←⊂⊂'                   The default value is 1000, and results in timings being'
            h[1],←⊂⊂'                   displayed in microseconds.'
            h[1],←⊂⊂''
            h[1],←⊂⊂''
            h[1],←⊂⊂'-topFn=<value>     Specifies the name of the function to use as the top-level'
            h[1],←⊂⊂'                   of the profile. Any stack activity not invoked by the given'
            h[1],←⊂⊂'                   function is excluded from the visualized results.'
            h[1],←⊂⊂''
            h[1],←⊂⊂'                   This is not only useful in eliminating noise from the'
            h[1],←⊂⊂'                   analysis, but also to reduce the size of the file exported'
            h[1],←⊂⊂'                   to speedscope (which has been known to fail silently when'
            h[1],←⊂⊂'                   files are too large).'
            h[1],←⊂⊂''
            h[1],←⊂⊂'                   If not fully qualified, the #. root namespace is assumed.'
            h[1],←⊂⊂''
            h[1],←⊂⊂''
            h[1],←⊂⊂'-zoom=<num>        Sets the zoom level applied to the HtmlRenderer window. Only'
            h[1],←⊂⊂'                   applies when "-browser" modifier omitted. Defaults to 0.'
            h[1],←⊂⊂''
            h[1],←⊂⊂'                   The ]Zoomscope command is available to adjust the zoom of an'
            h[1],←⊂⊂'                   existing renderer window.'
            h[2],←⊂⊂''
            h[2],←⊂⊂'A stand-alone version of speedscope is distributed with this user command. All'
            h[2],←⊂⊂'processing is performed client-side (all data remains local; no network access'
            h[2],←⊂⊂'is required). See https://github.com/jlfwong/speedscope/ for more details.'
            h
        }⍬

        ⍵                               ⍝ Return command object
    }


    _preRunHook←{
        ⎕THIS.NS←⍎Import 0              ⍝ Import tool code, if needed; resolve namespace
        NS.Config.srcDir←SrcDir         ⍝ Globally cache installation location
        NS.Config.apply ⍵               ⍝ Apply modifiers to global config
    }

    NS←'⎕SE.PROFH'                      ⍝ Tool namespace, promoted to reference when loaded //~ Make configurable
 
    Import←{                            ⍝ Imports tool code into configured namespace
        ⍵<1⌊9=⎕NC NS : NS               ⍝ Skip if alrady done, unless forced
        o←⎕NS⍬ ⋄ o.overwrite←1          ⍝ Construct import options
        ⎕←o⎕SE.Link.Import NS SrcDir    ⍝ Import into configured namespace
        NS
    }

    ∇ r ← SrcDir                        ⍝ Determines directory containing project source
        r←¯1↓⊃1⎕NPARTS ##.SourceFile    ⍝ Get ucmd source directory
        r↑⍨←1-⍨⊃⌽⍸r='/'                 ⍝ Back up one directory
    ∇

    ∇ speedscope input;e;f
        f←1 ##.NS.Config.Curr.cpu       ⍝ Profiling (f)lags
        e←input.Arguments               ⍝ Pluck (e)xpressions for profiling, if any
        {}f(##.NS.Profile.prof⍣(×≢e))e  ⍝ If so, profile expressions, clearing previous profile data
        ##.NS.Graph ⍬                   ⍝ Export data, launch external tool
    ∇

    __Zoomscope←{
        ⍵.Run←zoomscope
        ⍵.Desc←'Adjust zoom level of existing speedscope renderer window'
        ⍵.Parse←'1S'

        ⍵.HelpText←{
            ⎕IO←0 ⋄ h←1↑⊂⍬

            h[0],←⊂⊂'Adjusts zoom level of existing speedscope renderer window by the given amount.'
            h[0],←⊂⊂''
            h[0],←⊂⊂'  ]Zoomscope [<num>]'
            h[0],←⊂⊂''
            h[0],←⊂⊂'Positive values increase the zoom level, and negative values decrease it. The'
            h[0],←⊂⊂'zoom scale is not linear. See the HTMLRenderer User Guide for more details.'
            h[0],←⊂⊂''
            h[0],←⊂⊂'If no value is provided, the zoom level is increased by 1.'
            h
        }⍬

        ⍵                               ⍝ Return command object
    }

    ∇ zoomscope input;a
        a←a,(⍴a←input.Arguments)↓⊂'1'   ⍝ Apply default argument
        a←2⌷⎕VFI⊃a                      ⍝ Parse argument
        ##.NS.Browser.adjZoom a         ⍝ Adjust zoom (ignores if none running, no-op if bad parse)
    ∇

    ⍝
    ⍝ --- Template initialization ----------------------------------------------
    ⍝

    _i←_init                            ⍝ Initialize template (MUST BE LAST LINE!)             
:EndNamespace

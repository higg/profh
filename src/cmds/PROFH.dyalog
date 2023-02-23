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

    
    __speedscope←{
        ⍵.Run←speedscope
        ⍵.Desc←'Visualize performance profile data with speedscope'
        ⍵.Parse←'9999S -browser=chrome firefox edge -keepTemp -showCmd -zoom∊¯.',⎕D

        ⍵.HelpText←{
            ⎕IO←0 ⋄ h←3↑⊂⍬

            h[0],←⊂⊂'Processes collected profiling data and renders it using speedscope--a 3rd-party'
            h[0],←⊂⊂'interactive flame graph visualization tool.'
            h[0],←⊂⊂''
            h[0],←⊂⊂'  ]speedscope [<expr> [<expr> ...]] [-browser={chrome|firefox|edge}] [-zoom=<num>] [-keepTemp]'
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
            h[1],←⊂⊂'                   Currently, the only supported values are "chrome" "firefox"'
            h[1],←⊂⊂'                   and "edge".'
            h[1],←⊂⊂''
            h[1],←⊂⊂'                   If omitted, HtmlRenderer is used.'
            h[1],←⊂⊂''
            h[1],←⊂⊂''
            h[1],←⊂⊂'-zoom=<num>        Sets the zoom level applied to the HtmlRenderer window. Only'
            h[1],←⊂⊂'                   applies when "-browser" modifier omitted. Defaults to 0.'
            h[1],←⊂⊂''
            h[1],←⊂⊂''
            h[1],←⊂⊂'-keepTemp          When provided, any temporary export files created during'
            h[1],←⊂⊂'                   previous invocations are retained. Otherwise they are deleted.'
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

    ∇ speedscope input;e
        e←input.Arguments               ⍝ Pluck (e)xpressions for profiling, if any
        1(##.NS.Profile.prof⍣(×≢e))e    ⍝ If so, profile expressions, clearing previous profile data
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

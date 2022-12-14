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

    
    _cmd←{                              ⍝ Builds default command object with given name, group
        r←⎕NS⍬
        nyi←⍵∘{⍺,' not yet implemented'}
        r.(Name Group Parse Desc)←⍵ _grp '' (nyi ⍬)
        r.Run←nyi
        r.Help←nyi
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
          _prh←_preRunHook{x←⍺⍺ ⍵ ⋄ ⍵}
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
    ⍝

    __Example←{
        ⍵.Run←{' implemented!',⍨Name}
        ⍵.Help←{'help level: ',⍕⍵}
        ⍵
    }

    __SpeedScope←{
        ⍵.Run←SpeedScope
        ⍵.Help←{'help level: ',⍕⍵}
        ⍵.Parse←'-browser='
        ⍵
    }

    _preRunHook←{
        x←Import 0                      ⍝ Install tool code, if needed
        ⎕THIS.NS←⍎NS                    ⍝ Resolve tool namespace
        NS.Config.apply ⍵               ⍝ Apply modifiers to global config
    }

    NS←'⎕SE.MMM'                        ⍝ Tool namespace, promoted to reference when loaded //! Make configurable
 
    Import←{                            ⍝ Imports tool code into configured namespace
        ⍵<1⌊9=⎕NC NS : 0                ⍝ Skip if alrady done, unless forced
        d←¯1↓⊃1⎕NPARTS ##.SourceFile    ⍝ Find tool installation directory
        ⎕←'Importing into ',(⍕NS),'...' ⍝ Announce workspace modification
        o←⎕NS⍬ ⋄ o.overwrite←1          ⍝ Construct import options
        o ⎕SE.Link.Import NS(d,'/..')   ⍝ Import into configured namespace
    }

    SpeedScope←{
        r←##.NS.Graph ⍬
        'SpeedScope implemented! ',⍕⍵
    }


    ⍝
    ⍝ --- Template initialization ----------------------------------------------
    ⍝

    _i←_init                            ⍝ Initialize template (MUST BE LAST LINE!)             
:EndNamespace

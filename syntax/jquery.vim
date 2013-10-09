" Vim syntax file
" Language:    jQuery
" Maintainer:  Bruno Michel <brmichel@free.fr>, Paul Morris <lanshunfang#@#gmail.com>
" Last Change: 2011-05-05
" Version:     0.5
" URL:         http://jquery.com/
" For version 0.5, Paul Morris added all keyword under 1.4, 
" as well as several widgets in official jQuery UI Component (search: jSWUIComponent) 
" and customized utilities of StreamWIDE (jSWUIComponent, jSWUtils).
" You can remove them if you are not pleased.
" May the Lord be you fortress! Amen!
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
if !exists("main_syntax")
  let main_syntax = 'javascript'
endif
ru! syntax/javascript.vim
unlet b:current_syntax
syn match   jQuery          /jQuery/|/$/

syn match   jFunc           //./w/+(/ contains=@jFunctions
syn cluster jFunctions      contains=jCore,jAttributes,jTraversing,jManipulation,jCSS,jEvents,jAjax,jUtilities,jEffects,jUIComponent,jSWUIComponent,jSWUtils
syn keyword jCore           contained each size length selector context eq error get index pushStack toArray noConflict
syn keyword jAttributes     contained attr removeAttr addClass removeClass toggleClass html text val
syn keyword jCSS            contained css
syn keyword jCSS            contained offset offsetParent position scrollTop scrollLeft
syn keyword jCSS            contained height width innerHeight innerWidth outerHeight outerWidth
syn keyword jTraversing     contained eq first last filter has is map not slice
syn keyword jTraversing     contained children closest find next nextAll nextUntil offsetParent parent parents parentsUntil prev prevAll prevUntil siblings
syn keyword jTraversing     contained add andSelf contents end
syn keyword jManipulation   contained append appendTo preprend prependTo
syn keyword jManipulation   contained after before insertAfter insertBefore
syn keyword jManipulation   contained unwrap wrap wrapAll wrapInner
syn keyword jManipulation   contained replaceWith replaceAll
syn keyword jManipulation   contained detach empty remove
syn keyword jManipulation   contained clone
syn keyword jEvents         contained ready
syn keyword jEvents         contained bind one trigger triggerHandler unbind delegate undelegate
syn keyword jEvents         contained live die
syn keyword jEvents         contained hover toggle
syn keyword jEvents         contained blur change click dblclick error focus focusin focusout keydown keypress keyup load
syn keyword jEvents         contained mousedown mouseenter mouseleave mousemove mouseout mouseover mouseup resize scroll select submit unload
syn keyword jEffects        contained show hide toggle
syn keyword jEffects        contained slideDown slideUp slideToggle
syn keyword jEffects        contained fadeIn fadeOut fadeTo
syn keyword jEffects        contained animate stop delay
syn keyword jAjax           contained ajax load get getJSON getScript post
syn keyword jAjax           contained ajaxComplete ajaxError ajaxSend ajaxStart ajaxStop ajaxSuccess
syn keyword jAjax           contained ajaxSetup serialize serializeArray
syn keyword jUtilities      contained support browser boxModel
syn keyword jUtilities      contained extend grep makeArray map inArray merge noop proxy unique
syn keyword jUtilities      contained isArray isEmptyObject isFunction isPlainObject
syn keyword jUtilities      contained each trim parseJSON clearQueue dequeue data removeData queue param 
syn keyword jUIComponent    contained button dialog datepicker tabs
syn keyword jSWUIComponent  contained swRangeDatePicker swDragndrop swDropdown swSlider checkBox
syn keyword jSWUtils        contained create update remove queueMeIn getAjaxResponse cacheLastestTrigger bindMeFirst maskMe swInArray validateMe 

syn region  javaScriptStringD          start=+"+  skip=+/////|//"+  end=+"/|$+  contains=javaScriptSpecial,@htmlPreproc,@jSelectors
syn region  javaScriptStringS          start=+'+  skip=+/////|//'+  end=+'/|$+  contains=javaScriptSpecial,@htmlPreproc,@jSelectors
syn cluster jSelectors      contains=jId,jClass,jOperators,jBasicFilters,jContentFilters,jVisibility,jChildFilters,jForms,jFormFilters
syn match   jId             contained /#[0-9A-Za-z_/-]/+/
syn match   jClass          contained //.[0-9A-Za-z_/-]/+/
syn match   jOperators      contained /*/|>/|>|/~/
syn match   jBasicFilters   contained /:/(first/|last/|not/|even/|odd/|eq/|gt/|lt/|header/|animated/)/
syn match   jContentFilters contained /:/(contains/|empty/|has/|parent/)/
syn match   jVisibility     contained /:/(hidden/|visible/)/
syn match   jChildFilters   contained /:/(nth/|first/|last/|only/)-child/
syn match   jForms          contained /:/(input/|text/|password/|radio/|checkbox/|submit/|image/|reset/|button/|file/)/
syn match   jFormFilters    contained /:/(enabled/|disabled/|checked/|selected/)/

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_lisp_syntax_inits")
  if version < 508
    let did_lisp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink jQuery          Constant
  HiLink jCore           Identifier
  HiLink jAttributes     Identifier
  HiLink jTraversing     Identifier
  HiLink jManipulation   Identifier
  HiLink jCSS            Identifier
  HiLink jEvents         Identifier
  HiLink jEffects        Identifier
  HiLink jAjax           Identifier
  HiLink jUtilities      Identifier
  HiLink jUIComponent    Identifier
  HiLink jSWUIComponent  Identifier
  HiLink jSWUtils        Identifier
  HiLink jId             Identifier
  HiLink jClass          Constant
  HiLink jOperators      Special
  HiLink jBasicFilters   Statement
  HiLink jContentFilters Statement
  HiLink jVisibility     Statement
  HiLink jChildFilters   Statement
  HiLink jForms          Statement
  HiLink jFormFilters    Statement
  delcommand HiLink
endif

let b:current_syntax = 'jquery'

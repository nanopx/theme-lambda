function fish_prompt
  # Cache exit status
  set -l last_status $status

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end
  if not set -q __fish_prompt_char
    switch (id -u)
      case 0
	set -g __fish_prompt_char '#'
      case '*'
	set -g __fish_prompt_char 'λ'
    end
  end

  # Setup colors
  #use extended color pallete if available
#if [[ $terminfo[colors] -ge 256 ]]; then
#    turquoise="%F{81}"
#    orange="%F{166}"
#    purple="%F{135}"
#    magenta="%F{161}"
#    limegreen="%F{118}"
#else
#    turquoise="%F{cyan}"
#    orange="%F{yellow}"
#    purple="%F{magenta}"
#    magenta="%F{red}"
#    limegreen="%F{green}"
#fi
  set -l normal (set_color normal)
  set -l white (set_color white)
  set -l cyan (set_color cyan)
  set -l red (set_color red)
  set -l magenta (set_color magenta)
  set -l blue (set_color blue)
  set -l limegreen (set_color green)
  set -l yellow (set_color yellow)
 
  # Configure __fish_git_prompt
  set -g __fish_git_prompt_char_stateseparator ' '
  set -g __fish_git_prompt_color 5fdfff
  set -g __fish_git_prompt_color_flags df5f00
  set -g __fish_git_prompt_color_prefix white
  set -g __fish_git_prompt_color_suffix white
  set -g __fish_git_prompt_showdirtystate true
  set -g __fish_git_prompt_showuntrackedfiles true
  set -g __fish_git_prompt_showstashstate true
  set -g __fish_git_prompt_show_informative_status true 

  function __fish_git_prompt_set_char
    set -l user_variable_name "$argv[1]"
    set -l char $argv[2]
    set -l user_variable
    if set -q $user_variable_name
      set user_variable $$user_variable_name
    end

    if set -q argv[3]
      and set -q __fish_git_prompt_show_informative_status
      set char $argv[3]
    end

    set -l variable _$user_variable_name
    set -l variable_done "$variable"_done

    if not set -q $variable
      set -g $variable (set -q $user_variable_name; and echo $user_variable; or echo $char)
    end
  end
  
  # __fish_git_prompt_set_char __fish_git_prompt_char_cleanstate '✔'
  __fish_git_prompt_set_char __fish_git_prompt_char_dirtystate '*' '＋'
  __fish_git_prompt_set_char __fish_git_prompt_char_invalidstate '#' '✕'
  # __fish_git_prompt_set_char __fish_git_prompt_char_stagedstate '+' '●'
  # __fish_git_prompt_set_char __fish_git_prompt_char_stashstate '$'
  # __fish_git_prompt_set_char __fish_git_prompt_char_stateseparator ' ' '|'
  # __fish_git_prompt_set_char __fish_git_prompt_char_untrackedfiles '%' '…'
  # __fish_git_prompt_set_char __fish_git_prompt_char_upstream_ahead '>' '↑'
  # __fish_git_prompt_set_char __fish_git_prompt_char_upstream_behind '<' '↓'
  # __fish_git_prompt_set_char __fish_git_prompt_char_upstream_diverged '<>'
  # __fish_git_prompt_set_char __fish_git_prompt_char_upstream_equal '='
  # __fish_git_prompt_set_char __fish_git_prompt_char_upstream_prefix ''
  
  # Line 1
  echo -n $white'╭ '$magenta$USER$white'@'$limegreen(basename "$PWD")$cyan
  __fish_git_prompt ":%s"
  echo

  # Line 2
  echo -n $white'╰'
  # support for virtual env name
  if set -q VIRTUAL_ENV
      echo -n "($cyan"(basename "$VIRTUAL_ENV")"$white)"
  end
  echo -n $white' '$__fish_prompt_char $normal
end



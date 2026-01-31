set -gx SHELL $(which fish)
fenv source ~/.profile

if status is-interactive
    set fish_greeting
    oh-my-posh init fish --config ~/.config/oh-my-posh-theme-powerlevel.omp.json | source
end

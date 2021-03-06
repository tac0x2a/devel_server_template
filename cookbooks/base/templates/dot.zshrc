
############
# 強力補完 #
############

# コマンド特化の補完
fpath=($HOME/.zsh-completions/src $fpath)

# 補完を有効に
autoload -U compinit
compinit

# 補完で大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

################
# 先方予測機能 #
################
#autoload predict-on
#predict-on

# 補完の時に大文字小文字を区別しない (但し、大文字を打った場合は小文字に変換しない)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

##############
# 文字コード #
##############
export LANG=ja_JP.UTF-8

######################################
# バージョン管理ツールのブランチ表示 #
######################################
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
		psvar=()
		LANG=en_US.UTF-8 vcs_info
		[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
#RPROMPT="%1(v|%F{green}%1v%f|)"

################################
# lessのシンタックスハイライト #
################################
if [ -f /usr/share/source-highlight/src-hilite-lesspipe.sh ]; then
		export LESS='-R'
		export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
fi


##############
# プロンプト #
##############
case ${UID} in
		0)
				PROMPT="
[%{[31m%}%U%n@%M %~%u%{[m%}]% %1(v|%F{green}%1v%f|) %{[31m%} # "
						PROMPT2="%{[31m%}%_%{[m%}]%> "
						SPROMPT="%{[31m%}%r is correct? [n,y,a,e]%{[m%}%: "
						[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="
[%{[37m%}%U%n@%M %~%u%{[m%}]% %1(v|%F{green}%1v%f|) %{[31m%} # "

						;;


		*)
				PROMPT="
%{[33m%}[%/] %1(v|%F{green}%1v%f|)
%{[33m%}[%n@%M ]%#%{[m%} "
				PROMPT2="%{[33m%}%_%{[m%}]%> "
				SPROMPT="%{[33m%}%r is correct? [n,y,a,e]%{[m%}%: "
				[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="
%{[37m%}[%/] %1(v|%F{white}%1v%f|)
[%n@%M ]%#%{[m%} "

				;;
esac


################
# タイトルバー #
################
case "${TERM}" in
		kterm*|xterm)
				precmd(){
						echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
				}
				;;
esac



################
# コマンド履歴 #
################
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data


#######################
# Emacs風キーバインド #
#######################
bindkey -e

##########################################
# コマンド履歴検索をC-pとC-nに割り当てる #
##########################################
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

###################
# コマンド関連etc #
###################
setopt auto_cd           # ディレクトリ名を入れるとcd
setopt auto_pushd        # tabキーでcd履歴
setopt correct           # コマンド補完
setopt list_packed       # 補完リストを圧縮表示
setopt nolistbeep        # ビープ音を殺す
setopt multios           # マルチリダイレクト(ちょっと危険)
setopt magic_equal_subst # = 以降でも補完できるようにする( --prefix=/usr 等の場合)
setopt list_types        # 補完候補一覧でファイルの種別を識別マーク表示(ls -F の記号)
unsetopt no_clobber      # リダイレクトで上書きを許可


##############
# 色を付ける #
##############
#各種コマンド
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls -h --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#color grep for mac
export GREP_OPTIONS='--color=auto'
export GREP_COLORS='1;35;40'

export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'


########
# tmux #
########
# alias tm='tmux'
# alias ta='tmux attach-session'
# alias tl='tmux list-session'

# if [ $SHLVL = 1 ];then
# 		tmux
# fi



############
# 環境変数 #
############

export PATH="${HOME}/.bin:${PATH}"
export PATH="/opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:${PATH}" #for mac
MANPAGER="/usr/bin/less -is"

# go
export GOPATH=~/.go
export PATH=$PATH:$GOPATH/bin

#git
# export GIT_PAGER="lv -c"
export LV='-z -la -Ou8 -c'

# svm(scala version managements)用
export SCALA_HOME=~/.svm/current/rt
export PATH=$SCALA_HOME/bin:$PATH

# play用
export PATH=/opt/play:$PATH

##############
# エイリアス #
##############
alias ls='ls -GF'
alias ll='ls -Glh'
alias la='ls -Ga'
alias lf='ls -GF'

#適切なサイズで表示
alias df='df -h'
alias du='du -h'

#aptitude関連
alias apu='sudo aptitude update'
alias aps='sudo aptitude search'
alias api='sudo aptitude install'

alias g='git'
alias r='rspec'

##################
# Emacsのtramp用 #
##################
case "${TERM}" in
dumb | emacs)
    PROMPT="%n@%~%(!.#.$)"
    RPROMPT=""
    unsetopt zle
    ;;
esac

##########
# gibo用 #
##########
_gibo()
{
    local_repo="$HOME/.gitignore-boilerplates"
    if [ -e "$local_repo" ]; then
        compadd $( find "$local_repo" -name "*.gitignore" -exec basename \{\} .gitignore \; )
    fi
}
compdef _gibo gibo


##################################
# ローカル設定ファイルを読み込む #
##################################
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

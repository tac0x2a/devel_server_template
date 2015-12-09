# Devel Server Template
Server template for development.
Construction by Vagrant and Itamae.

# Usage
## Itamae
```shell
$ gem install itamae
```

## Setup
```shell
$ vagrant init devel
$ itamae ssh -u vagrant -h devel recipe.rb
```

## Run
```shell
$ vagrant up
$ itamae ssh -u vagrant -h devel recipe.rb
```

# What is doing ?

- Installing packages (zsh tmux ruby git emacs, and packages to build Ruby).
- Set dot files (zshrc, gitconfig).
- Setup rbenv, build ruby, and global setting.

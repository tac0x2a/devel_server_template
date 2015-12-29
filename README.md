# Devel Server Template
Server templates for developing.
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

or

```shell
$ vagrant up
```

## Run
### Base

Install basic packages(`aptitude`, `emacs`, `zsh`, and `git`) and settings.
Please run this recipe before run other recipes.

```shell
$ itamae ssh -u vagrant -h devel cookbooks/base/default.rb
```

### Scala
Install scala and sbt by [**scalaenv**](https://github.com/mazgi/scalaenv) and [**sbtenv**](https://github.com/mazgi/sbtenv).


```shell
$ itamae ssh -u vagrant -h devel cookbooks/base/default.rb
$ itamae ssh -u vagrant -h devel cookbooks/scala/default.rb
```

### Apache Spark
Install [**Apacke Spark**](https://github.com/apache/spark).
Please run `Scala` recipe before run.

```shell
$ itamae ssh -u vagrant -h devel cookbooks/base/default.rb
$ itamae ssh -u vagrant -h devel cookbooks/scala/default.rb
$ itamae ssh -u vagrant -h devel cookbooks/spark/default.rb
```


# What is doing ?

- Installing packages (zsh tmux ruby git emacs, and packages to build Ruby).
- Set dot files (zshrc, gitconfig).
- Setup rbenv, build ruby, and global setting.

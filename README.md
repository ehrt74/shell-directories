# shell directories

A simple register list for directories in the shell. 

## Installation

### eshell

add the following to your `.emacs.d/init.el`:
    
    (let ((shell-directories "/PATH/TO/sd.el"))
      (when (file-exists-p shell-directories)
        (load shell-directories)))

### bash

1. load `sd.sh` in `.bashrc` as follows

        _SD=/PATH/TO/sd.sh
        if [ -f $_SD ]; then
            source $_SD
        fi

1. move `sd.py` to a directory in your `$PATH`

## Usage

add your current directory using `sda`
see a list of all saved directories using `sdl`
if a `*` is shown next a list index, this indicates the place the next directory will be added
goto a directory on the list by using `sdg $index`, e.g. `sdg 2` will chdir to the directory with index 2
clear the list by using `sdc`
delete one entry from the list using `sdd $index`

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

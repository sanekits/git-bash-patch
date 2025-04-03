# Git-bash patches

## Setup `make`

1. Open a `git-bash` terminal in Administrative mode
2. Run this:

    ```sh
    set -ue
    cd $TMPDIR
    curl -LO https://raw.githubusercontent.com/sanekits/git-bash-patch/main/make-installer.sh
    bash make-installer.sh
    ```

## See also

[Maintenance guide](./maint.md)

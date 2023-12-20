# Is It Worth Upgrading?

To check if your system is worth upgrading.

## Installation

Install via [AUR](https://aur.archlinux.org/packages/iwzu):

`paru -S izwu`

For now only Arch Linux is suppported.

## Usage

1. (optional, but convenient) Run `izwu init` to generate an example config file at
    `$XDG_CONFIG_HOME/izwu/izwu.yaml`

2. Edit the config file to specify:

    - what packages are worthy to trigger a full OS upgrade
    - which package version segment is "big enough" for an upgrade. 
      Supported package segments are:
        - `pkgrel` as defined by [PKGBUILD]
        - `major`, `minor` and `patch` as defined by <https://semver.org/>

3. Run `pacman -Sy`. Technically this is optional but probably necessary.

4. Run `izwu`. If there's any package matching your upgrade expectations,
    the command exits with a status `0` and prints potential upgrades like
    this:

    ```
    extra/ffmpeg 2:6.1-3
    ```

    If there're no worthy upgrades, it prints nothing and exits `1`. 

You could chain commands together as an shell alias like this:

```sh
# Bash / zsh alias:
alias checkupgrades="pacman -Sy; izwu && pacman -Syu"
```

## Configuration

There's no formal spec of config yet. Just follow the examples
in example config file for now.

## License

See <./LICENSE.md>


[PKGBUILD]: https://wiki.archlinux.org/title/PKGBUILD#pkgrel

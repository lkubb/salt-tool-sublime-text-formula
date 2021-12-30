# `subl` Formula
Sets up and configures Sublime Text, Package Control and plugins.

## Usage
Applying `tool-subl` will make sure Sublime Text is configured as specified.

## Configuration
### Pillar
#### General `tool` architecture
Since installing user environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All `tool` formulas assume running as root. There are three scopes of configuration:
1. per-user `tool`-specific
  > e.g. generally force usage of XDG dirs in `tool` formulas for this user
2. per-user formula-specific
  > e.g. setup this tool with the following configuration values for this user
3. global formula-specific (All formulas will accept `defaults` for `users:username:formula` default values in this scope as well.)
  > e.g. setup system-wide configuration files like this

**3** goes into `tool:formula` (e.g. `tool:git`). Both user scopes (**1**+**2**) are mixed per user in `users`. `users` can be defined in `tool:users` and/or `tool:formula:users`, the latter taking precedence. (**1**) is namespaced directly under `username`, (**2**) is namespaced under `username: {formula: {}}`.

```yaml
tool:
######### user-scope 1+2 #########
  users:                         #
    username:                    #
      xdg: true                  #
      dotconfig: true            #
      formula:                   #
        config: value            #
####### user-scope 1+2 end #######
  formula:
    formulaspecificstuff:
      conf: val
    defaults:
      yetanotherconfig: somevalue
######### user-scope 1+2 #########
    users:                       #
      username:                  #
        xdg: false               #
        formula:                 #
          otherconfig: otherval  #
####### user-scope 1+2 end #######
```

#### User-specific
The following shows an example of `tool-subl` pillar configuration. Namespace it to `tool:users` and/or `tool:subl:users`.
```yaml
users:
  user:
    xdg: true                         # force xdg dirs on macos
    dotconfig: true                   # sync config files from dotfiles repo (files in Packages/User)
    subl:
      plugins:
        - Emmet
        - SublimeLinter
```

#### Formula-specific
There are none currently.

### Dotfiles
`tool-subl.configsync` will recursively apply templates from 

- `salt://dotconfig/<user>/sublime-text` or
- `salt://dotconfig/sublime-text`

to the default config dir (`$SUBL_DIR/Packages/User`) for every user that has it enabled (see `user.dotconfig`). The target folder will not be cleaned by default (ie files in the target that are absent from the user's dotconfig will stay).

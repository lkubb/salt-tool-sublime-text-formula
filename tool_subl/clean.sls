# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_subl`` meta-state
    in reverse order.
#}

include:
  - .config.clean
  - .package.clean

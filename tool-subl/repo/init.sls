# see https://www.sublimetext.com/docs/linux_repositories.html
# for pacman and more. currently only implemented for package managers
# that can be managed by default salt (apt, dnf, yum, zypper)
# and relies on some simplifications

include:
{%- if 'Debian' == grains['os_family'] %}
  - .apt
{%- elif 'Suse' == grains['os_family'] %}
  - .zypper
{%- else %}
  - .yum
{%- endif %}

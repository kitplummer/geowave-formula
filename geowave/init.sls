{%- from 'geowave/settings.sls' import geowave with context %}

remove-existing-geowave-repo:
  pkgrepo.absent:
    - name: geowave

#geowave-repo:
#  pkgrepo.managed:
#    - humanname: geowave
#    - name: geowave
#    - baseurl: {{ geowave.repo_pkg_url }}

geowave-repo:
  pkg.installed:
    - sources:
      - geowave-repo: {{ geowave.repo_pkg_url }}

{%- if geowave.is_namenode %}
/usr/bin/hadoop:
  file.symlink:
    - target: /usr/lib/hadoop/bin/hadoop

/usr/lib/hadoop/bin/hadoop:
  file.replace:
    - pattern: bin=`dirname \${bin}`
    - repl: bin=`readlink ${bin}`;bin=`dirname ${bin}`
    - count: 1

{{ geowave.accumulo_pkg }}:
  pkg.installed:
    - fromrepo: geowave
    - version: {{ geowave.geowave_version }}
    - require:
#      - pkgrepo: geowave-repo
      - pkg: geowave-repo
      - file: /usr/bin/hadoop
      - file: /usr/lib/hadoop/bin/hadoop
{%- endif %}

{%- if geowave.is_appserver %}
{{ geowave.geoserver_pkg }}:
  pkg.installed:
    - fromrepo: geowave
    - require:
      - pkg: geowave-repo

{{ geowave.tools_pkg }}:
  pkg.installed:
    - fromrepo: geowave
    - require:
      - pkg: geowave-repo
{%- endif %}
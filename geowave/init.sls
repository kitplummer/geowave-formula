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
include:
  - sudoers
  - hadoop
  - accumulo

/usr/bin/hadoop:
  file.symlink:
    - target: /usr/lib/hadoop/bin/hadoop

/usr/lib/hadoop/bin/hadoop:
  file.replace:
    - pattern: bin=`^\s*dirname \${bin}`
    - repl: bin=`readlink -f ${bin}`;bin=`dirname ${bin}`
    - count: 1
    - flags: ['MULTILINE']

{{ geowave.accumulo_pkg }}:
  pkg.installed:
    - fromrepo: geowave
    - version: {{ geowave.geowave_version }}
    - require:
#      - pkgrepo: geowave-repo
      - pkg: geowave-repo
      - file: /usr/bin/hadoop
      - file: /usr/lib/hadoop/bin/hadoop

geowave-accumulo-config:
  cmd.script:
    - source: salt://geowave/files/geowave-accumulo-config.sh
#TODO: make 'localhost' generic; pull the DNS of the name_node from somewhere?
    - args: localhost {{ geowave.name_node_port }} {{ geowave.accumulo_classpath }} {{ geowave.accumulo_user }} {{geowave.accumulo_pswd }}
    - user: accumulo
    - require:
      - pkg: {{ geowave.accumulo_pkg }}
{%- endif %}

{%- if geowave.is_appserver %}
include:
  - sudoers

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
# Usage:
# $1 - hostname for HDFS Name Node
# $2 - port for HDFS Name Node
# $3 - path in HDFS to geowave-accumulo.jar, appended to /accumulo/classpath/
# $4 - accumulo shell user
# $5 - accumulo shell password

echo -e "geowave\ngeowave\n" | /usr/lib/accumulo/bin/accumulo shell -u $4 -p $5 -e "createuser geowave"
/usr/lib/accumulo/bin/accumulo shell -u $4 -p $5 -e "createnamespace geowave"
/usr/lib/accumulo/bin/accumulo shell -u $4 -p $5 -e "grant NameSpace.CREATE_TABLE -ns geowave -u geowave"
/usr/lib/accumulo/bin/accumulo shell -u $4 -p $5 -e "config -s general.vfs.context.classpath.geowave=hdfs://$1:$2/accumulo/classpath/$3/[^.].*.jar"
/usr/lib/accumulo/bin/accumulo shell -u $4 -p $5 -e "config -ns geowave -s table.classpath.context=geowave"

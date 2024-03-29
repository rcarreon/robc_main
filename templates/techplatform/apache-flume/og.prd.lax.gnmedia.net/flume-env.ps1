# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Give Flume more memory and pre-allocate, enable remote monitoring via JMX
$JAVA_OPTS="-Xms100m -Xmx512m -Dcom.sun.management.jmxremote"

# Foll. classpath will be included in Flume's classpath.
# Note that the Flume conf directory is always included in the classpath.
$FLUME_CLASSPATH="/etc/hadoop;/opt/apache-flume/lib/"   # Example:  "path1;path2;path3"

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
description "aurora scheduler"
start on stopped rc RUNLEVEL=[2345]
respawn
post-stop exec sleep 5

# Environment variables control the behavior of the Mesos scheduler driver (libmesos).
env GLOG_v=0
env LIBPROCESS_PORT=8083
env LIBPROCESS_IP=192.168.99.100
env DIST_DIR=/home/vagrant/aurora/dist

# Flags that control the behavior of the JVM.
env JAVA_OPTS='-Djava.library.path=/usr/lib -Dlog4j.configuration="file:///etc/zookeeper/conf/log4j.properties" -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005'

chdir /usr/local/aurora-scheduler/bin/aurora-scheduler
exec bin/aurora-scheduler \
  -cluster_name=devcluster \
  -hostname=aurora.local \
  -http_port=8081 \
  -native_log_quorum_size=1 \
  -zk_endpoints=192.168.99.100:2181 \
  -mesos_master_address=zk://192.168.99.100:2181/mesos/master \
  -serverset_path=/aurora/scheduler \
  -native_log_zk_group_path=/aurora/replicated-log \
  -native_log_file_path=/var/db/aurora \
  -backup_dir=/var/lib/aurora/backups \
  -thermos_executor_path=$DIST_DIR/thermos_executor.pex \
  -thermos_executor_flags="--announcer-enable --announcer-ensemble localhost:2181" \
  -vlog=INFO \
  -logtostderr \
  -allowed_container_types=MESOS,DOCKER \
  -http_authentication_mechanism=BASIC \
  -use_beta_db_task_store=true \
  -shiro_ini_path=etc/shiro.example.ini \
  -enable_h2_console=true \
  -tier_config=/home/vagrant/aurora/src/test/resources/org/apache/aurora/scheduler/tiers-example.json \
  -receive_revocable_resources=true

#!/bin/bash
sig=true
n="$1"
v=($(seq 0 $((n - 1))))
view_string="$(IFS=','; echo "${v[*]}")"
IFS="$OIFS"
use_sig=1
use_mac=1

cat > config/system.config <<EOF
# Copyright (c) 2007-2013 Alysson Bessani, Eduardo Alchieri, Paulo Sousa, and the authors indicated in the @author tags
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

############################################
####### Communication Configurations #######
############################################

#HMAC algorithm used to authenticate messages between processes (HmacMD5 is the default value)
#This parameter is not currently being used being used
#system.authentication.hmacAlgorithm = HmacSHA1

#Specify if the communication system should use a thread to send data (true or false)
system.communication.useSenderThread = true

############################################
### Replication Algorithm Configurations ###
############################################

#Number of servers in the group
system.servers.num = $n

#Maximum number of faulty replicas
system.servers.f = $(( (n - 1) / 3 ))

#Timeout to asking for a client request
system.totalordermulticast.timeout = 200000


#Maximum batch size (in number of messages)
system.totalordermulticast.maxbatchsize = 400

#Number of nonces (for non-determinism actions) generated
system.totalordermulticast.nonces = 10

#if verification of leader-generated timestamps are increasing
#it can only be used on systems in which the network clocks
#are synchronized
system.totalordermulticast.verifyTimestamps = false

#Quantity of messages that can be stored in the receive queue of the communication system
system.communication.inQueueSize = 500000

# Quantity of messages that can be stored in the send queue of each replica
system.communication.outQueueSize = 500000

#Set to 1 if SMaRt should use signatures, set to 0 if otherwise
system.communication.useSignatures = $use_sig

#Set to 1 if SMaRt should use MAC's, set to 0 if otherwise
system.communication.useMACs = $use_mac

#Set to 1 if SMaRt should use the standard output to display debug messages, set to 0 if otherwise
system.debug = 0

#Print information about the replica when it is shutdown
system.shutdownhook = true

############################################
###### State Transfer Configurations #######
############################################

#Activate the state transfer protocol ('true' to activate, 'false' to de-activate)
system.totalordermulticast.state_transfer = false

#Maximum ahead-of-time message not discarded
system.totalordermulticast.highMark = 10000

#Maximum ahead-of-time message not discarded when the replica is still on EID 0 (after which the state transfer is triggered)
system.totalordermulticast.revival_highMark = 10

#Number of ahead-of-time messages necessary to trigger the state transfer after a request timeout occurs
system.totalordermulticast.timeout_highMark = 200

############################################
###### Log and Checkpoint Configurations ###
############################################

system.totalordermulticast.log = false
system.totalordermulticast.log_parallel = false
system.totalordermulticast.log_to_disk = false
system.totalordermulticast.sync_log = false

#Period at which BFT-SMaRt requests the state to the application (for the state transfer state protocol)
system.totalordermulticast.checkpoint_period = 100000000
system.totalordermulticast.global_checkpoint_period = 100000000

system.totalordermulticast.checkpoint_to_disk = false
system.totalordermulticast.sync_ckp = false


############################################
###### Reconfiguration Configurations ######
############################################

#Replicas ID for the initial view, separated by a comma.
# The number of replicas in this parameter should be equal to that specified in 'system.servers.num'
system.initial.view = $view_string

#The ID of the trust third party (TTP)
system.ttp.id = 7002

#This sets if the system will function in Byzantine or crash-only mode. Set to "true" to support Byzantine faults
system.bft = true
EOF

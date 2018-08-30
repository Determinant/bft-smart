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

#HMAC algorithm used to authenticate messages between processes ('HmacSHA256' is the default value)
system.communication.hmacAlgorithm = HmacSHA256

#Algorithm to generate secret keys used to generate MACs ('PBEWithSHA1AndDES' is the default value)
system.communication.secretKeyAlgorithm = PBEWithSHA1AndDES

#Signature algorithm used to verify clients requests and to perform the authenticated Diffie-Hellman exchange during
#replica start-up ('SHA256withRSA' is the default value). This parameter is overriden in the event that a custom key loader is supplied
system.communication.signatureAlgorithm = SHA256withECDSA

# Algorithm used to compute hashes ('SHA-256' is the default value)
system.communication.hashAlgorithm = SHA-256

#Specify if the communication system should use a thread to send data (true or false)
system.communication.useSenderThread = true

#Force all processes to use the same public/private keys pair and secret key. This is useful when deploying experiments
#and benchmarks, but must not be used in production systems. This parameter will only work with the default key loader.
system.communication.defaultkeys = true

#IP address this replica should bind to. If this parameter does not have a valid ip address,
#the replica will fetch the host address on its own. If config/hosts.config specifies the
#loopback address for the host machine, this parameter is overriden by that
system.communication.bindaddress = auto

############################################
### Replication Algorithm Configurations ###
############################################

#Number of servers in the group 
system.servers.num = $n

#Maximum number of faulty replicas 
system.servers.f = $(( (n - 1) / 3 ))

#Timeout to asking for a client request
system.totalordermulticast.timeout = 2000


#Maximum batch size (in number of messages)
system.totalordermulticast.maxbatchsize = 100

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

#Print information about the replica when it is shutdown
system.shutdownhook = true

#Force all replicas to deliver to the application the same number of requests per batch.
#This is not the same batch used during the ordering protocol
system.samebatchsize = true

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

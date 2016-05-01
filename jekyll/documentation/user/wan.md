---
layout: documentation
title: Using Portico over a WAN
author: Open LVC Team
section: User Documentation
section-path: documentation/user/
tags: [wan]
compatibility_version: 2.1+

header-image-path: assets/pages/documentation/user/wan/page-logo.jpg
header-image-text: Using Portico over a WAN

excerpt: > 
    Network communications in Portico use UDP over Multicast by default. This provides a fast,
    robust interconnect for most federations. However, if you want to create a truly global
    federation, linking simulations separated by continents, you will need to use the WAN bridging
    capabilities added in Portico v2.1.

---

Using Portico over the Internet
================================
So you want to run a federation over the Internet, ay? Well I have good news for
you; Portico has your back!

Starting from version 2.1, Portico has added a WAN mode that will allow users to create
globe-spanning federations with the flick of a switch. Whether you want to connect together
distributed assest embedded on location, or run a single simulation across centres
geographically separated, Portico's WAN support removes the network boundaries.


Use Cases
----------
There are many reasons why you might want to connect federates via a point-to-point, TCP
configuration rather than using the local multicast:

  1. Local network policy restrictions (blocking of multicast)
  2. Connect simulations running across different networks
  3. Connect simulations running in geographically separate areas that cannot be moves (large simulators perhaps)
  4. Operate a Portico federation on a commercial cloud provider where multicast is blocked
  5. The LOLs

With this new capability we have designed a facility that is both sensitive to those who want to
add single remote federates to a federation as well as those who want to run clusters at many
different sites.

Requirements
-------------
WAN-enabled federations impose two additional requirements.

  1. Must be able to run a single WAN Router somewhere accessible to all networks. This computer
     must be able to accept incoming connections.

  2. A single local federate at each site must be able to connect out from the local network to
     the WAN Router.

**Firewall** exceptions will need to be set up for the WAN Router to allow it to receive connections.
This is required on the computer hosting the WAN Router only.

**NAT Traversal** is supported. A local federate creates a connection outward from the local network
through the NAT. This connection is then held open and reused by the WAN Router for inbound
communication, removing the need for additional connections that would not be able to traverse a
NAT.


Overview
---------
Portico's WAN support has been designed to be sensitive to deployment realities
while minimizing infrastructure needs and maintaining simplicity and ease-of-use.

To connect distributed networks, a central WAN Router component is used.

The basic topology of a WAN-enabled simualtion revolves around a central WAN Router. The router
sits at the the center of the distributed simulation and ensures that messages from each network
are approprirately forwarded on to the other networks:

```
Federate <--|              /                    \              |--> Federate
 ^          |              \                    /              |          ^
 |          v              /                    \              v          |
 |   (Federate|Gateway) ---\---- WAN Router ----/--- (Gateway|Federate)   |
 |          ^              /                    \              ^          |
 V          |              \                    /              |          V
Federate <--|              /                    \              |--> Federate
```

The router is the only component with special access requirements. It must be able to **accept
incoming connections** from the other networks. The port used by the router can be configured,
but defaults to `23114`.

At each local site, very little changes. Federates on the same network segment continue to
interoperate using multicast as they have previously done. Additionally, one federate on 
each network is designated as the local Gateway*. This is enabled through the RID file,
with additional configuration options specifying the IP address and port of the router.

  _* Can run a standalone gateway process if desired._

Step-by-Step
-------------
In this example we'll work through the changes required to WAN-enable a federation. The commands
presented here reference the **HPref** performance testing federate that was used in the
development of this capability. It is left as an exercise for the reader to adapt the startup
process for their own federates according to their specific needs.

In this example we will execute two instances of a throughput testing federation using three
separate sites:

  1. Singapore - Throughput Federate #1
  2. Amsterdam - WAN Router
  3. New York  - Throughput Federate #2

### Step 1: Start the WAN Router
**Amsterdamn**

As above, the router sits at the heard of a WAN-enabled simulation and must be able to accept
incoming connections from all remote sites. From the _Portico installation directory_ you run
the following command:

```
[tim@ams1:/opt/local/portico-2.1.0]$ bin/wanrouter.sh --address ams.openlvc.org

INFO  [portico.wan]: 
##########################################################
#                   Portico Open RTI                     #
#            Welcome to Portico for the HLA!             #
#                                                        #
#     Portico is distributed by under the terms of       #
#    the Common Development and Distribution License.    #
#    For a copy of the license, see the LICENSE file     #
#     included in the root of the distributable you      #
#                      downloaded.                       #
##########################################################
#                                                        #
#                    System Information                  #
#                                                        #
# Portico Version:          2.1.0 (build 0)              #
# Platform Architecture:    amd64                        #
# CPUs:                     1                            #
# Operating System:         Linux                        #
# Operating System Version: 3.13.0-32-generic            #
# Java Version:             1.8.0_25                     #
# Java Vendor:              Oracle Corporation           #
#                                                        #
# Startup Time:             Oct 9, 2015 - 11:01:42 AM    #
# RID File:                 RTI.rid                      #
# Log Level:                WARN                         #
#                                                        #
##########################################################
 => RTI Home: /opt/local/portico-2.1.0
INFO  [portico.wan]: WAN Router Configuration:
INFO  [portico.wan]: |---------------------------------------|
INFO  [portico.wan]: | Address: ams.openlvc.org/64.74.223.36 |
INFO  [portico.wan]: |    Port: 23114                        |
INFO  [portico.wan]: | Metrics: false                        |
INFO  [portico.wan]: |---------------------------------------|
INFO  [portico.wan]: 
INFO  [portico.wan]: Starting Portico WAN Router. Press "x" to exit
INFO  [portico.wan]: 
INFO  [portico.wan]: Ready to accept connections
```

Configuration of the WAN Router is done via command line. If you run the `--help` argument you will
get a full listing of options.

The most important options to specify is the Network Interface (**NIC**) which the router will
accept connections on. You pass the `--address [IP/Name]` argument, specifying one of the following:

  - `x.x.x.x`         - IP address that is used by the NIC
  - `host.domain.com` - Host name that points to the IP used by the NIC
  - `GLOBAL`          - Symbolic name telling the WAN Router to select the NIC witht the first
                        globally accessible IP it finds
  - `SITE_LOCAL`      - Will select a "site local" address: `192.168.x.x`, `10.x.x.x`, `172.16.x.x`
  - `LINK_LOCAL`      - Will select a "link local" address: `169.254.x.x`
  - `LOOPBACK`        - Will select the local loopback adapter

In our example we specify a domain name that points back to the local machine on the public IP
that all the other networks will use to find it: `ams.openlvc.org`.

By default, the localhost address of `127.0.0.1` is used. This is likely not useful to you, so be
sure to specify something the other networks can reach.


### Step 2: Configure each Local Sites
**New York**

Only a single outward connection is needed at each local site. All local federates communicate at
full speed using regular local networking without having to deal with the additional overhead of
TCP.

This is especially important when you have a single external federate a large number of local
federates. You don't want all the local federates having to push their updates out to a router
just so they can be reflected back to the same network. We want to conserve this bandwidth for
inter-network traffic.

At each local site you will have to designate a single federate as the _Local Gateway_. To do this
you will need to make two changes in that federate's RID file.

  1. Set WAN support to `enabled`
  2. Specify the address of the WAN Router

```
[tim@nyc1:/opt/local/hperf-1.0.0]$ vim RTI.rid

281: portico.wan.enabled = true
282: 
283: # (5.2) Router Address/Port
284: #       Specifies the address and port of the WAN router to use. Note that the
285: #       syntax is "address:port".
286: #
287: #       Default: 127.0.0.1:23114
288: #
289: portico.wan.router = ams.openlvc.org:23114
```

Once you've made the appropriate configuration you can start the local federate. It will act as
both a local federate and the local gateway. Let's start by firing it up:

```
[tim@nyc1:/opt/local/hperf-1.0.0]$ ./throughput.sh --federate-name nyc --peers sgp
Starting HPerf Test Federate (use --help to display usage)
INFO  [hp.nyc]: 
INFO  [hp.nyc]:     Test Driver: Throughput Test
INFO  [hp.nyc]:   Callback Mode: IMMEDIATE
INFO  [hp.nyc]:    Time Stepped: NO
INFO  [hp.nyc]: 
INFO  [hp.nyc]: Creating RTIambassador
INFO  [hp.nyc]: Connecting...
INFO  [hp.nyc]: Creating Federation...

-------------------------------------------------------------------
GMS: address=nyc1-45062, cluster=test-fed, physical address=10.0.0.1:42383
-------------------------------------------------------------------
INFO  [hp.nyc]: Created Federation [test-fed]
INFO  [hp.nyc]: Joined Federation as nyc
INFO  [hp.nyc]: Publish and Subscribe complete
INFO  [hp.nyc]: Registering HLAobjectRoot.TestFederate object for local federate
INFO  [hp.nyc]:  ===================================
INFO  [hp.nyc]:  =     Running Throughput Test     =
INFO  [hp.nyc]:  ===================================
INFO  [hp.nyc]: 
INFO  [hp.nyc]:       Messsage Size = 1.00KB
INFO  [hp.nyc]:          Loop Count = 20
INFO  [hp.nyc]:        Object Count = 20
INFO  [hp.nyc]:   Interaction Count = 20
INFO  [hp.nyc]:   Messages Per Loop = 40 (20 updates, 20 interactions)
INFO  [hp.nyc]:          Total Sent = 800
INFO  [hp.nyc]:               Peers = 1
INFO  [hp.nyc]:     Total Send Size = 800.00KB
INFO  [hp.nyc]:     Total Revc Size = 800.00KB
INFO  [hp.nyc]:      Total Messages = 1,600
INFO  [hp.nyc]: 
INFO  [hp.nyc]: Waiting for peers: [sgp]
```

You may notice above that the GMS message includes an IP address in the `10.x.x.x` range.
This is the standard Portico networking connecting to the local network. Inside the federate
a separate TCP connection is being made to the WAN Router.

If there is a problem connecting to the WAN Router you will get an error at this point.
If the federate can connect to the WAN Router you will not see anything unusual. On the
router you will see a connection notice:

```
INFO  [portico.wan]: Ready to accept connections
INFO  [portico.wan]:  (Accepted) Connection ID=1, ip=/62.71.224.76:56149
```

### Step 3: Start Other Federates
**Singapore**

In this example we will repeat this process for the federate at the local Singapore site.
As this the first federate at this site, we'll have to designate it as the local gateway by
enabling WAN support in its RID.

```
[tim@sgp1:/opt/local/hperf-1.0.0]$ vim RTI.rid
...
[tim@sgp1:/opt/local/hperf-1.0.0]$ ./throughput.sh --federate-name sgp --peers nyc
```

<div class="alert error">
  <p><b>Single Gateway Per Site</b><br/>
  It is only necessary to designate a <i>single</i> federate at each site to be the local gateway.
  When starting other federates at the same site, just start them as normal. Their WAN support must
  be left **turned off**.
  </p>
</div>

Assuming we are only using a single federate at each site, once the second federate is started
they should both connect to one another and run through until completion. Once they've finished
you will see disconnection notices on the WAN Router:

```
INFO  [portico.wan]:  (Accepted) Connection ID=1, ip=/62.71.224.76:56149
INFO  [portico.wan]:  (Accepted) Connection ID=2, ip=/123.179.131.27:47112
INFO  [portico.wan]:   (Removed) Connection ID=2 has disconnected
INFO  [portico.wan]:             Packets From: 47 packets, 870KB
INFO  [portico.wan]:             Packets Sent: 44 packets, 870KB
INFO  [portico.wan]:   (Removed) Connection ID=1 has disconnected
INFO  [portico.wan]:             Packets From: 48 packets, 872KB
INFO  [portico.wan]:             Packets Sent: 47 packets, 870KB
```

Congratulations! You have now run a fully distributed simulation. Testing federates in Singapore
and New York have exchanged messages, bounding all traffic through a router in Amsterdam. That's
about as distributed as it gets.


Firewall and NAT Traversal
---------------------------
One of the key design considerations for the Portico WAN capability has been simplicify,
especially as it relates to firewall and NAT support.

Every effort has been made to minimize problems, however additional configuration will always
be required for sites with particularly stringent security policies.

The _WAN Router_ is the main component that has special requirements. It must be accessible from
the remote sites and available on the appropriately configured port. This must work through any
local firewall or NAT and configuration of these will require support from the deployment site.

With regard to remote sites, there are no special requirements beyond the ability of the _Local
Gateway_ to connect outbound to the _WAN Router_. When a connection to the router is established,
the socket is held open and also used as a channel to send inbound messages. Because it is using 
an already established connection rather than initiating a new one, this typically will not cause
issues with firewall or NAT traversal. 

Outbound connections are commonly not an issue on most networks, however in some instances a local
network policy may only permit them on various ports. In this case the local firewall must either
be permitted to allow outbound connections on the Portico WAN port (`23114`) or the port must be
changed to something that is allowed.


Configuring Portico for the WAN
--------------------------------
All configuration for a local gateway is done via the RID file. Inside the RID you will find
several WAN specific configuration properties. The main ones are listed below, but please consult
the fully documented default RID file shipped with Portico for the complete list:

  1. `portico.wan.enabled` - Enable/Disable the WAN sub-system for the federate. Set to `true`
      for any federate that will act as a local gateway.

  2. `portico.wan.router` - The address/port combination of the _WAN Router_. When WAN mode is
      enabled this is used by the _Local Gateway_ to find the router. Default: `127.0.0.1:23114`

  3. `portico.wan.bundle.enabled` - Defaulting to `true`, this setting will queue up messages at
      the local gateway until there are enough to send as a large batch. This makes more efficient
      use of the network and has a significant impact on increasing throughput in most cases.
      Defaults to `true`.

  4. `portico.wan.bundle.maxsize` - Defines the maximum size of all messages to queue up for
      bundling before we force them to be flushed to the WAN Router. Default is `64K`.

  5. `portico.wan.bundle.timeout` - Defines the maximum amount of time we should hold any message
      for in the bundler before flushing to the router. This ensures that messages are flushed out
      in a timely fashion rather than waiting indefinately for enough other messages to arrive to
      meet the `maxsize` requirement. Defined in milliseconds and defaults to `20`.


Important Considerations
-------------------------
For the most part configuration should be pretty straightforward. However, there are some
important bits and pieces to keep in mind when running a distributed simulation like this.

### Start the Local Gateway federates first

When a local gateway is running, all Portico traffic will be forwarded to it. An essential part
of startup is the federation joining process. To ensure that any local federates (non-WAN) find
the federation successfully, we have to ensure that they are connected to it! This means, we
have to run the local gateway federate first.

<div class="alert error">
  <p><b>Start each Local Gateway first</b><br/>
  To avoid any startup problems the local gateway must be the first federates started at each site.
  </p>
</div>

In the example used earlier, if we were running three federates at the New York site (`nyc1`, `nyc2`
and `nyc3`) we would first start `nyc1` (assuming it was configured as the local gateway). This
would link us in to any running federation that the Singapore site might have already created. We
can then run `nyc2` and `nyc3`. Their messages will relay through `nyc1` and responses from
Singapore will be routed back to them.

If we ran one of these local federates first, they would have no way to connect into or know about
the remote federation. Due to Portico being a completely distributed RTI, this would result in the
federates starting a new federation on the local network only.

So, as a general rule, **always start the Local Gateway federates first**.


### Don't enable WAN mode in more than one local federate

Every federate that has `portico.wan.enabled = true` will try to connect to a WAN Router. If you
use the same RID file for multiple federates and this setting is enabled, they will **all** try
to connect to the WAN router as well as the local network and you will get packet echo.


Message Bundling
-----------------
_Message Bundling_ is a concept used to increase the throughput of a federation by making more
effective use of network resources.

The idea is simple: Because sending messages over a point-to-point pipe is expensive and slow,
it's better to send fewer messages containing more data than lots of messages with little chunks.

When enabled, bundling will block messages from being forwarded inside the Local Gateway. It will
queue them up so that they can be sent in a large batch together. This is why earlier you may have
noticed that the _WAN Router_ console output only listed that each federate had sent ~48 packets
rather than the 1,600 that the test says should have been sent. All 1,600 messages were sent, but
they were sent in 40-odd bundles.

### Tuning Bundling

There are two trigger conditions that will cause the queue to be flushed to the router:

  1. The combined size of the stored messages reaches a defined limit
  2. The amount of time that the oldest message has been held for has reached a defined limit

Both these settings are configurable. Finiding the right balance depends largely on the cadenace
of your work load.

Most simulation loads tend to contain more asynchronous messages that come at a regular and rapid
rate. These loads naturally suit bundling. The sustained send-rate will cause the bundling threshold
to be met regularlly. Overall throughput in this case is more of a performance factor than the
latency of any subset of messages. This can become especially true when you start adding slow links
into the WAN which can be used much more effectively in larger batches.

However, if your load includes a number of synchronous calls, bundling may turn out to harm overall
performance. Messages will get held for an unnecessary amount of time as Portico waits in the hope
that more will arrive so they can be bundled together. The only problem is those messages never
arrive. The messages are then only flushed when the time-limit trigger is exceeded.

A classic example is Portico's latency benchmarking federate. It sends single messages out to all
federates and then waits for responses. Because these messages are small, they get held up by the
bundler as it waits for more data to flush as a block.

This data is never going to come beacuse the test federate won't do anything until it gets
responses back from the rest of the federation, which requires the original message to be sent.

In this situation there are two options:

  1. Lower the max hold time: It defaults to 20ms, but you can lower it to whatever you want
  2. Turn bundling off entirely

The right choice for you will depend on the specifics of your simulation. Portico has chosen
some sensible defaults that tend to work well for the common case, but we'd advise you to
experiment with these settings to find what works best for you.


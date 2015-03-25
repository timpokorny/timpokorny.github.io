---
layout: documentation
title: Using Portico with VBS
author: Tim Pokorny
section: LVC Guides
section-path: documentation/guides/
tags: [vbs, vbs3, guides]
compatibility_version: 2.x

header-image-path: assets/images/simsystems/vbs3-3.jpg
header-image-text: VBS3 from Bohemia Interactive Simulations

excerpt: > 
    VBS3 is a flexible simulation training solution for scenario training, mission rehersal,
    squad-based tactical training and more. VBS uses Calytrix Technologies LVC Game to connect
    to simulation networks via DIS and HLA. Here, we look at how to link it with Portico.

---

<table class="default-table" style="width:auto;font-size:0.8em">
	<tr>
		<td><b>Vendor</b></td>
		<td><a href="https://bisimulations.com/">Bohemia Interactive Simulations</a></td>
	</tr>
	<tr>
		<td><b>Version</b></td>
		<td>VBS3, VBS2</td>
	</tr>
	<tr>
		<td><b>Operating System</b></td>
		<td>Windows 7 (32/64), Windows 8 (32/64)</td>
	</tr>
	<tr>
		<td><b>HLA Interfaces</b></td>
		<td>
			<a href="{% site_root %}documentation/developer/apistatus/hla13/cpp.html">HLA 1.3 (c++)</a>, 
			<a href="{% site_root %}documentation/developer/apistatus/ieee1516e/cpp.html">IEEE 1516-2010 (c++)</a>
		</td>
	</tr>
	<tr>
		<td><b>Suported FOMs</b></td>
		<td>
			<a href="{% site_root %}documentation/hla/standards.html#rpr1">RPR1</a>, 
			<a href="{% site_root %}documentation/hla/standards.html#rpr2">RPR2</a>,
			<a href="{% site_root %}documentation/hla/standards.html#erf">ERF5</a>
		</td>
	</tr>
	<tr>
		<td><b>Portico Versions</b></td>
		<td>{{ page.compatibility_version }}</td>
	</tr>
</table>


VBS3 is a flexible simulation training solution for scenario training, mission rehearsal
and more. Leveraging proven games industry technology, VBS3 adds all the elements required
to deliver structured simulation supported training, including After Action Review, realistic
radio communications, support for specialst procedures and actions such as hand signal
communication, CASEVAC/MEDEVAC, obstacle crossing and much more.

VBS and HLA
===================
Each copy of VBS ships with <a href="www.calytrix.com/products/lvcgame/">LVC Game</a> from
Calytrix Technologies. DIS and HLA integration is provided through this gateway using a variety
of FOMs.
 
To connect VBS to a Portico federation, you must configure LVC Game to use Portico, defining
the appropriate HLA interface and FOM that you wish to use. VBS is a windows-only application,
with 32/64-bit support. When connecting with Portico users should use the **Visual Studio 10**
inteface.

Supported Versions
--------------------
The following list shows the specific versions of Portico that we recommend you use, and
which we have verified through testing.

| VBS Version | Portico Version |
| ----------- | --------------- |
| VBS 3.2+    | <span class="label label-success">Portico 2.1+</span> |
| VBS 3.0     | <span class="label label-success">Portico 2.0</span>  |
| VBS 2.15    | <span class="label label-success">Portico 2.0</span>  |


Supported Interfaces
--------------------
The following HLA interfaces are supported when linking Portico with VBS:

| HLA Interface  | Supported  |
| ---------------|------------|
| IEEE 1516-2010 | <span class="label label-success">Supported</span> |
| IEEE 1516-2000 | <span class="tooltip label label-danger" title="Not Supported in C++">Not Supported</span> |
| HLA 1.3        | <span class="label label-success">Supported</span> |


<div class="alert info">
	<p><b>32/64-bit Mode</b><br/>
	VBS runs in both 32 and 64-bit mode. Ensure you download the appropriate Portico installer
	to match the version of VBS you intend to use.</p>
</div>


Configuring VBS for Portico
============================
Setting up any application to use the HLA is rarely a simple process. However, once you know the
major moving parts, getting VBS working with Portico is mercifully straightforward.

The major steps are:

  1. Set your `RTI_HOME` environment variable
  2. Set your `PATH` environment variable
  3. Turn the LVC Game HLA plugin on inside `vbsClient.config`
  4. Edit the `HLA.config` file
  5. Replace LVC Game's default `RTI.rid` file

We'll walk through each of these steps in detail, but before we do, a quick word on what we are
setting up. _LVC Game for VBS_ supports a number of different FOMs. Which one you choose will
slightly alter your configuration. In this guide we will be setting up VBS3 with the HLA 1.3
plugin using RPR2. Where applicable we'll make notes about how to use different interface/FOM
combinations.

Configuring Your Environment
-----------------------------
  
  - Install Portico
  - Set environment variable to point `%RTI_HOME%` at Portico installation directory
  - Put `%RTI_HOME%\bin\vc10;%RTI_HOME%\bin\jre\server` on `%PATH%`


Configuring VBS
----------------

  - Turn on HLA plugin in vbsClient.config
  - Edit HLA.config
    - Settings...
  - Replace the RID file


Starting VBS
-------------
  - Launcher -- in Special Builds, ensure "lvc" is checked
    - Alternatively, use the Admin LVC preset
  - Start VBS
  - Start a Network Game
     - Notice the pause... This is Portico creating a new federation

Confirming it is working
-------------------------
  - Confirm things are working
     - Check `[VBS]\logs\portico.log`
     - Check `[VBS]\LVCGame.log`


Troubleshooting
===============
So... something went wrong, did it? Hey, this is HLA so let's not you and I pretend like
that is some sort of surprise. We both know better.

Because life is cruel, there are a number of common things that can go wrong. However,
because we are _not_ cruel, we've compiled an awesome list for you!

  - Error 123: You've mismatched your 32/64-bit builds
  - Error 123: You've forgotten to put the `jre.dll` directory on your `%PATH%`
  - LVCGame.log says "Failed to load...": You forgot to replace the `RTI.rid`
  - You forgot to actually enable the plugin in vbsClient.config




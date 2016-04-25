---
layout: documentation
title: Using Portico with VBS
author: Open LVC Team
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
Each copy of VBS includes _Calytrix <a href="http://www.calytrix.com/products/lvcgame/">LVC Game</a>_.
DIS/HLA connectivity is provided through this gateway supporting a variety of FOMs and all
major versions of the HLA API. 

Connecting VBS to a Portico federation involves configuring LVC Game to use Portico as its RTI, 
and defining the appropriate FOM for VBS to use. VBS is a windows-only application and has 32/64-bit
support. For the integration to work a user must identify the right set of libraries for VBS to
use based on the appropriate complier (vc8, 9, 10...). The table below lists which interfaces
should be used for which VBS verison.

Supported Versions
--------------------
The following list shows the specific versions of Portico that we recommend you use, and
which we have verified through testing.

| VBS Version | Portico Version | Visual Studio |
| ----------- | --------------- | ------------- |
| VBS 3.2+    | <span class="label label-success">Portico 2.1+</span> | VC10 |
| VBS 3.0     | <span class="label label-success">Portico 2.0</span>  | VC8  |
| VBS 2.15    | <span class="label label-success">Portico 2.0</span>  | VC8  |


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
So you have VBS up and running and you want to link it through to Portico? 
Setting up any application to use the HLA is rarely a simple process. However, once you know the
major moving parts, getting VBS working with Portico is mercifully straightforward.

The major steps are:

  1. Set your `RTI_HOME` environment variable
  2. Set your `PATH` environment variable
  3. Turn the LVC Game HLA plugin on inside `vbsClient.config`
  4. Edit the `HLA.config` file
  5. Replace LVC Game's default `RTI.rid` file

We'll walk through each of these steps in detail, but before we do, a quick word on what we are
setting up.

_LVC Game for VBS_ supports a number of different FOMs. Which version you choose will
slightly alter your configuration. In this guide we will be setting up **VBS3** with the
**HLA 1.3** plugin using the **RPR2** FOM. Where applicable we'll make notes about how to use
different interface/FOM combinations. To test things, we recommend having a second computer handy
so that you can link VBS to VBS.

Preparing the Environment
---------------------------
Excited? Really!? OK - whatever works for you...

Let's start from the beginning. To start, you'll want to
<a href="{{site.root}}documentation/user/gettingstarted.html">Install Portico</a>. Be sure to
note down the location where you installed it, because we're about to use that information.

### Setting RTI_HOME
Portico has a few moving pieces that need to find one another on your local system. To do this
they use the `RTI_HOME` environment variable. Depending on the Portico version, the installer
may have already set this variable for you, but to be sure you should always check.

In Windows, open the control panel and search for "System". This should give you an option
to "Edit the system environment variables".

<img src="{% page_asset 1-control-panel.png %}"/>

Clicking this brings you through to the system information dialog. Down the bottom of the
window you will find a screen that lets you access the environment variables:

<img src="{% page_asset 2-system-dialog.png %}"/>

Once you have clicked on this, look for the environment variable `RTI_HOME`. If it is present
it will look approximately like the image below. If it is not present, add it now and set the
location to the directory Portico was installed in to.

![Editing the RTI_HOME variable]({% page_asset 3-edit-variables.png %})

POW! That was pretty easy, wasn't it?


### Setting the PATH
The system path is a series of folders that Windows will look inside whehn it is trying to 
load DLLs and other droll bits and pieces. Due to the way Portico is implemented, we have to
add two directories to this path:

  # The directory that contains the RTI DLLs
  # The directory that contains the Java Virtual Machine DLL

To get started, let's figure out what these values should be. Firstly, the RTI DLLs. The location
will depend on which Visual Studio compiler version you are using. The version in Portico must
match that of the application you are integrating with. This will typically be in that product's
documentation. For LVC Game, refer to the table presented earlier. We're using VBS v3.6 for this
test, so we want the VC10 interface:

  `%RTI_HOME%\bin\vc10`

Notice that we used the special "%name%" syntax. This lets us use the value of another environment
variable rather than having to manually enter in the full path information. The location of all
RTI DLLs in Portico is in the `bin/vcXX` directory, where 'XX' is the version number you need. If
you have any doubt, go look inside that folder in Windows explorer.

Secondly, we need to find the location of the Java Virtual Machine (JVM) DLLs. This is also
pretty simple because Portico includes the JVM in your installation. The only thing you have
to be aware of is that the path changes slightly between 32-bit and 64-bit.

  * **32-bit**: `%RTI_HOME%\jre\bin\client`
  * **64-bit**: `%RTI_HOME%\jre\bin\server`

NOTE NOTE NOTE NOTE NOTE

The system path is specified as a ";" separated list. That is, the full path is one big long
entry, but inside the paths are separated by the ";" character. We will add our two enteries
to the end. Again, note that the Portico installer may have already done this for you. If it
has it is always worth double checking.

Go back to the environment variables screen and scroll until you the `PATH` variable. To edit
it, add the two paths to the end:

  `...;%RTI_HOME%\bin\vc10;%RTI_HOME%\jre\bin\server`

IMAGE IMAGE IMAGE

Double POW! Take a deep breath - the hardest part is over. Once you've got the environment
set up there is very little else you need to do. And to make things even better, this process
is common to all Portico installs. Now that you've learnt it for VBS, you can do it for any
other application - AND it may well have already been taken care of by the installer (Portico 2.1+)!

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




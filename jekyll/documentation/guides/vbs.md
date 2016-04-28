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
    VBS3 is a flexible simulation training solution for individual and squad level infantry 
    training. DIS/HLA connectivity in VBS is provided by either Calytrix LVC Game or VBS Gateway
    depending on the version. This guide discusses how to use Portico with VBS3.

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
		<td>Windows 7, 8, 10 (32/64)</td>
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


VBS and HLA
===================
VBS can operate on HLA federations through one of two middleware options: LVC Game or VBS Gateway:

  - VBS *v3.7* and earlier: LVC Game
  - VBS *v3.7.1* and later: VBS Gateway

This article describes how to enable and configure LVC Game for VBS 3. As such, it only applies
to versions of **VBS 3.7 and earlier**.

<div class="alert error">
	<p><b>VBS Gateway</b><br/>
	 Thus far we haven't been able to get Portico working with VBS Gateway. Its level of
	 compatibility is unknown and at this point in time it is unsupported. Information from
	 anyone who has been successful would be greatly appreciated!</p>
</div>

LVC Game is shipped directly with VBS. There is no need for any separate installation.

Connecting VBS to a Portico federation involves configuring LVC Game to use Portico as its RTI, 
and defining the appropriate FOM for VBS to use.

VBS is a windows-only application and has 32/64-bit support. Depending on your version of VBS,
you will need to identify the right set of Portico libraries to use (vc8, 9, 10...). The table
below lists which interfaces should be used for which VBS verison.

Supported Versions
--------------------
The following list shows the specific versions of Portico that we recommend you use, and
which we have verified through testing.

| VBS Version | Portico Version | Visual Studio |
| ----------- | --------------- | ------------- |
| VBS 3.2-3.7 | <span class="label label-success">Portico 2.1.x</span> | VC10 |
| VBS 3.0     | <span class="label label-success">Portico 2.0.x</span>  | VC8  |
| VBS 2.x     | <span class="label label-success">Portico 2.0.x</span>  | VC8  |


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

VBS/LVC Deployment
===================
In a typical VBS/LVC network, a single computer acts as the LVC Gateway. This computer is also
typically the VBS game server (active or dedicated server).

All changes discussed below should only be made on the server. Regular client PCs will connect
via standard VBS networking to a game where the server will bridge out to the federation.


Configuring VBS for Portico
============================
We start by assuming that you have VBS and Portico both installed into their default locations.
If you need help with Portico, check out the
<a href="{{site.root}}documentation/user/gettingstarted.html">Install Portico</a> guide.

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
**HLA Evolved** (1516e) plugin using the **RPR2** FOM. Where applicable we'll make notes about how
to use different interface/FOM combinations.

To test things, we recommend having a second computer handy so that you can link two instances of
VBS together via Portico.

Preparing the Environment
---------------------------
Excited? Really!? OK - whatever works for you...

We assume you've installed Portico and that it is located in `C:\Program Files\Portico\2.1.0`.
Remember that.

### Setting RTI_HOME
Portico has a few moving pieces that need to find one another when things fire up. As is the
HLA convention, to do this they use the `RTI_HOME` environment variable. Depending on the Portico
version, the installer may have already set this variable for you, but to be sure you should always
check.

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
The system path is a series of folders that Windows looks inside when it is trying to 
load DLLs and other droll bits and pieces. For implementation reasons you really don't care about
(really) we need to add two additional directories:

  - The directory that contains the RTI DLLs
  - The directory that contains the Java Virtual Machine DLL

Let's figure out what these values should be. First, the RTI DLLs.

The important bit to remember here is that you must know which compiler version you need.
We mentioned in the table under the "Supported Versions" section earlier.

For LVC Game, refer to the table presented earlier. We're using VBS v3.6 for this
test, so we want the VC10 interface, so we are going to add the following directory to the path:

  `%RTI_HOME%\bin\vc10`

![Extending the system PATH]({% page_asset 4-add-rti-home.jpg %})

Notice that we used the special "%name%" syntax. This tells windows to replace this path
with the value of a different enviornment variable.

The location of all RTI DLLs in Portico is in the `bin/vcXX` directory, where 'XX' is the
version number you need. If you have any doubt, go look inside that folder in Windows explorer:

![DLLs for different compilers]({% page_asset 5-dlls-for-compilers.jpg %})

Next we need to find the location of the Java Virtual Machine (JVM) DLLs. Portico ships with
the JVM it wants to use. The only thing you have to be aware of is that the path you want will
change slightly between 32-bit and 64-bit versions:

  * **32-bit**: `%RTI_HOME%\jre\bin\client`
  * **64-bit**: `%RTI_HOME%\jre\bin\server`

![JVM DLLs for 32/64-bit]({% page_asset 6-jvm-dll-locations.jpg %})


<div class="alert info">
	<p><b>System Path Format</b><br/>
	The system path is specified as a <code>;</code> separated list. That is, value of the
	<code>PATH</code> variable is one line string of paths, each separated by the <code>;</code>
	character. We will add our two enteries to the end. Note that the Portico installer may have
	already done this for you. It is always worth double checking.<br/><br/>

	Go back to the environment variables screen and scroll until you the <code>PATH</code>
	variable. To edit it, add the two paths to the end:<br/><br/>

	<code>...;%RTI_HOME%\bin\vc10;%RTI_HOME%\jre\bin\server</code>
	</p>
</div>

Double POW! Take a deep breath - the hardest part is over. Once you've got the environment
set up there is very little else you need to do. And to make things even better, the process
you have just completed is common for most Portico installs. Now that you've learnt it for VBS,
you can do it for any other application - AND it may well have already been taken care of by the
installer!


Configuring VBS
----------------
Now that we have the RTI installed and some environment variables pointing to the right location
we need to configure LVC Game. There are a couple of steps here:

  1. Turn on HLA plugin in vbsClient.config
  2. Edit HLA.config to set federate/federation names
  3. Replace the RID file

### VBS Client Config
The `vbsClient.config` file is located in `[VBS_DIR]\config`. It contains the main configuration
for LVC Game, including the plugins that it should load. We want to edit this file to disable the
DIS plugin and enabled the HLA plugin.

**IMAGE - config directory**

Any lines in an LVC Game configuration file starting with the `#` character are considered
comments and ignored.

In this case, we will comment out the default plugin configuration and put a `#` at the start of
line 123 (approximately). To enable the HLA plugin we will uncomment (remove the `#`) from line
123 (approx again). When done, it should look like this:

**IMAGE - editing the file to enable HLA**


### Selecting the right Interface/FOM
When editing the `vbsClient.config` file you will notice that you can choose from many different
combinations of HLA version and FOM. It is important to choose the option that fits your needs.

In this example we are using IEEE-1516e and RPR2, but you just as easily switch that to HLA v1.3
and an alternate FOM like the "Entity Resolution FOM" (ERF) if you wanted. To do this, just enable
the appropriate line in the configuration to point to the right configuration file.

### Editing `HLA.config`
Now that we've enabled the HLA plugin, we need to make some final HLA-specific configuration
edits. To do this, we have to edit the plugin config file: `HLA.config`.

From the `[VBS_DIR]\config` directory, go to `HLA-1516e\RPR2\HLA.config`. Inside this file we are
going to set two important properties:

  1. The federate name
  2. The federation name

Inside the `HLA.config` file look for the following two lines:

```
100: 
101: hla.fedex = LVCGame
102: 
...
140: 
141: hla.federate = FederateName
142: 
```


### Replacing the RID file
A RID file contains configuration data for an RTI. By default, LVC Game ships with RID files for
an alternate RTI.

On startup, LVC Game will ensure that the `RTI.rid` file sitting in the same folder as `HLA.config`
is the one that gets loaded. Because this is not a Portico RID file, it is a different, incompatible
format. As such, we need to replace it with the default Portico RID file.

Copy `[RTI_HOME]\RTI.rid` to `[VBS_DIR]\config\HLA-1516e\RPR2\`. If you want to change any Portico
settings later on, you can do so by editing this RID file.


Starting VBS
-------------
That's it! Everything is configured. We just need to start VBS with the proper switches to enable
LVC Game now and we are good.

To do this, from the launcher select the "LVC Admin" preset. Alternatively, you just need to make
sure that the `lvc` box is checked on the "Special Builds" section of the launcher profile.

**IMAGE - Launcher Special Builds**

Launch VBS and start a network game. LVC Game is initialized when you first click "Start Network Game":

**IMAGE - Button you click when LVC plugin is loaded**

If things are working properly you will notice a significant pause after you click this button.
That pause is Portico creating a new federation.


Confirming it is working
-------------------------
To double confirm that things are working we can look in the log files.

We can first check the LVC Game log file. Look inside `[VBS_DIR]\LVCGame.log` to see what it
said about loading the HLA plugin. You should see lines confirming that everything was
initialized successfully:

**IMAGE - LVCGame log file!**


Secondly, you can check for the presence of the Portico log file. If LVC Game is being loaded
properly, and it in turn is loading Portico properly, you'll have a Portico log file! If it didn't
load then the file is unlikely to have been created at all. 

Check to see if `[VBS_HOME]\logs\portico.log` exists:

**IMAGE - Portico.log is alive!**


And that it is!! Portico is now up and running with VBS.

Troubleshooting
===============
So... something went wrong, did it? Hey, this is HLA so let's not you and I pretend like
that is some sort of surprise. We both know better.

Because life is cruel, there are a number of common things that can go wrong. However,
because we are _not_ cruel, we've compiled an awesome list for you!

  - Error 193: Mismatched 32/64-bit
  
  - Error 126: DLLs are not on the path - have you forgotten `jvm.dll`?
  		You've forgotten to put the `jvm.dll` directory on your `%PATH%`

  - LVCGame.log says "Failed to load...": You forgot to replace the `RTI.rid`
  		Portico is failing to load because the RID file is in a different format.

  - Nothing happened. I don't get any Portico log but LVC Game log doesn't show any errors
  		Is the HLA plugin enabled? Check `vbsClient.config` to ensure that one of the
  		HLA plugins is enabled.




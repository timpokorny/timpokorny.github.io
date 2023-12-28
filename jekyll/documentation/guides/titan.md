---
layout: documentation
title: Using Portico with Titan.IM
author: Open LVC Team
section: LVC Guides
section-path: documentation/guides/
tags: [titan, titan.im, guides]
compatibility_version: 1.x

header-image-path: assets/images/simsystems/titan-3.jpg
header-image-text: Titan Vanguard from Titan.IM

excerpt: > 
    Titan.IM represents the next wave of virtual simulation. Built on the Outerra World Rendering
    Engine, Titan is a single simulation environment supporting land, sea, air, space and subsurface
    simulation with global coverage. Out-of-the-box, Titan ships with Calytrix LVC Game to connect
    with DIS and HLA simulation networks. Here we see how to link it with Portico.

---

<table class="default-table" style="width:auto;font-size:0.8em">
	<tr>
		<td><b>Vendor</b></td>
		<td><a href="https://bisimulations.com/">Bohemia Interactive Simulations</a></td>
	</tr>
	<tr>
		<td><b>Version</b></td>
		<td>Titan Vanguard</td>
	</tr>
	<tr>
		<td><b>Operating System</b></td>
		<td>Windows 7, 8.1, 10 (32/64)</td>
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


Titan.IM represents the next wave of virtual simulation. Built on the Outerra World Rendering
Engine, Titan is a single simulation environment supporting land, sea, air, space and subsurface
simulation with global coverage. Out-of-the-box, Titan ships with Calytrix LVC Game to connect
with DIS and HLA simulation networks. Here we see how to link it with Portico.


Titan and HLA
===================
Each copy of Titan embeds _Calytrix <a href="https://www.calytrix.com/products/lvcgame/">LVC Game</a>_.
DIS/HLA connectivity is provided through this gateway supporting a variety of FOMs and all
major versions of the HLA API. 

To connect Titan with a Portico federation we have to configure LVC Game to use Portico as its RTI.
Titan is a windows-only application, and has 32/64-bit support. For the integration to work a user
must identify the right set of Portico libraries to use (vc10). 

Supported Versions
--------------------
The following list shows the specific versions of Portico that we recommend you use, and
which we have verified through testing.

| Titan Version | Portico Version | Visual Studio |
| ----------- | --------------- | ------------- |
| Vanguard 2016 | <span class="label label-success">Portico 2.1+</span> | VC10 |


Supported Interfaces
--------------------
The following HLA interfaces are supported between Portico and Titan:

| HLA Interface  | Supported  |
| ---------------|------------|
| IEEE 1516-2010 | <span class="label label-success">Supported</span> |
| IEEE 1516-2000 | <span class="tooltip label label-danger" title="Not Supported in C++">Not Supported</span> |
| HLA 1.3        | <span class="label label-success">Supported</span> |


<div class="alert info">
	<p><b>32/64-bit Mode</b><br/>
	Titan runs in both 32 and 64-bit mode. Ensure you download the appropriate Portico installer
	to match the version of Titan you intend to use.</p>
</div>







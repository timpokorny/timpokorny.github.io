---
layout: release

version: 2.1.0
type: release-major.html
status: Released
status-css-class: label-success
release-date: May 4th, 2016
tag: portico-2.1.0
baseline: maintenance-2.1.x
---

<p class="bigger">
	<span class="dropcap">T</span>he Portico team is pleased to announce the general availability
	of Portico v2.1.0. This release focuses on some major steps forward in allowing users to execute
	federations that use assets separated by firewalls, domains and oceans.
</p>

Portico has enjoyed considerable support from Thales in recent years, both through individual
contributions helping to address defects, and with broader support aimed at helping facilitate
key new functionality. This support has continued in the development and release of Portico v2.1,
with Thales supporting the development and testing of new wide-area networking capabilities.

The WAN features added in this release will allow clusters of federates at multiple sites to
connect to one-another over a point-to-point backbone. This will give users the opportunity
to bridge federations between networks; whether across a campus, country, continent or the globe. 

### Notes

 - `note` The bundled JRE version is `1.8.0_66`
 - `note` Support for Visual Studio 8 (2005) and Visual Studio 9 (2008) has been deprecated.
          Libraries generated for these compilers will be removed in the next version.


### New Features

 - `feature` Added support bridging single federates into a federation via point-to-point link (`#44`)
 - `feature` Added support for connecting clusters of federations via point-to-point link (`#135`)
 - `feature` Updated MOM facilities to work in 1516e as expected (`#55`)
 - `feature` Added Federation Auditor which will log messages exchanged by a federate including some
             metadata about those messages (`#43`)


### Improvements

 - `improve` Improved the way messages are handled when federate is overloaded, causing reduction
             in lost packets (`#63`)
 - `improve` Improvments to make the loading of federate internal message handlers more robust (`#75`)
 - `improve` Added a summary-mode to the Portico federate message Auditor (`#64`)
 - `improve` Improved logging of Auditor to include current date (`#62`)
 - `improve` Updated README to include updated information for the configuration/deployment of Portico (`#50`)
 - `improve` Improved the Auditor to contain information breakdowns for sent/received Interactions (`#58`)
 - `improve` Updated C++ example federates on Linux to remove warnings (`#160`)
 - `improve` Updated C++ example federate packages on Mac OSX and Linux to provide customized environment
             files for use with GDB (`#162`)
 - `improve` Portico will now appear properly in Add/Remove Programs list on Windows (`#132`)
 - `improve` Added support for parallel C++ compilation with automatic detection of optimal number of
             threads based on system CPU count. Build-time speedup of 30% (`#79`)


### Bugs

 - `bugfix` Fixed problem with rapid ownership exchange and re-exchange among federates (`#166`)
 - `bugfix` `evokeSingleCallback(double)` will now wait appropriate amount of time if there are
   no messages to immediately process (`#118`)
 - `bugfix` Fixed problem causing truncation of attributes or interaction params over `986b` in size (`#65`)
 - `bugfix` Fixed problem with HLA-Evolved FOM parser not recognizing some transport and order
   properties unless they were defined as child elements (`#163`)
 - `bugfix` Fixed potential hang when calling `disconnect()` in HLA-Evolved interface (`#118`)
 - `bugfix` Fixed sporadic exceptions that sometimes happened when federates resigned (`#54`)
 - `bugfix` Fixed problem with incorrect DLL naming for `64-bit` libraries (`#59`)
 - `bugfix` Fixed a problem that prevented automatic crash identification for lost federates (`#162`, `#126`)
 - `bugfix` Fixed problem initializing Portico in Java-based web applications (`#157`)
 - `bugfix` Fixed `LogicalTimeFactoryFactory` loading of `HLAinteger64Time` (`#142`)
 - `bugfix` Fixed linker error for HLA 1.3 C++ test suite on Windows (`#124`)
 - `bugfix` Fixed bug with incorrect modification of `UpdatesAttributes` objects if JVM communications
   binding is used (`#120`)
 - `bugfix` Fixed compile warnings in HLA 1.3 C++ test suite under Ubuntu 14.04 (GCC 4.8) (`#99`)
 - `bugfix` Fixed problem that was adding erronous null characters to end of string encoded for use
   with MOM attributes in `1516` and `1516e` interfaces (`#105`)
 - `bugfix` Fixed a problem where MOM infrastructure would serve MOM updated even if it was disabled (`#108`)
 - `bugfix` Fixed logging inside federation restore `RTIambassador` method (`#76`)


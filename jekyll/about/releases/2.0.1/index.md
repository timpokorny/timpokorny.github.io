---
layout: release

version: 2.0.1
type: release-maintenance.html
status: Released
status-css-class: label-success
release-date: Oct 22nd, 2014
tag: portico-2.0.1
baseline: maintenance-2.0.x
---

<p class="bigger">
	<span class="dropcap">P</span>ortico v2.0.1 is the first maintenance release for the
	major <code>2.0.x</code> stream. It contains a number of useful bugfixes, especially
	for the C++ interface. Many of these fixes were submitted by members of the Portico
	community - this particular release would not be possible without them.
</p>

<p class="bigger">
	The full Change Log is reproduced below.
</p>

### Notes

 * `note` Packaged JRE Updates to Java 8u20
 * `note` Portico support for Java 6 and earlier officially deprecated as Java 6 has reached
          its official EOL. Java 6 support beyond v2.1 not guaranteed

### Improvements

 * `improve` Standard development environment and packaged JRE has been updated to Java 8u20 on all platforms. (`PORT-149`)
 * `improve` Patch to allow the setting of java system properties from within the C++ interface. (`#30` - JeanPhilippeLebel)
 * `improve` Logging output from the 1516e interface will now be send to a file if the `PORTICO_REDIRECT` environment variable is set. (`#39` - raymondfrancis)

### Bug Fixes

 * `bugfix` Reduced warnings and other compilation problems for c++ interface on Ubuntu LTS releases (`PORT-17`)
 * `bugfix` Portico c++ interface and unit tests now compile and complete successfully on Mac OS X Mavericks (10.9). (`PORT-146`)
 * `bugfix` Generated java code now backwards compatible to Java 6 (`PORT-139`)
 * `bugfix` Fixed "Insufficient data" exceptions in 1516e C++ encoding helpers (`#34` - lumixen)
 * `bugfix` Fixed encoding errors in the ieee1516e aggregate structs (`#35` - lumixen)
 * `bugfix` Fixed intermittent crash in the 1516e C++ interface that happened when multiple threads accessed the `RTIambassador`. Fix was also ported across to the HLA v1.3 interface. (`#39` - raymondfrancis)
 * `bugfix` Corrected indirection for processing VariableLengthData objects in 1516e C++ interface (`#39` - raymondfrancis)
 * `bugfix` Fixed `TimeFactory` compatibility problem in 1516e C++ with code generated from Pitch Developer Studio (`#39` - raymondfrancis)
 * `bugfix` Allow absolute file URLs in FOM module specification when creating a federation in the 1516e interface (`#39` - raymondfrancis)

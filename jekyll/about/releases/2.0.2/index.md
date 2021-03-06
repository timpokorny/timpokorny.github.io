---
layout: release

version: 2.0.2
type: release-maintenance.html
status: Released
status-css-class: label-success
release-date: Dec 31st, 2015
tag: portico-2.0.2
baseline: maintenance-2.0.x
---

<p class="bigger">
      <span class="dropcap">P</span>ortico v2.0.2 is the second maintenance release for the
      major <code>2.0.x</code> series. This release provides a number of bugfixes for the core
      RTI, including an important <code>tick(min,max)</code> timing fix and the remediation of
      a long standing bug that caused truncation if any single attribute/parameter exceeded
      <code>989b</code> in size.
</p>

<p class="bigger">
      The full Change Log is reproduced below and is available for download
      <a href="https://github.com/openlvc/portico/releases/tag/portico-2.0.2">here</a>.
</p>

### Notes

 * `note` Bundled JRE version has been updated to `1.8.0_66`

### Improvements

 * `improve` Fixed a problem that made Portico difficult to use in private Maven repos.
             This would manifest as extremely long startup time as a large number of
             non-Portico related jar files were unnecessarily scanned. (`#148`)
 * `improve` Added ability to generate a sandbox that includes a JRE by calling the
             `sandbox.full` target. This is useful when building from source for use
             with `RTI_HOME` directly set to the sandbox directory. (`#130`)

### Bug Fixes

 * `bugfix` Fixed a bug that would cause the truncation of values for large attribute
            reflections or parameters sent. If a value of an individual attributes or
            parameter was >`989b`, all values after the 989th byte were being trucated
            to `0`. (#65)
 * `bugfix` Fixed a problem preventing use of Portico with time managed federates
            generated by Pitch Developer Studio (`#41`)
 * `bugfix` Fixed a problem where calling `tick(min_time,max_time)` would not tick
            for at least `min_time` if there were messages waiting for processing.
            (`#53`)
 * `bugfix` Fixed a problem with `IEEE-1516e` Java interface referencing wrong
            `LogicalTimeFactory` implementation with Integer-based times. (`#142`)
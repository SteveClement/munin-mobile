#!/bin/bash

#
# Updates the graphs, html and resizes the images
#

# Update regular munin files
/usr/bin/munin-cron

# This used to test if the executables were installed.  But that is
# perfectly redundant and supresses errors that the admin should see.

/usr/share/munin/munin-update --config=/etc/munin/munin-mobile.conf $@ || exit 1

# The result of munin-limits is needed by munin-html but not by
# munin-graph.  So run it in the background now, it will be done
# before munin-graph.

/usr/share/munin/munin-limits $@ &

nice /usr/share/munin/munin-graph --config=/etc/munin/munin-mobile.conf --cron $@ 2>&1 |
        fgrep -v "*** attempt to put segment in horiz list twice"

wait

nice /usr/share/munin/munin-html --config=/etc/munin/munin-mobile.conf $@ || exit 1

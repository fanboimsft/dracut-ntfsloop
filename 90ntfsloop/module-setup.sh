#!/bin/bash

# Copyright © 2016-2019 Jonas Kümmerlin <jonas@kuemmerlin.eu>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

command -v

check() {
    return 0
}

depends() {
    echo base dm
    return 0
}

install() {
    inst_multiple kpartx umount losetup
    inst_script "$moddir/ntfsloop.sh" /sbin/ntfsloop
    inst_hook cmdline 90 "$moddir/parse-ntfsloop.sh"
    inst_hook shutdown 90 "$moddir/shutdown-ntfsloop.sh"

    dracut_need_initqueue
}

installkernel() {
    hostonly='' instmods fuse loop
}

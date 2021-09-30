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

. /lib/dracut-lib.sh

mount_cifsloop() {

    local dev
    local login
    local path

    #parse rd.cifsloop command line arguments
    string=$(getargs rd.cifsloop=)
    echo $string
    i=0
    for n in $(echo $string | tr ":" "\n" ); do
    array[i]=$n
    ((i++))
    done
    dev=${array[0]}
    login=${array[1]}
    path=${array[2]}

    mkdir -p "/run/initramfs/cifsloop/cifs"

    # mount cifs share
    echo "trying to mount cifs share"
    mount -t cifs "$dev" -o "$login" "/run/initramfs/cifsloop/cifs" | (while read l; do warn $l; done)
    # create a symlink for the device path - this symlink will survive and
    # be there for the shutdown hook, the mount point won't
    ln -s "$dev" "/run/initramfs/cifsloop/device"

    # get the loop device up
    info "cifsloop: Creating loop device for $path"
    kpartx -afv "/run/initramfs/cifsloop/cifs/$path" | (while read l; do warn $l; done)

    # make sure our shutdown script runs
    need_shutdown
}

mount_cifsloop "$@"

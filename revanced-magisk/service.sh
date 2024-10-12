#!/system/bin/sh
<<<<<<< HEAD
MODDIR=${0%/*}
RVPATH=/data/adb/rvhc/${MODDIR##*/}.apk
. "$MODDIR/config"

err() {
	[ ! -f "$MODDIR/err" ] && cp "$MODDIR/module.prop" "$MODDIR/err"
	sed -i "s/^des.*/description=⚠️ Needs reflash: '${1}'/g" "$MODDIR/module.prop"
}
=======
# shellcheck disable=SC2086,SC1091
MODDIR=${0%/*}
RVPATH=$NVBASE/rvhc/${MODDIR##*/}.apk
. $MODDIR/config
>>>>>>> 71b9976 (Initial commit)

until [ "$(getprop sys.boot_completed)" = 1 ]; do sleep 1; done
until [ -d "/sdcard/Android" ]; do sleep 1; done
while
<<<<<<< HEAD
	BASEPATH=$(pm path "$PKG_NAME" 2>&1 </dev/null)
	SVCL=$?
	[ $SVCL = 20 ]
do sleep 2; done

run() {
	if [ $SVCL != 0 ]; then
		err "app not installed"
		return
	fi
	sleep 4

	BASEPATH=${BASEPATH##*:} BASEPATH=${BASEPATH%/*}
	if [ ! -d "$BASEPATH/lib" ]; then # TODO: is this ok? idk
		ls -Zla "$BASEPATH" >"$MODDIR/log.txt"
		ls -Zla "$BASEPATH/lib" >>"$MODDIR/log.txt"
	else rm "$MODDIR/log.txt" >/dev/null 2>&1; fi
	VERSION=$(dumpsys package "$PKG_NAME" | grep -m1 versionName) VERSION="${VERSION#*=}"
	if [ "$VERSION" != "$PKG_VER" ] && [ "$VERSION" ]; then
		err "version mismatch (installed:${VERSION}, module:$PKG_VER)"
		return
	fi
	grep "$PKG_NAME" /proc/mounts | while read -r line; do
		mp=${line#* } mp=${mp%% *}
		umount -l "${mp%%\\*}"
	done
	if ! chcon u:object_r:apk_data_file:s0 "$RVPATH"; then
		err "apk not found"
		return
	fi
	mount -o bind "$RVPATH" "$BASEPATH/base.apk"
	am force-stop "$PKG_NAME"
	[ -f "$MODDIR/err" ] && mv -f "$MODDIR/err" "$MODDIR/module.prop"
}

run
=======
	BASEPATH=$(pm path $PKG_NAME)
	svcl=$?
	[ $svcl = 20 ]
do sleep 2; done
sleep 5

err() {
	[ ! -f "$MODDIR/err" ] && cp "$MODDIR/module.prop" "$MODDIR/err"
	sed -i "s/^des.*/description=⚠️ Needs reflash: '${1}'/g" "$MODDIR/module.prop"
}

if [ $svcl != 0 ]; then
	err "app not installed"
	exit
fi
<<<<<<< HEAD
>>>>>>> 71b9976 (Initial commit)
=======
BASEPATH=${BASEPATH##*:} BASEPATH=${BASEPATH%/*}
if [ ! -d "$BASEPATH/lib" ]; then
	err "system force-rebooted (fix your ROM)"
	exit
fi
VERSION=$(dumpsys package "$PKG_NAME" | grep -m1 versionName) VERSION="${VERSION#*=}"
if [ "$VERSION" != "$PKG_VER" ] && [ "$VERSION" ]; then
	err "version mismatch (installed:${VERSION}, module:$PKG_VER)"
	exit
fi
grep "$PKG_NAME" /proc/mounts | while read -r line; do
	mp=${line#* } mp=${mp%% *}
	umount -l "${mp%%\\*}"
done
if ! chcon u:object_r:apk_data_file:s0 "$RVPATH"; then
	err "apk not found"
	exit
fi
mount -o bind "$RVPATH" "$BASEPATH/base.apk"
am force-stop "$PKG_NAME"
[ -f "$MODDIR/err" ] && mv -f "$MODDIR/err" "$MODDIR/module.prop"
>>>>>>> fb4e301 (customize.sh and service.sh updated)

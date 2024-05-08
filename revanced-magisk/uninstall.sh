#!/system/bin/sh
{
	MODDIR=${0%/*}
<<<<<<< HEAD
	. "$MODDIR/config"

	rm "/data/adb/rvhc/${MODDIR##*/}.apk"
	rmdir "/data/adb/rvhc"
	rm "/data/adb/post-fs-data.d/$PKG_NAME-uninstall.sh"
=======
	rm "$NVBASE/rvhc/${MODDIR##*/}".apk
	rmdir "$NVBASE/rvhc"
>>>>>>> 71b9976 (Initial commit)
} &

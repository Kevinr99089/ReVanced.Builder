# Config

Adding another revanced app is as easy as this:
```toml
[Some-App]
apkmirror-dlurl = "https://www.apkmirror.com/apk/inc/app"
# or uptodown-dlurl = "https://app.en.uptodown.com/android"
<<<<<<< HEAD
=======
# or apkmonk-dlurl = "https://www.apkmonk.com/app/com.app.app/"
>>>>>>> 71b9976 (Initial commit)
```

## More about other options:

There exists an example below with all defaults shown and all the keys explicitly set.  
**All keys are optional** (except download urls) and are assigned to their default values if not set explicitly.  

```toml
<<<<<<< HEAD
parallel-jobs = 1                    # amount of cores to use for parallel patching, if not set $(nproc) is used
compression-level = 9                # module zip compression level
remove-rv-integrations-checks = true # remove checks from the revanced integrations

patches-source = "revanced/revanced-patches" # where to fetch patches bundle from. default: "revanced/revanced-patches"
cli-source = "j-hc/revanced-cli"             # where to fetch cli from. default: "j-hc/revanced-cli"
# options like cli-source can also set per app
rv-brand = "ReVanced Extended" # rebrand from 'ReVanced' to something different. default: "ReVanced"

patches-version = "v2.160.0" # 'latest', 'dev', or a version number. default: "latest"
cli-version = "v5.0.0"       # 'latest', 'dev', or a version number. default: "latest"

[Some-App]
app-name = "SomeApp" # if set, release name becomes SomeApp instead of Some-App. default is same as table name, which is 'Some-App' here.
enabled = true       # whether to build the app. default: true
version = "auto"     # 'auto', 'latest', 'beta' or a version number (e.g. '17.40.41'). default: auto
build-mode = "apk"   # 'both', 'apk' or 'module'. default: apk

# optional args to be passed to cli. can be used to set patch options
# multiline strings in the config is supported
patcher-args = """\
  -OdarkThemeBackgroundColor=#FF0F0F0F \
  -Oanother-option=value \
  """

# 'auto' option gets the latest possible version supported by all the included patches
# 'latest' gets the latest stable without checking patches support. 'beta' gets the latest beta/alpha
# whitespace seperated list of patches to exclude. default: ""
excluded-patches = """\
  'Some Patch' \
  'Some Other Patch' \
  """

included-patches = "'Some Patch'"                          # whitespace seperated list of non-default patches to include. default: ""
include-stock = true                                       # includes stock apk in the module. default: true
exclusive-patches = false                                  # exclude all patches by default. default: false
apkmirror-dlurl = "https://www.apkmirror.com/apk/inc/app"
uptodown-dlurl = "https://spotify.en.uptodown.com/android"
module-prop-name = "some-app-magisk"                       # magisk module prop name.
apkmirror-dpi = "360-480dpi"                               # used to select apk variant from apkmirror. default: nodpi
arch = "arm64-v8a"                                         # 'arm64-v8a', 'arm-v7a', 'all', 'both'. 'both' downloads both arm64-v8a and arm-v7a. default: all
riplib = true                                              # enables ripping x86 and x86_64 libs from apks with j-hc revanced cli. default: true

=======
parallel-jobs = 1 # amount of cores to use for parallel patching, if not set nproc is used
patches-source = "revanced/revanced-patches" # where to fetch patches bundle from. default: "revanced/revanced-patches"
integrations-source = "revanced/revanced-integrations" # where to fetch integrations from. default: "revanced/revanced-integrations"
cli-source = "j-hc/revanced-cli" # where to fetch cli from. default: "j-hc/revanced-cli"
# options like cli-source can also set per app
rv-brand = "ReVanced Extended" # rebrand from 'ReVanced' to something different. default: "ReVanced"

patches-version = "v2.160.0" # locks the patches version. default: latest available
integrations-version = "v0.95.0" # locks the integrations version. default: latest available

[Some-App]
app-name = "SomeApp" # if set, release name becomes SomeApp instead of Some-App. default is same as table name, which is 'Some-App' here.
enabled = true # whether to build the app. default: true
version = "auto" # 'auto', 'latest', 'beta' or a custom one e.g. '17.40.41'. default: auto
# 'auto' option gets the latest possible version supported by all the included patches
# 'latest' gets the latest stable without checking patches support. 'beta' gets the latest beta/alpha
include-stock = true # includes stock apk in the module. default: true
build-mode = "apk" # 'both', 'apk' or 'module'. default: apk
excluded-patches = "'Some Patch' 'Some Other Patch'" # whitespace seperated list of patches to exclude. default: "" (empty)
included-patches = "'Patch something'" # whitespace seperated list of patches to include, all default patches are included by default. default: "" (empty)
exclusive-patches = false # exclude all patches by default. default: false
apkmirror-dlurl = "https://www.apkmirror.com/apk/inc/app"
uptodown-dlurl = "https://spotify.en.uptodown.com/android"
apkmonk-dlurl = "https://www.apkmonk.com/app/com.app.app/"
module-prop-name = "some-app-magisk" # magisk module prop name.
apkmirror-dpi = "360-480dpi" # used to select apk variant from apkmirror. default: nodpi
arch = "arm64-v8a" # 'arm64-v8a', 'arm-v7a', 'all', 'both'. 'both' downloads both arm64-v8a and arm-v7a. default: all
riplib = true # enables ripping x86 and x86_64 libs from apks with j-hc revanced cli. default: true
>>>>>>> 71b9976 (Initial commit)
```

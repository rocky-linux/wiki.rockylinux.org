---
title: Rocky Logos Package Guidelines
---

This page goes over the basic guidelines for the rocky-logos package, which produces assets for anaconda, wallpapers, and other assets for the distribution.

**Release Engineering has the final "go/no-go" decision on submissios/assets/images in the package.**

## Rocky Logo Assets

In various parts of the package, the Rocky logo will need to exist in multiple forms:

* Green variant
* White variant

This can be in the form of `PNG`, `JPG`, or `SVG` files.

### anaconda

All anaconda image assets will be in `PNG` form. Backgrounds should be transparent with the exception of `rnotes` if applicable.

### Backgrounds

See [Backgrounds Section](#Backgrounds/Wallpapers)

### fedora

`SVG` format of logo assets as `fedora_logo` (color) and `fedora_logo_darkbackground` (white), and a default as `fedora_logo`.

### firstboot

First boot assets. This is generally the sidebar (like the anaconda installer) and a workstation icon. `PNG` format.

### icons/hicolor

Rocky icons will appear here in different resolutions and must be in `PNG` or `SVG` format:

* 16x16/apps: `PNG`, `system-logo-icon`, `fedora-logo-icon`
* 22x22/apps: `PNG`, `system-logo-icon`, `fedora-logo-icon`
* 24x24/apps: `PNG`, `system-logo-icon`, `fedora-logo-icon`
* 32x32/apps: `PNG`, `system-logo-icon`, `fedora-logo-icon`
* 36x36/apps: `PNG`, `system-logo-icon`, `fedora-logo-icon`
* 48x48/apps: `PNG`, `system-logo-icon`, `fedora-logo-icon`
* 96x96/apps: `PNG`, `system-logo-icon`, `fedora-logo-icon`
* 256x256/apps: `PNG`, `system-logo-icon`, `fedora-logo-icon`
* scalable/apps: `SVG`, `fedora-logo-icon`, `org.fedoraproject.AnacondaInstaller.svg`, `start-here.svg`, `xfce4_xicon1.svg`
* symbolic/apps: `SVG`, `org.fedoraproject.AnacondaInstaller-symbolic`

### ipa

IPA specific assets, usually text. They are generally `PNG` or `JPG`:

* `header-logo.png` - Text
* `login-screen-background.jpg` - No text
* `login-screen-logo.png` - Logo + Text
* `product-name.png` - Text

### pixmaps

`PNG` format, these are usually assets used within GNOME, GDM, and other desktop environments.

### plymouth/charge

Typically unchanged and is for the plymouth loading screen

### svg

`SVG` format of logo assets as `fedora_logo` (color) and `fedora_logo_darkbackground` (white)

`color` file dictates background color if applicable

### testpage

`index.html` for httpd/nginx/etc

## Backgrounds/Wallpapers

### Structure

Wallpapers appear in `PNG` format with a backing `XML` file to list out all available resolutions if applicable, as well as defaults.

A defaults file looks at every other `XML` that is a default background provided by the backgrounds package and default options if applicable.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
    <wallpaper deleted="false">
        <name>Rocky Linux 9 Default Background - Placeholder Mesh</name>
        <filename>/usr/share/backgrounds/rocky-default-1-mesh.xml</filename>
        <options>zoom</options>
        <author>Louis Abel</author>
        <email>label@rockylinux.org</email>
        <license>CC-BY-SA 4.0</license>
    </wallpaper>
    <wallpaper deleted="false">
        <name>Rocky Linux 9 Default Background - Placeholder Target</name>
        <filename>/usr/share/backgrounds/rocky-default-1-target.xml</filename>
        <options>zoom</options>
        <author>Louis Abel</author>
        <email>label@rockylinux.org</email>
        <license>CC-BY-SA 4.0</license>
    </wallpaper>
</wallpapers>
```

The wallpaper itself will list every applicable variant of that background if applicable.

```
<background>
  <starttime>
    <year>2021</year>
    <month>10</month>
    <day>29</day>
    <hour>19</hour>
    <minute>21</minute>
    <second>19</second>
  </starttime>

<static>
<duration>10000000000.0</duration>
<file>
  <!-- Wide 16:9 -->
  <size width="1920" height="1080">/usr/share/backgrounds/rocky-default-1-mesh-16-9.png</size>
  <!-- Wide 16:10 -->
  <size width="1920" height="1200">/usr/share/backgrounds/rocky-default-1-mesh-16-10.png</size>
  <!-- Standard 4:3 -->
  <size width="2048" height="1536">/usr/share/backgrounds/rocky-default-1-mesh-4-3.png</size>
  <!-- Normalish 5:4 -->
  <size width="1280" height="1024">/usr/share/backgrounds/rocky-default-1-mesh-5-4.png</size>
</file>
</static>
</background>
```

Day/Night Wallpapers have a similar configuration.

```
<background>
  <starttime>
    <year>2022</year>
    <month>01</month>
    <day>01</day>
    <hour>8</hour>
    <minute>00</minute>
    <second>00</second>
  </starttime>
<!-- This animation will start at 8 AM. -->

<!-- We start with day at 8 AM. It will remain up for 10 hours. -->
<static>
<duration>36000.0</duration>
<file>/usr/share/backgrounds/rocky-default-1-mesh-day.png</file>
</static>

<!-- Day ended and starts to transition to night at 6 PM. The transition lasts for 2 hours, ending at 8 PM. -->
<transition type="overlay">
<duration>7200.0</duration>
<from>/usr/share/backgrounds/rocky-default-1-mesh-day.png</from>
<to>/usr/share/backgrounds/rocky-default-1-mesh-night.png</to>
</transition>

<!-- It's 8 PM, we're showing the night till 6 AM. -->
<static>
<duration>36000.0</duration>
<file>/usr/share/backgrounds/rocky-default-1-mesh-night.png</file>
</static>

<!-- It's 6 AM, and we're starting to transition to day. Transition completes at 8 AM. -->
<transition type="overlay">
<duration>7200.0</duration>
<from>/usr/share/backgrounds/rocky-default-1-mesh-night.png</from>
<to>/usr/share/backgrounds/rocky-default-1-mesh-day.png</to>
</transition>

</background>
```

### Guidelines

This section goes over the general guidelines for the main backgrounds included in the distribution.

**Note**: It is **highly recommended and encouraged** that a submission should be the highest resolution as noted below. See the [note](#minimum-resolutions) on minimum resolutions.

* **General Theme**: Each Rocky release has a codename, and thus is the general theme. Examples.
    * Rocky 8: `Green Obsidian` - Submissions only to extras
    * Rocky 9: `Blue Onyx` - This should be generally a blue theme/color scheme. Submissions only to extras.
    * Rocky 10: `Red Quartz` - This should be generally a red-like theme/color scheme
* **Required Resolution(s) for Normal Submissions**:
    * Resolution must **not** exceed nor fall below: 4092x3072

* **Allowed**:
    * Anything related to nature, mountains, rocks, and the like (generally fitting into the "rocky" idea)
    * Anything related to the codename (eg. Blue Onyx)
    * Anything minimalist/abstract is allowed
    * References to the release number (like 9, and so on) are allowed
    * Complementary colors should be allowed in the image within reason
    * Contrasting colors should be allowed in the image within reason
    * Photography + Manipulation should be allowed within reasonG
    * **Highly Encouraged**: [Day](https://github.com/fedoradesign/backgrounds/raw/f34-backgrounds/default/f34-01-day.png) and [Night](https://github.com/fedoradesign/backgrounds/raw/f34-backgrounds/default/f34-02-night.png) versions of wallpapers

* **Discouraged**:
    * Avoid using the Rocky logo, unless it fits with an abstract/minimalist idea for the background
        * Plain backdrops with the rocky logo are *not* permitted

#### Minimum Resolutions

For general submissions, we require the highest resolution to make things simpler, that way the user should be able to use a wallpaper without having to choose "the right one" for their monitor size. However, for the case case of extra backgrounds, this requirement is more relaxed. If a submitter wishes not to use the highest resolution but opts to make multiple resolutions instead, they should follow the below list:

* **Minimum Required Resolutions**:
    * 16:9 (1920x1080)
    * 16:10 (1920x1200)
    * 5:4 (2048x1536)
    * 4:3 (1280x1024)
* **Additional (encouraged) allowed resolutions**:
    * 3440x1440
    * 2560x1600
    * 2560x1440
    * 2560x1080
    * 1800x1440
    * Portrait mode versions of the above are optional

The placeholders in [this commit](https://github.com/rocky-linux/rocky-logos/tree/962a836f70a131faa541a4f8f73a4a3fddfc3dbf/backgrounds) shows an example of using the minimum resolutions.

### Extras Package

If a wallpaper does not make it to the main package (whether it doesn't meet guidelines or is simply just Rocky inspired), they should be able to be submitted for addition into the `rocky-backgrounds-extras` package.

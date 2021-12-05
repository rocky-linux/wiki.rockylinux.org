---
title: Rocky Logos Package Guidelines
---

This page goes over the basic guidelines for the rocky-logos package, which produces assets for anaconda, wallpapers, and other assets for the distribution.

## Rocky Logo Assets

In various parts of the package, the Rocky logo will need to exist in multiple forms:

* Green variant
* White variant

This can be in the form of `PNG`, `JPG`, or `SVG` files.

### anaconda

All anaconda image assets will be in `PNG` form. Backgrounds should be transparent with the exception of `rnotes` if applicable.

### Backgrounds

See next major section.

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
`````

The wallpaper itself will list every applicable variant of that background.

`````
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
`````

### Guidelines
Main backgrounds should follow these guidelines:

* **General Theme**: Each Rocky release has a codename. As such, that is the general theme.
  * Rocky 8: ```Green Obsidian`
  * Rocky 9: `Blue Onyx` - This should be generally a blue theme/color scheme
* Initial submission should be a high resolution and/or required resolutions
* **Resolutions**
  * Minimum Required Resolutions: 16:9 (1920x1080), 16:10 (1920x1200), 5:4 (2048x1536), 4:3 (1280x1024)
  * Additional (encouraged) allowed resolutions: 3440x1440, 2560x1600, 2560x1440, 2560x1080, 1800x1440
  * Portrait mode versions of the above are optional

* Allowed:
  * Anything related to nature, mountains, rocks, and the like (generally fitting into the "rocky" idea)
  * Anything related to the codename (Blue Onyx)
  * Anything minimalist is allowed
  * Abstract ideas are allowed
  * References to the release number (like 9, and so on) are allowed
  * Complementary colors are allowed in the image within reason
  * Contrasting colors are allowed in the image within reason
  * **Highly Encouraged**: [Day](https://i.imgur.com/L2EvweR.png) and [Night](https://i.imgur.com/j0l5PWA.png) versions of wallpapers

* Discouraged:
    * Avoid using the Rocky logo, unless it fits with an abstract/minimalist idea for the background
      * Plain backgrounds with the rocky logo are *not* permitted

### Extras Package

If a wallpaper does not make it to the main package (whether it doesn't meet guidelines or is simply just Rocky inspired), they can be submitted to be added into the `rocky-backgrounds-extras` package.

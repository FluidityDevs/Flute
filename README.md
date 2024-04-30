# Flute & Flair
Flute is a bootable Windows PE environment with a multi tool batch script, Flair, included, using the bootscreen command prompt exploit. You only need Flute and its bootable environment for systems with a nonfunctional administrator account, which Flair can assist in unlocking.
Flair contains various tools and is a suitable standalone batch script to do various system patches.

Flute is based on [Flow](https://github.com/FluidityDevs/Flow), which is based on the 2023 Windows 11 ADK with Windows PE 2022 plugins. Flute additionally is bundled with [flowd](https://github.com/FluidityDevs/flowd) to be used as an optional persistence agent to retain Flair's settings.

**How to build:**

*Prerequisites:*
- Windows Assessment and Deployment Kit, with the Windows PE add-on (available from Microsoft's website)
- A x64 Windows computer, for building and usage
- Rufus, from https://rufus.ie (Optional, useful for flashing a USB device)
- DISM GUI (Optional, you can use the CLI instead, I just like it for modifying the Flute WIM file)

*Instructions (ISO):*

Start the Deployment and Imaging Tools Environment as an Administrator

Run `MakeWinPEMedia /ISO <Directory for Source> <Directory for Output Image>.iso`

This is all you need to build Flute from source code to an ISO file.

*Instructions (USB, from source):*

Start the Deployment and Imaging Tools Environment as an Administrator

Run `MakeWinPEMedia /USB <Directory for Source> <Drive Letter>`

This is all you need to compile Flow directly to a USB device.

*Instructions (USB, from ISO, Recommended):*
1. Download and run Rufus
2. Select your USB device and drag in the ISO file you either downloaded or compiled earlier
3. Select "Show advanced format options"
4. Uncheck "Create extended label and icon files", Flute already includes these
5. Press start and confirm writing in ISO image mode
   
This is the simplest and recommended way to set up a USB drive with Flute installed, assuming you don't have the Windows ADK, don't want to compile it from source, or just want the easiest solution of downloading the ISO.

Flute and Flair are free to use by absolutely anyone. You just have to build, flash, or burn it yourself.

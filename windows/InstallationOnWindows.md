# Chvdocker installation on Microsoft Windows

<small>Back to [chvdocker](../README.md).<small>

## Instructions

We recommend installation via the Chocolatey package manager.  (more at https://chocolatey.org/)

We test installation on Windows 7 and Windows 8, on machines with no installed versions of vagrant, virtualbox, or docker, you probably want to [customize the installation scripts](#customizing-installation-scripts) first.

### Obtaining Chocolatey

Run powershell as Administrator.  Then:

      Set-ExecutionPolicy Unrestricted
Answer yes to the prompt.  Now install chocolatey:

      iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

### Install

Finally, install the chvdocker dependencies.  Note that the chocolatey packages are mostly GUI installers with automation, and will show some residual user interface.  Make sure not to click any GUI elements during installation.

      # install programs:
      install_dependencies.ps1

## Notes

### Known issues

The install_dependencies.ps1 goes to effort to work around a bit of a mess with Virtualbox installation:

- The Chocolatey Virtualbox installer does not provide an obvious means to installation as "All users".
- The Chocolatey Virtualbox installer adds to the current user a 8.3-style path, which will break in msysgit path translation.
- Installing virtualbox extensions after virtualbox will fail unless the shell has been restarted to take new path settings.
- Even upon successful install, Virtualbox Guest Extensions will look like it failed.

So install_dependencies.ps1 performs:

- Addition to the "all users" path between Virtualbox and Virtualbox Guest Extensions, if the addition is not present.
- Prompt to the user to expect a message that looks like failure but is success.

### Installing over RDP

Installing virtualbox over RDP will reset all network adapters, thereby temporarily dropping your RDP connection.  This is expected behavior.

## Customizing Installation Scripts

We test installation on Windows 7 and Windows 8, on machines with no installed versions of vagrant, virtualbox, or docker, you probably want to customize these.

Version configuration:

- [packages.config](packages.config)
- [packages2.config](packages2.config)

Script:

- [install_dependencies.ps1](install_dependencies.ps1)

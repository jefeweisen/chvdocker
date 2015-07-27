
# Chvdocker installation on Mac OS X

<small>Back to [chvdocker](../README.md).<small>

## Instructions

We test on Mac OS 10.10 Yosemite.

We recommend installation via Homebrew.  For instructions on getting homebrew, see:

- http://brew.sh/

Installing docker:

      brew tap homebrew/versions
      brew update
      brew install homebrew/versions/docker162

Installing vagrant and virtualbox:

      brew install caskroom/cask/brew-cask
      brew tap caskroom/versions
      brew cask install vagrant163
      brew cask install virtualbox431293733

Virtualbox and Virtualbox guest additions are one installer on OS X, whereas on Windows they are two separate installers.

## Experimenting with other versions:

The above versions are tested, and recommended.  To try others, this is how you can find them:

      brew search docker
      brew cask search vagrant
      brew cask search virtualbox

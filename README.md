[![Gem Version](https://badge.fury.io/rb/byepry.svg)](https://badge.fury.io/rb/byepry)
[![GitHub version](https://badge.fury.io/gh/elkesrio%2Fbyepry.svg)](https://badge.fury.io/gh/elkesrio%2Fbyepry)

# byepry
A simple ruby gem that delete all the lines that contain 'binding.pry'
## Introduction
Once you start using Pry, you just can't live without it. But it's also a pain in the neck to manually remove all the break points you put, especially when the project is big and the break points are in multiple files. <b>Byepry</b> is a simple gem that drops all the lines that contain `binding.pry` with a single command line.

## Installation
Run `gem install byepry`

## How to use ?
1) In your terminal, go to the root of your project.
2) Run `byepry`
3) Enjoy :D

## Options
Use the `-i` to ignore the commented lines. (It will only remove the non commented lines that contains `binding.pry`)

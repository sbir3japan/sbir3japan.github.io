# Corda Guide (under construction)
[![github pages](https://github.com/sbir3japan/sbir3japan.github.io/actions/workflows/gh-pages.yml/badge.svg)](https://github.com/sbir3japan/sbir3japan.github.io/actions/workflows/gh-pages.yml)

This is a version of Corda Guide by SBI R3 Japan based on Hugo. It is not the official Corda Guide, which can be found [here](https://support.sbir3japan.co.jp/hc/ja).

## Theme

The theme in use is [Docsy](https://example.docsy.dev/).
You can find detailed theme instructions in the Docsy user guide: https://docsy.dev/docs/.

The theme is included in this project as a Git submodule:

```bash
▶ git submodule
 a053131a4ebf6a59e4e8834a42368e248d98c01d themes/docsy (heads/master)
```

If you want to do SCSS edits and want to publish these, you need to install `PostCSS`

## Instructions
You can read detailed instructions in the [usage docs](/usage-docs/README.md).

Please read them!

You will need:

* [hugo](https://github.com/gohugoio/hugo/releases)  (a single binary on all platforms)
    * Use the latest **extended** version
* [npm](https://nodejs.org/en/download/) 
* a text editor: we strongly recommend [Visual Studio Code](https://code.visualstudio.com/).

## Quick Start

* Download [hugo](https://github.com/gohugoio/hugo/releases) and [npm](https://nodejs.org/en/download/)  
* clone this repo
* `cd` into the root of the repo and run `./build.sh`
* edit the markdown in `content/ja`
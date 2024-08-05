# homebrew-azpainter

[![Build Status](https://travis-ci.com/abcang/homebrew-azpainter.svg?branch=master)](https://travis-ci.com/abcang/homebrew-azpainter)

Original repository: [https://gitlab.com/azelpg/azpainter](https://gitlab.com/azelpg/azpainter)

## Install

```bash
brew install xquartz
brew tap abcang/azpainter
brew install azpainter
ln -sf $(brew --prefix azpainter)/AzPainter.app /Applications/
```

## Development

```bash
brew install --build-from-source --debug Formula/azpainter.rb
```

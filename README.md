# brightness-cli

A small command-line utility for macOS that prints the current brightness of the main display as a percentage. It supports both Apple Silicon and Intel Macs.

## Installation

Install with Homebrew:

```bash
brew tap efeligne/tools
brew install brightness-cli
```

## Usage

```bash
brightness-cli
```

The utility prints an integer from 0 to 100 without a `%` sign:

```text
75
```

If the brightness level cannot be determined, it prints `0`.

You can use the output in shell scripts:

```bash
brightness=$(brightness-cli)
echo "Display brightness: ${brightness}%"
```

## Building from source

Requirements: macOS 12 or later and Swift 6.1 or later.

```bash
make build
```

The executable is written to `.build/apple/Products/Release/brightness-cli`:

```bash
./.build/apple/Products/Release/brightness-cli
```

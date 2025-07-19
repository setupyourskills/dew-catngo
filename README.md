# Dew CatnGo

🌿 **Dew CatnGo** is a minimal, focused [Neorg](https://github.com/nvim-neorg/neorg) extension designed to streamline note selection based on categories.

This module is part of the [Neorg Dew](https://github.com/setupyourskills/neorg-dew) ecosystem.

## Features

- Enables selection of notes filtered by a pre-chosen category.
- Lightweight and easily customizable.

## Installation

### Prerequisites

- A functional installation of [Neorg](https://github.com/nvim-neorg/neorg) is required for this module to work.
- The core module [Neorg Dew](https://github.com/setupyourskills/neorg-dew) must be installed, as it provides essential base libraries.
- [neorg-query](https://github.com/benlubas/neorg-query) — this module is used internally to extract note metadata such as categories and titles.

### Using Lazy.nvim

```lua
{
  "setupyourskills/dew-catngo",
  dependencies = {
    "setupyourskills/neorg-dew",
    "benlubas/neorg-query"
  },
}
```

## Configuration

Make sure all of them are loaded through Neorg’s module system in your config:

```lua
["external.neorg-dew"] = {},
["external.neorg-query"] = {},
["external.dew-catngo"] = {
    config = {
        exclude_cat_prefix = "#", -- all categories prefixed by "#" will be ignored
    },
},
```

## Usage

You can launch the filtered or full category-based note picker using the built-in Neorg command with arguments:

```
:Neorg dew_catngo excluded
:Neorg dew_catngo full
```

## How it works

1. A Telescope picker opens with the list of all categories.

2. After choosing a category, a second picker appears showing all notes from that category.

3. Selecting a note opens it immediately in a new buffer.

## Collaboration and Compatibility

This project embraces collaboration and may build on external modules created by other Neorg members, which will be tested regularly to ensure they remain **functional** and **compatible** with the latest versions of Neorg and Neovim.  

## Why **dew**?

Like morning dew, it’s **subtle**, **natural**, and brief, yet vital and effective for any workflow.

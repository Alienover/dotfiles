#! /usr/bin/env python
# -*- coding:utf-8 -*-

import os
from urllib.request import urlopen

c = c  # noqa # pyright: ignore[reportUndefinedVariable]
config = config  # noqa # pyright: ignore[reportUndefinedVariable]

filepath = config.configdir / "catppuccin.py"
if not os.path.exists(filepath):
    theme = "https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py"
    with urlopen(theme) as content:
        with open(filepath, "a") as file:
            file.writelines(content.read().decode("utf-8"))

if os.path.exists(filepath):
    import catppuccin

    catppuccin.setup(c, "mocha", True)

# Chocolatey Package for FoxDot
This repo hosts code for Chocolatey package related to the FoxDot live-coding environment.

**WARNING:** This package overwrites your `startup.scd` file. If you are already using SuperCollider, make a backup of your `startup.scd` file before installing foxdot.

## FoxDot Installation

Make sure you have Chocolatey installed. See https://chocolatey.org for more information.

1. Run Windows PowerShell with admin privileges, and then execute this command:

```bash
choco install foxdot --version 0.0.1
```

## Run FoxDot

1. Start SuperCollider  
  *FoxDot.start is already on your startup.scd file*

2. Open FoxDot
  *There is a FoxDot shortcut on Desktop * =)

3. Start livecoding!
  ```python
  ## type and put your cursor on this code, then Ctrl+Enter
  p1 >> play("x-o-")
  ```

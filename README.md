# System Programming

These is the source code from the lecture "System Programming" at DHBW Mannheim.

## Prerequisites

You have to install [Dosbox](https://www.dosbox.com) and [NASM](https://nasm.us).
In case you use macOS, you can install NASM via brew: `brew install nasm`.

You need to mount the `mount/` directory in Dosbox. To do so, open the
configuration file of your Dosbox installation. On macOS, it is
`~/Library/Preferences/DOSBox\ 0.74-3-3\ Preferences`. Scroll to the bottom of
the file and copy the absolute path tp `mount/` in the `autoexec` section:

```ini
[autoexec]
mount x: "/path/to/mount"
x:
```

## Compile Code

If you have mounted `mount/` in Dosbox, you want your binaries to be placed in
that directory. So compile them by using:

```sh
nasm src/FILE.ASM -o mount/FILE.exe
```

## Project Structure

- `assembly-instructions.md`: Documentation of the assembly instructions we use in the lecture.
- `debug-instructions.md`: List of the instructions `mount/debug.exe` provides.
- `src/`: The source files.
- `mount/`: Mount path in DOSBox. Place your binaries here.

# PyWrap / RWrap — Installation Guide (April 2025)

> ⚠️ Requires the **Swift 6 toolchain (or Xcode 16 beta)**.  Earlier Swift versions lack macro support.

---

## 1 Common prerequisites

| Dependency | macOS 14 (Sonoma) | Ubuntu 22.04 | Windows 11 (WSL or native) |
|------------|------------------|--------------|-----------------------------|
| **Swift 6 nightly** | Xcode 16 beta (developer.apple.com → More Downloads) | `wget https://download.swift.org/.../swift-6.0-DEVELOPMENT-ubuntu22.04.tar.gz` ⇒ extract `/opt/swift` & add to `$PATH` | Download `.zip` from swift.org ⇒ add `bin` to `%Path%` |
| **Python ≥ 3.10** | `brew install python@3.12` | `sudo apt install python3 python3-pip` | MS Store Python or `winget install Python.Python.3` |
| **R ≥ 4.3** | `brew install r` | `sudo apt install r-base r-base-dev` | `winget install r-project.r` |
| **NumPy / pandas / PyTorch (optional)** | `python3 -m pip install numpy pandas torch` | same | same |

### Environment variables

| Variable | Purpose |
|----------|---------|
| `PYTHON_LIBRARY` | Absolute path to **shared** `libpython3.x.{dylib|so|dll}` you want to embed.  Omit if it’s on the linker’s default search path. |
| `LD_LIBRARY_PATH` / `%Path%` | Must include directory containing `libR` (`libR.dylib`, `libR.so`, `R.dll`). |

**Conda users**: simply `conda activate myenv` → `export PYTHON_LIBRARY=$CONDA_PREFIX/lib/libpython3.12.so` (Linux) or `.dylib` (macOS).

---

## 2 Clone & build

```bash
git clone https://github.com/<you>/PyWrap.git
cd PyWrap
swift build            # compiles runtime + macros + C shim
swift run Example      # runs demo → prints NumPy mean & R summary
```

> If you see `dlopen libpython… failed`, set `PYTHON_LIBRARY` to the exact path printed by `python -c "import sysconfig,sys; print(sysconfig.get_config_var('LIBDIR'))"`.

---

## 3 Add/Remove wrappers

* **Python**: edit `Modules.wrap` (CSV lines `module,class`).
* **R**      : edit `RModules.wrap` (CSV lines `package,function`).

```bash
echo "torch,Tensor"      >> Modules.wrap   # add PyTorch tensor
echo "graphics,plot"     >> RModules.wrap  # add R base plot
swift build   # plugins regenerate wrappers automatically
```

---

## 4 Using Conda or mamba

```bash
conda create -n swift-py python=3.12 numpy pandas
conda activate swift-py
export PYTHON_LIBRARY=$CONDA_PREFIX/lib/libpython3.12.so   # .dylib on macOS
swift run Example
```

The build will now link against the interpreter inside that environment; any wheels you `pip install` there become visible to PyWrap.

---

## 5 iOS / visionOS app embedding

1. Open `Package.swift` in Xcode 16.
2. Add a new App target that depends on `PyWrapRuntime` & `RWrapRuntime`.
3. Drag your **arm64** `libpython` and `libR` plus wheel `.so` files into “Copy Bundle Resources”.
4. Write SwiftUI code using typed wrappers.
5. Archive; App Store review is fine (interpreters are bundled, not downloaded).

---

## 6 Troubleshooting

| Error | Fix |
|-------|-----|
| `undefined symbol: PyLong_FromLong` | You linked against a **static** Python build. Install a shared build or Conda’s python. |
| `library not loaded: libR.dylib` | Add R’s `lib` path to `DYLD_FALLBACK_LIBRARY_PATH` (macOS) or `LD_LIBRARY_PATH` (Linux). |
| Windows – `python312.dll not found` | Copy `python312.dll` from `%CONDA_PREFIX%\Library\bin` next to the executable or add that directory to `%Path%`. |
| Swift build fails on macros | Ensure the *same* Swift 6 snapshot is on both `swift` CLI and Xcode (if you switch). |

---

You’re ready—enjoy a single Swift binary orchestrating Python, R and GPU code.  If something breaks, open an issue or PR on GitHub!

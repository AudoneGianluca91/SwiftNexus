# PyWrap / RWrap — Developer Documentation

## 1 Project layout

```
PyWrap/
├─ Package.swift                  – SwiftPM workspace
├─ Modules.wrap                   – Python modules to wrap (CSV lines)
├─ RModules.wrap                  – R packages / functions to wrap
└─ Sources/
   ├─ PyWrapRuntime/              – Swift helpers on top of PythonKit
   ├─ PyWrapMacro/                – @pywrap macro
   ├─ PyWrapGenerator/            – build‑tool plugin (Python wrappers)
   ├─ RWrapRuntime/               – Swift helpers around libR
   ├─ RWrapMacro/                 – @rwrap macro
   ├─ RWrapGenerator/             – build‑tool plugin (R wrappers)
   ├─ CShims/ rshim.c             – minimal C bridge to libR
   └─ Example/                    – demo program
```

The **Generator plugins** create `GeneratedWrappers.swift` files during the build so you never touch source code when adding a new wrapper.

* Add a Python wrapper: `echo "torch,Tensor" >> Modules.wrap`
* Add an R wrapper:    `echo "graphics,plot" >> RModules.wrap`

Re‑build and the new typed façades appear automatically.

## 2 Key concepts

| Layer | Purpose |
|-------|---------|
| `PyWrapRuntime` | Dynamic interface (`PyValue`) + bridging helpers. |
| `PyWrapMacro`   | Turns `@pywrap(module:"numpy", name:"array")` into a Swift struct. |
| `RWrapRuntime`  | Dynamic interface (`RValue`) + bridging helpers. |
| `RWrapMacro`    | Turns `@rwrap(package:"stats", name:"lm")` into a Swift struct. |
| Generator plugins | Read wrapper list → emit Swift code before every build. |
| `CShims/rshim.c`  | Embeds libR; exposes `rwrap_eval()` and `rwrap_init()`. |

## 3 Extending the macro

### Read Python `.pyi` stubs → generate method signatures

1. Within `PyWrapGenerator`, spawn `python -m stubgen <module>`.
2. Parse the resulting stub with SwiftSyntax or simple regex.
3. Emit additional functions in the generated struct (e.g. `.dot`, `.sum(axis:)`).

### Read R `.Rd` docs → generate signatures

1. call `R CMD Rdconv --type=json stats::lm` (R 4.5 provides JSON output).
2. Translate parameter list into Swift methods.

## 4 Zero‑copy data interchange

*Python NumPy ↔ Swift*: `PyArray_SimpleNewFromData` wraps a Swift `UnsafeMutablePointer` as a NumPy array without copying.

*R numeric vector ↔ Swift*: `Rf_allocVector(REALSXP, n)` allocates in R; `REAL()` gives a raw pointer to use in Swift.  Manage lifetimes with R `PROTECT` / `UNPROTECT`.

## 5 Concurrency

* Build with CPython 3.13 **free‑threaded** (`--disable-gil`). Set `PYTHON_LIBRARY` to that build and PyWrap allows concurrent Swift `Task { … }` calls into Python.
* Swift actors can safely interact with R because `libR` is single‑threaded—gate calls behind an actor.

---

Happy hacking!  Contributions are welcome via pull requests.

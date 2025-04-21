# SwiftNexus
SwiftNexus – A Swift 6 toolkit for calling Python and R libraries with typed, zero‑copy wrappers.

Orignially named PyWrap this is a completely AI built project. It is something that was in my head for a long time and I gave it a try using LLMs. I decided to publish it just in case I thought about something nice. It is completely untested. So, might contain bugs and might not work at all. Show it some love and it will surely love you back!

Thank you

# PyWrap 🔗 RWrap

> **Swift‑native façades for the entire Python *and* R ecosystems — with zero‑copy data, GPU hooks, and Swift 6 macros.**

|  |  |
|--|--|
| **Status** | MVP + Hardening baseline (April 2025) |
| **Platforms** | macOS 14 · Linux 22.04 · Windows 11 · iOS 17 (bundle interpreters) |
| **License** | MIT |

![architecture diagram](https://raw.githubusercontent.com/your/PyWrap/assets/arch.svg)

PyWrap embeds CPython and R inside a single Swift binary, then uses Swift 6 macros to generate **typed wrappers** so NumPy, pandas, PyTorch, and R `stats` feel like native Swift modules — while sharing the *same* memory buffers and optional GPU back‑ends.

---

## ✨ Key Features

* **One process, three languages** – Swift owns `main()`, Python & R are embedded libraries.
* **`@pywrap` / `@rwrap` macros** – turn a single annotation into a fully typed Swift façade.
* **Zero‑copy** – NumPy `ndarray` ↔ Swift pointer ↔ Metal/CUDA buffer ↔ R numeric vector.
* **GPU scaffold** – enum abstraction for Metal (Apple), CUDA (Linux/Win), Vulkan/WebGPU (future).
* **Installer scripts** – create a Conda env, set `PYTHON_LIBRARY`, build wheel / CRAN package.
* **Free‑threaded CPython ready** – script to compile no‑GIL 3.13 branch for parallel Swift actors.

---

## 🚀 Quick Demo

```bash
git clone https://github.com/your/PyWrap.git
cd PyWrap
bash scripts/install.sh           # installs Miniconda + env
source pywrap_env.sh
swift run Example/full_demo       # Python + R + GPU one‑shot demo
```

On Windows PowerShell:

```powershell
.\scripts\install.ps1
pywrap_env.cmd
swift run Exampleull_demo.swift
```

---

## 📚 Documentation & Guides

| File | Purpose |
|------|---------|
| **docs/documentation.md** | Architecture, zero‑copy details, GPU enum |
| **docs/install.md** | Step‑by‑step install for macOS, Linux, Windows, Conda, iOS |
| **scripts/** | Installers, packaging builders, stub‑to‑Swift helper |

---

## 🛣 Roadmap (stretch‑phase)

| Goal | ETA | Status |
|------|-----|--------|
| Full stub‑driven method generation (`stub2swift` integrated) | Q3 2025 | 🔜 MVP helper script done |
| Dynamic protocol conformance (duck‑types satisfy Swift protocols) | Q4 2025 | 📝 pitch drafting |
| Unified Jupyter kernel (`%%swift`, `%%python`, `%%R`) | Q1 2026 | ⬜ planned |
| GPU backend abstraction (Metal/CUDA/Vulkan/WebGPU parity) | 2025‑26 | ⬜ planned |

Want to help?  Open an issue or a pull request!

---

© 2025 PyWrap contributors — released under the MIT License.

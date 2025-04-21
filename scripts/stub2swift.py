#!/usr/bin/env python3
"""Generate Swift methods from a .pyi stub for a single class.

Usage:
    python stub2swift.py numpy __init__.pyi ndarray > ndarray_methods.swift
"""
import re, sys, pathlib, textwrap

module = sys.argv[1]
stub   = pathlib.Path(sys.argv[2])
cls    = sys.argv[3]

pattern = re.compile(rf'class\s+{cls}\b[\s\S]*?^class', re.MULTILINE)
text = stub.read_text()
m = pattern.search(text + "\nclass")  # sentinel
block = m.group(0) if m else ""
methods = re.findall(r'def\s+(\w+)\(.*?\):', block)

def emit(name):
    if name.startswith('_'): return ""
    swift = f"""    public func {name}(_ args: PythonConvertible...) -> PyValue {{
        let tuple = Python.tuple(args.map {{ PythonObject($0) }})
        return PyValue(_py.{name}(tuple))
    }}\n"""
    return swift

out = "extension " + cls + " {\n"
out += "".join(emit(n) for n in methods[:20])  # limit for brevity
out += "}\n"
print(out)

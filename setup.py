from setuptools import setup, Extension
setup(
    name='pywrap',
    version='0.1.0',
    ext_modules=[Extension('pywrap', sources=[])],
    py_modules=['pywrap'],
)

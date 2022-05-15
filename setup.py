# -*- coding: utf-8 -*-
"""

Created on Fri Apr  8 10:43:51 2022

@author: florianma
check https://cython.readthedocs.io/en/latest/
Anaconda prompt:
$ net use U: \\files.ad.ife.no\MatPro_files\Florian\Repositoties
$ cd ./GridInterpolator
$ python setup.py build_ext --inplace

$ cd C:/Users/florianma/Anaconda3
$ python //files.ad.ife.no/MatPro_files/Florian/Repositoties/GridInterpolator/setup.py build_ext --inplace
generates c:/users/florianma/anaconda3/gram_matrix.cp38-win_amd64.pyd
and //files.ad.ife.no/MatPro_files/Florian/Repositoties/gram/gram_matrix.c

$ cd C:/Users/florianma/Anaconda3/Scripts
$ cython -a //files.ad.ife.no/MatPro_files/Florian/Repositoties/gram/gram_matrix.pyx
generates //files.ad.ife.no/MatPro_files/ \
    Florian/Repositoties/gram/gram_matrix.html
"""
# import gmsh
from setuptools import setup
from setuptools.command.sdist import sdist as _sdist
from setuptools.extension import Extension
from setuptools import find_packages
from Cython.Build import cythonize
from Cython.Distutils import build_ext
import sys
import os
import numpy as np
print(os.getcwd())  # 'C:\\Users\\florianma\\Anaconda3
print('Compiling Cython modules from .pyx sources.')
sources = ["src/gridinterpolator/_grid_interpolator.pyx",
           "src/btwxt.cpp",
           "src/error.cpp",
           "src/griddeddata.cpp",
           "src/gridpoint.cpp"
           ]


class sdist(_sdist):
    """ Run 'cythonize' on *.pyx sources to ensure the .cpp files included
    in the source distribution are up-to-date.
    """

    def run(self):
        # from Cython.Build import cythonize
        cythonize(sources, language_level="2")
        _sdist.run(self)


cmdclass = {'sdist': sdist, 'build_ext': build_ext}

ext = Extension("gridinterpolator._grid_interpolator",
                sources=sources,
                language="c++",
                include_dirs=["src", np.get_include()],
                )
# FIXME: cant find README.md
needs_pytest = {'pytest', 'test'}.intersection(sys.argv)
pytest_runner = ['pytest_runner'] if needs_pytest else []
with open("README.md", "r", encoding='utf-8') as readme:
    long_description = readme.read()

setup(
    name='gridinterpolator',
    use_scm_version={"write_to": "src/gridinterpolator/_version.py"},
    description='Cython wrapper for the C++ library btwxt',
    long_description=long_description,
    long_description_content_type="text/markdown",
    author='Florian Arbes',
    author_email='florian.arbes@t-online.de',
    maintainer="Florian Arbes",
    maintainer_email="florian.arbes@t-online.de",
    license='MIT',
    url='https://github.com/flabowski',
    keywords=[
        'grid, interpolation, N-dimensional'],
    classifiers=[
        "Programming Language :: Python",
        "Programming Language :: Python :: 3",
        "Programming Language :: Cython",
        "Programming Language :: C++",
        "Environment :: Other Environment",
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Operating System :: OS Independent",
        "License :: OSI Approved",
        "License :: OSI Approved :: MIT License",
        "Topic :: Scientific/Engineering :: Mathematics",
        "Topic :: Software Development :: Libraries :: Python Modules"
    ],
    package_dir={"": "src"},
    packages=find_packages(where="src"),
    ext_modules=[ext],
    setup_requires=[
        'cython>=0.28',
        'setuptools_scm>=1.11.1',
    ] + pytest_runner,
    tests_require=['pytest'],
    cmdclass=cmdclass,
)


# dir_name = "//files.ad.ife.no/MatPro_files/Florian/Repositoties/gram/"
# setup(
#     name='Hello world app',
#     ext_modules=cythonize(dir_name+"gram_matrix.pyx"),
#     include_dirs=[np.get_include()],
#     zip_safe=False,
# )

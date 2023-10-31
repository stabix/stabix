# -*- coding: utf-8 -*-
import codecs
from setuptools import find_packages
from setuptools import setup


setup(
    name='PopIn_doc-build',
    version='3.0',
    author='David Mercier',
    author_email='david9684@gmail.com',
    url='https://popin.readthedocs.io',
    license='GPL',
    description='Build infrastructure for PopIn toolbox',
    packages=find_packages(),
    include_package_data=True,
    long_description=codecs.open("README.rst", "r", "utf-8").read(),
    install_requires=[
        "PyYAML>=3.0",
        "Sphinx>=1.5.2",
        "Docutils",
        "readthedocs-sphinx-ext",
        "recommonmark",
        "click>=4.0",
        "virtualenv",
        "six",
        "mock"
    ],
    entry_points={
        'console_scripts': [
            'rtd-build=readthedocs_build.cli:main',
        ]
    },
    zip_safe=True,
)

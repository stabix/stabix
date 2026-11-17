# -*- coding: utf-8 -*-
import codecs
from setuptools import find_packages
from setuptools import setup


setup(
    name='STABiX_doc-build',
    version='3.0',
    author='David Mercier',
    author_email='david9684@gmail.com',
    url='https://stabix.readthedocs.io',
    license='GPL',
    description='Build infrastructure for STABiX toolbox',
    packages=find_packages(),
    include_package_data=True,
    long_description=codecs.open("README.rst", "r", "utf-8").read(),
    install_requires=[
        "Sphinx>=7.4",
    ],
    entry_points={
        'console_scripts': [
            'rtd-build=readthedocs_build.cli:main',
        ]
    },
    zip_safe=True,
)

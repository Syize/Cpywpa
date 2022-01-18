from setuptools import Extension, setup, find_packages
from Cython.Build import cythonize

extra_compile_args = ['-D CONFIG_CTRL_IFACE', '-D CONFIG_CTRL_IFACE_UNIX']

ext_modules = [
    Extension(
        name="_cpywpa_core",
        sources=["Cpywpa/ccore/_cpywpa_core.pyx"],
        extra_compile_args=extra_compile_args
    )
]

setup(
    name="Cpywpa",
    version='1.0',
    description='Cpywpa is another simple tools to control wpa_supplicant. It use Cython to interact with OFFICIAL C '
                'interface',
    author='Syize',
    author_email='syizeliu@gmail.com',
    platforms='Linux',
    packages=find_packages(where='.', exclude=(), include=('*',)),
    requires=['Cython'],
    install_requires=['Cython'],
    ext_modules=cythonize(ext_modules),
    include_package_data=True
)

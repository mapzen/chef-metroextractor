from setuptools import setup, find_packages

setup(
    name = 'Metro-Extractor',
    version = '0.0.0',
    url = 'https://github.com/mapzen/chef-metroextractor',
    author = 'Michal Migurski',
    author_email = 'migurski@mapzen.com',
    description = '...',
    packages = find_packages(),
    entry_points = dict(
        console_scripts = [
        ]
    ),
    package_data = {},
    test_suite = 'metroextractor.tests',
    install_requires = [
        'requests == 2.11.1',
        'uritemplate == 3.0.0',
        ]
)

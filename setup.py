from setuptools import setup, find_packages

setup(
    name="pytelmbot",
    version="0.1.0",
    author="Telmtron Ltd.",
    author_email="create@telmtron.tech",
    description="A collection of utilities to use for automated embedded testing",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    url="https://github.com/yourusername/your-repo",
    packages=find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.7',
)

#!/bin/bash

mkdir -p ~/dist
cd pypi_small
for dir in */ ; do
    # Check if setup.py exists in the directory
    if [ -f "${dir}setup.py" ]; then
        echo "Processing ${dir}..."
        cd $dir
        # Run the Python setup command
        sudo python3 setup.py bdist_wheel
        # Copy the .whl file(s) to the dist directory in home
        cp dist/*.whl ~/dist/
        cd ..
    fi
done

sleep 100

echo "Done."
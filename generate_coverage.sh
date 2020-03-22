#!/usr/bin/env bash

# Generate coverage report
pub run test_coverage
# Exclude generated files from coverage report
pub run remove_from_coverage -f coverage/lcov.info -r 'interfaces.dart$' -r '.g.dart$' -r 'errors.dart$' -r 'exceptions.dart$'
# Generate a GUI representation of the coverage report
genhtml -o coverage coverage/lcov.info

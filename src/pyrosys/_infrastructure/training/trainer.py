"""
Infrastructure for training PyroSys based on Pytorch Lightning or Ray.

This module provides an unified interface for both Pytorch Lightning and Ray.
Users can choose to use either one of them by setting the `TRAINER` environment variable
or by default using Ray if it is available.
"""

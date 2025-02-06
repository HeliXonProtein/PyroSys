"""
Infrastructure for training PyroSys based on Pytorch Lightning or Ray.

This module provides an unified interface for both Pytorch Lightning and Ray.
Users can choose to use either one of them by setting the `TRAINER` environment variable
or by default using Ray if it is available.
"""

from typing import TYPE_CHECKING, Optional
import os

# Try to import ray, but if it fails, use Pytorch Lightning
try:
    import ray
    HAS_RAY = True
except ImportError:
    HAS_RAY = False

if HAS_RAY:
    import ray.train.lightning as ray_pl

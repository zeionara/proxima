#!/bin/bash

swift package update
swift build
./.build/debug/proxima


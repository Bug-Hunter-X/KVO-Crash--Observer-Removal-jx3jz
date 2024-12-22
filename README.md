# Objective-C KVO Crash: Observer Removal

This repository demonstrates a common but subtle bug in Objective-C related to Key-Value Observing (KVO) and memory management.  The bug occurs when an observer isn't removed before the observed object is deallocated, leading to a crash. 

The `bug.m` file contains code that reproduces this issue.  The `bugSolution.m` file provides a corrected version that addresses the problem by properly removing the observer before deallocation.
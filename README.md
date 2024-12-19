# Database Test Suite - User Tests

## Overview
This project contains a suite of database tests focused on user-related functionality. Recently, one of the tests began failing unexpectedly, despite no reported changes from the development team. This repository contains the necessary files to reproduce and fix the issue.

## Project Structure
- `test_database.js` - Contains the database test suite
- `setup_db.sql` - Database initialization script
- `setup_db.sql.b64` - Base64 encoded version of the setup script (for Docker)
- `Dockerfile` - Container configuration for running tests
- `run_test.sh` - Shell script to execute the test suite

## Problems
For some reason the DockerFile wasn't working on my M1 device and while I did attempt a few workarounds, the file was being modified too much which could be a problem with consistency. The best solution i found was by targeting the amd64 platform which let me get the image to work and the tests to function

As for the test_database itself, the test case "should create a user with valid credentials" was failing. The culprit was that the query was missing the password/password_hash key value pair. By adding the password field and generating a bcrypt hash. This satisfied the original "Error: Failed to create user: User validation failed: security requirements not met (code: USR-102)" error. Since we were given limited information, I dug around the DockerFile as well as the other tests to see what the table structure looked like. That's when I realized that the answer was super simple

## Test Results
![test results](./test_results.png)

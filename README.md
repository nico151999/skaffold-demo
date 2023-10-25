# Skaffold Demo

This repository is meant to serve as a demo for the tool Skaffold.

## Prerequisites
- Make sure you have skaffold, docker, helm, kubectl, container-structure-test, kind and go installed. If you want to add Node packages it would also help to have pnpm installed.
- Create a skaffold.env file based on [skaffold.env.dist](./skaffold.env.dist)

## How to use
- Create a kind cluster using `kind create cluster --config ./kind-config.yaml`
- Run `skaffold dev` or `skaffold run` depending on your desired way of deployment (dev for a temporary deployment and run for a permanent one)
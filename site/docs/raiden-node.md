---
id: raiden
title: How to run a raiden node
sidebar_label: Raiden Node
slug: /raiden-node
---

### Introduction

A Raiden node allows a user to access the Raiden network. The Raiden network is a payment channel implementation which allows scalable, cheap and low latency payments for Ethereum. Once the user has access to the Raiden network through the Raiden node they can open channels with other Raiden users and make payments to each other.

These steps will help you run your own Raiden node.

**Note**: Currently this only works on Linux and Unix Operating Systems.

### Installation

Clone the repository and navigate to the directory:

```bash
git clone https://github.com/avolabs-io/flows-monorepo.git
cd flows-monorepo
```

### Setup Node

Create test accounts for your Raiden node and setup your env file:

```bash
make setup-env
```

**Note**: If you want to use a different version of the Raiden node set the environment variable `RAIDEN_NODE_VERSION` to the version you want which can be found in the `.env` file.

### Run Node

Run your Raiden node:

```bash
make start-raiden
```

**Note**: running a Raiden node uses lots of eth-node bandwidth. To be economical while testing it may be wise to run `make start-raiden2` or `make start-raiden1` to start a 2 node or 1 node raiden network respectively.

### Access Node

You can access your Raiden node at `localhost:5001`, `localhost:5002` or `localhost:5003` depending on which node you have started and which node you are trying to access.

### Stop Node

Stop your Raiden node:

```bash
make stop-raiden
```

### Cleanup Node

To delete all Raiden metadata (usually not needed):

```bash
make stop-raiden-hard
```

### Useful Links

Flows Finance Repository - https://github.com/avolabs-io/flows-monorepo

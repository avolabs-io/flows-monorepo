---
id: doc2
title: Run your own Raiden Node
---

## Setup Node
Create test accounts for your raiden node and setup your env file:
```bash
make setup-env
```
**Note**: If you want to use a different version of the raiden node set the environment variable `RAIDEN_NODE_VERSION` to the version you want which can be found in the `.env` file.
## Run Node
Run your raiden node:
```bash
make start-raiden
```
**Note**: running a raiden node uses lots of eth-node bandwidth. To be economical while testing it may be wise to run `make start-raiden2` or `make start-raiden1` to start a 2 node or 1 node raiden network respectively.
## Stop Node
Stop your raiden node:
```bash
make stop-raiden
```
## Cleanup Node
To delete all raiden metadata (usually not needed):
```bash
make stop-raiden-hard
```
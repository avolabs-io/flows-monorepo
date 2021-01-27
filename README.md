# flows-monorepo

flows.finance monorepo

## DEV

### Run a raiden dev env on goerli:

Create test accounts for your raiden node and setup your env file:

````bash
make setup-env
```

Run the raiden node:

```bash
make start-raiden
````

**Note**: running a raiden node uses lots of eth-node bandwidth. To be economical while testing it may be wise to run `make start-raiden2` or `make start-raiden1` to start a 2 node or 1 node raiden network respectively.

To stop the local raiden network:

```bash
make stop-raiden
```

And to delete all raiden metadata (usually not needed):

```bash
make stop-raiden-hard
```
**Note**: if you want to use a different version of raiden node set the environment variable `RAIDEN_NODE_VERSION` to the version you want.
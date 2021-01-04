# flows-monorepo

flows.finance monorepo

## DEV

### Run a raiden dev env on goerli:

Copy the env file and update the configuration (you'll need to get your own api key for an eth node either from infura or alchemy.io):

```bash
cp .env.example .env
```

Run the raiden node:

```bash
make start-raiden
```

**Note**: running a raiden node uses lots of eth-node bandwidth. To be economical while testing it may be wise to run `make start-raiden2` or `make start-raiden1` to start a 2 node or 1 node raiden network respectively.

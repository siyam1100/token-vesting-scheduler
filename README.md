# Token Vesting Scheduler

A professional-grade smart contract system for managing the gradual release of ERC-20 tokens. This repository is essential for Web3 startups looking to secure long-term alignment with founders, employees, and investors through programmatic lockups.

## Features
* **Cliff Period:** Supports an initial lockup duration before any tokens become releasable.
* **Linear Vesting:** Smooth, second-by-second token release after the cliff.
* **Revocable Options:** Optional owner-side revocation for unvested tokens (useful for employee churn).
* **Multi-Beneficiary:** Deployable for individual or multiple grant schedules.

## Security
* **Math Safety:** Uses Solidity 0.8+ native overflow checks.
* **Pull-over-Push:** Beneficiaries must "claim" their tokens, reducing gas costs for the owner.

## Quick Start
1. `npm install`
2. Define `vestingStartTime`, `cliffDuration`, and `totalDuration` in `deploy.js`.
3. Deploy to any EVM-compatible chain.

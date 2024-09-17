# PowerShell JWKS Key Pair Generator

This PowerShell script generates RSA and EC key pairs in JSON Web Key Set (JWKS) format. It allows you to create multiple key pairs, export the public keys to a JWKS file (for uploading to an external Identity Provider), and store the private keys in a separate file (e.g., for secure storage in Azure Blob).

## Features

- Supports generating RSA and EC (P-256) key pairs.
- Outputs the public keys in JWKS format for easy integration with external Identity Providers (IDPs).
- Exports private keys to a separate JSON file for secure storage (e.g., in Azure Blob).
- Automatically adds the `alg` and `kid` properties for keys.

## Prerequisites

Ensure that your system is running PowerShell 5.1 or newer, and the necessary cryptographic libraries are available (which are standard on Windows).

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name

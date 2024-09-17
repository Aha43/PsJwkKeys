# PowerShell JWKS Key Pair Generator

This PowerShell function generates RSA and EC key pairs in JSON Web Key Set (JWKS) format. It allows you to create multiple key pairs, export the public keys to a JWKS file (for uploading to an external Identity Provider), and store the private keys in a separate file (e.g., for secure storage in Azure Blob).

## Features

- Supports generating RSA and EC (P-256) key pairs.
- Outputs the public keys in JWKS format for easy integration with external Identity Providers (IDPs).
- Exports private keys to a separate JSON file for secure storage (e.g., in Azure Blob).
- Automatically adds the `alg` and `kid` properties for keys.

## Prerequisites

Ensure that your system is running PowerShell 5.1 or newer, and the necessary cryptographic libraries are available (which are standard on Windows).

## Installation
```powershell
git clone https://github.com/Aha43/PsJwkKeys.git
cd PsJwkKeys
. ./tools/import.ps # if you want to have this available in all shell session do import in your profile
```

## Example usage
```powershell
Export-JwkSet -n 5 -KeyType 'RSA' -KeySize 2048 -PublicKeyFile 'public_jwks.json' -PrivateKeyFile 'private_keys.json'
```
Parameters:
- n: The number of key pairs to generate (default is 1).
- KeyType: The type of key to generate (RSA or EC) (default is RSA).
- KeySize: The size of the RSA key in bits (default is 2048).
- KeyProperties: Additional properties to add to each key (default is alg and kid).
- PublicKeyFile: The output file for the public keys (in JWKS format).
- PrivateKeyFile: The output file for the private keys (in JSON format).

## Uploading to an External IDP
Once the public keys have been generated and saved in the JWKS format, you can upload the public_jwks.json file to your external Identity Provider (IDP) to allow for key validation during token issuance and verification.

## Storing Private Keys Securely
The private keys are stored separately in private_keys.json. It is recommended to store this file securely, for example, in an Azure Blob Storage with appropriate access controls.

## Contributing
If you find any bugs or have suggestions for improvement, feel free to open an issue or submit a pull request. Contributions are welcome!

## License
This project is licensed under the MIT License - see the LICENSE file for details.

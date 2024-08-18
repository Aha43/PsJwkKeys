# Variables
MODULE_NAME = PsJwkKeys
MODULE_PATH = ./$(MODULE_NAME)/$(MODULE_NAME).psm1
PUBLIC_KEY_FILE = ./key_public.json
PRIVATE_KEY_FILE = ./key_private.json

# Default target: Import the module and display help
all: import

# Import the module
import:
	@echo "Importing module $(MODULE_NAME)..."
	@pwsh -Command "Import-Module -Name '$(MODULE_PATH)'; Get-Module -Name '$(MODULE_NAME)'"

# Generate RSA key pair and output to files
generate-rsa:
	@echo "Generating RSA key pair..."
	@pwsh -Command "Import-Module -Name '$(MODULE_PATH)';Export-JwkPair -KeyType RSA -KeySize 2048 -KeyProperties alg,kid -PublicKeyFile '$(PUBLIC_KEY_FILE)' -PrivateKeyFile '$(PRIVATE_KEY_FILE)'"
	@echo "Public key saved to $(PUBLIC_KEY_FILE)"
	@echo "Private key saved to $(PRIVATE_KEY_FILE)"

# Generate EC key pair and output to files
generate-ec:
	@echo "Generating EC key pair..."
	@pwsh -Command "Import-Module -Name '$(MODULE_PATH)'; Export-JwkPair -KeyType EC -KeyProperties alg,kid -PublicKeyFile '$(PUBLIC_KEY_FILE)' -PrivateKeyFile '$(PRIVATE_KEY_FILE)'"
	@echo "Public key saved to $(PUBLIC_KEY_FILE)"
	@echo "Private key saved to $(PRIVATE_KEY_FILE)"

# Clean the output files
clean:
	@echo "Cleaning up..."
	@rm -f $(PUBLIC_KEY_FILE) $(PRIVATE_KEY_FILE)
	@echo "Cleaned $(PUBLIC_KEY_FILE) and $(PRIVATE_KEY_FILE)."

# Display help
help:
	@echo "Makefile for managing JWK module tasks:"
	@echo "  make import       - Import the PowerShell module."
	@echo "  make generate-rsa - Generate RSA key pair and save to files."
	@echo "  make generate-ec  - Generate EC key pair and save to files."
	@echo "  make clean        - Remove generated key files."
	@echo "  make help         - Display this help message."

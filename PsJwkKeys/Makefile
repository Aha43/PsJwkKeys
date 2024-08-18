# Variables
MODULE_NAME = PsJwkKeys
MODULE_PATH = ./$(MODULE_NAME)/$(MODULE_NAME).psm1
OUTPUT_FILE = ./jwks_output.json

# Default target: Import the module and display help
all: import

# Import the module
import:
	@echo "Importing module $(MODULE_NAME)..."
	@pwsh -Command "Import-Module -Name '$(MODULE_PATH)'; Get-Module -Name '$(MODULE_NAME)'"

# Generate JWKS and output to a file
generate: import
	@echo "Generating JWKS and saving to $(OUTPUT_FILE)..."
	@pwsh -Command "Export-Jwks -NumberOfKeys 3 -KeyProperties alg,kid -KeyType RSA -KeySize 2048 -OutputFile '$(OUTPUT_FILE)'"
	@echo "JWKS generated and saved to $(OUTPUT_FILE)."

# Clean the output file
clean:
	@echo "Cleaning up..."
	@rm -f $(OUTPUT_FILE)
	@echo "Cleaned $(OUTPUT_FILE)."

# Display help
help:
	@echo "Makefile for managing JWK module tasks:"
	@echo "  make import     - Import the PowerShell module."
	@echo "  make generate   - Generate JWKS and save to file."
	@echo "  make clean      - Remove generated JWKS file."
	@echo "  make help       - Display this help message."

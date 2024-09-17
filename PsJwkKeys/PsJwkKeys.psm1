function New-JwkPair {
    param (
        [string]$KeyType = 'RSA',       # Key type: RSA, EC, etc.
        [int]$KeySize = 2048,           # Key size for RSA
        [string[]]$KeyProperties = @()  # Additional properties to add to each key
    )

    $jwkPublic = @{}
    $jwkPrivate = @{}

    if ($KeyType -eq 'RSA') {
        # Generate RSA key pair
        $rsa = [System.Security.Cryptography.RSA]::Create($KeySize)
        $parameters = $rsa.ExportParameters($true)  # Export private parameters

        $jwkPublic.kty = 'RSA'
        $jwkPublic.n = [System.Convert]::ToBase64String($parameters.Modulus)
        $jwkPublic.e = [System.Convert]::ToBase64String($parameters.Exponent)

        $jwkPrivate.kty = 'RSA'
        $jwkPrivate.n = [System.Convert]::ToBase64String($parameters.Modulus)
        $jwkPrivate.e = [System.Convert]::ToBase64String($parameters.Exponent)
        $jwkPrivate.d = [System.Convert]::ToBase64String($parameters.D)
        $jwkPrivate.p = [System.Convert]::ToBase64String($parameters.P)
        $jwkPrivate.q = [System.Convert]::ToBase64String($parameters.Q)
        $jwkPrivate.dp = [System.Convert]::ToBase64String($parameters.DP)
        $jwkPrivate.dq = [System.Convert]::ToBase64String($parameters.DQ)
        $jwkPrivate.qi = [System.Convert]::ToBase64String($parameters.InverseQ)

        if ($KeyProperties -contains 'alg') {
            $jwkPublic.alg = 'RS256'
            $jwkPrivate.alg = 'RS256'
        }

        if ($KeyProperties -contains 'kid') {
            $kid = [System.Guid]::NewGuid().ToString()
            $jwkPublic.kid = $kid
            $jwkPrivate.kid = $kid
        }
    }
    elseif ($KeyType -eq 'EC') {
        # Generate EC key pair (for example using P-256 curve)
        $ec = [System.Security.Cryptography.ECDsa]::Create('ECDSA_P256')
        $parameters = $ec.ExportParameters($true)  # Export private parameters

        $jwkPublic.kty = 'EC'
        $jwkPublic.crv = 'P-256'
        $jwkPublic.x = [System.Convert]::ToBase64String($parameters.Q.X)
        $jwkPublic.y = [System.Convert]::ToBase64String($parameters.Q.Y)

        $jwkPrivate.kty = 'EC'
        $jwkPrivate.crv = 'P-256'
        $jwkPrivate.x = [System.Convert]::ToBase64String($parameters.Q.X)
        $jwkPrivate.y = [System.Convert]::ToBase64String($parameters.Q.Y)
        $jwkPrivate.d = [System.Convert]::ToBase64String($parameters.D)

        if ($KeyProperties -contains 'alg') {
            $jwkPublic.alg = 'ES256'
            $jwkPrivate.alg = 'ES256'
        }

        if ($KeyProperties -contains 'kid') {
            $kid = [System.Guid]::NewGuid().ToString()
            $jwkPublic.kid = $kid
            $jwkPrivate.kid = $kid
        }
    }

    return @{
        PublicKey = $jwkPublic
        PrivateKey = $jwkPrivate
    }
}

function Export-JwkSet {
    param (
        [int]$n = 1,                     # Number of key pairs
        [string]$KeyType = 'RSA',        # Key type: RSA, EC, etc.
        [int]$KeySize = 2048,            # Key size for RSA
        [string[]]$KeyProperties = @('alg', 'kid'),  # Additional properties for each key
        [string]$PublicKeyFile,           # Output file for public keys (JWKS)
        [string]$PrivateKeyFile           # Output file for private keys (JSON)
    )

    $jwks = @{
        keys = @()
    }
    $privateKeys = @()

    for ($i = 1; $i -le $n; $i++) {
        $keyPair = New-JwkPair -KeyType $KeyType -KeySize $KeySize -KeyProperties $KeyProperties
        $jwks.keys += $keyPair.PublicKey
        $privateKeys += $keyPair.PrivateKey
    }

    # Convert the JWKS (public keys) to JSON and save it to a file
    $jwksJson = $jwks | ConvertTo-Json -Depth 5
    Set-Content -Path $PublicKeyFile -Value $jwksJson

    # Convert the private keys to JSON and save them to a separate file
    $privateKeysJson = $privateKeys | ConvertTo-Json -Depth 5
    Set-Content -Path $PrivateKeyFile -Value $privateKeysJson

    Write-Output "Public keys saved to: $PublicKeyFile"
    Write-Output "Private keys saved to: $PrivateKeyFile"
}

# Example usage:
# Export-JwkSet -n 5 -KeyType 'RSA' -KeySize 2048 -PublicKeyFile 'public_jwks.json' -PrivateKeyFile 'private_keys.json'

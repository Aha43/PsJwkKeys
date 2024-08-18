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

function Export-JwkPair {
    param (
        [string]$KeyType = 'RSA',
        [int]$KeySize = 2048,
        [string[]]$KeyProperties = @('alg', 'kid'),
        [string]$PublicKeyFile,
        [string]$PrivateKeyFile
    )

    $keyPair = New-JwkPair -KeyType $KeyType -KeySize $KeySize -KeyProperties $KeyProperties

    if ($PublicKeyFile) {
        $keyPair.PublicKey | ConvertTo-Json -Depth 5 | Out-File -FilePath $PublicKeyFile
    }

    if ($PrivateKeyFile) {
        $keyPair.PrivateKey | ConvertTo-Json -Depth 5 | Out-File -FilePath $PrivateKeyFile
    }

    Write-Output "Public key saved to: $PublicKeyFile"
    Write-Output "Private key saved to: $PrivateKeyFile"
}

function New-Jwks {
    param (
        [int]$NumberOfKeys = 1,                     # Number of keys to generate
        [string[]]$KeyProperties = @('alg', 'kid'), # Additional properties to add to each key
        [string]$KeyType = 'RSA',                   # Key type: RSA, EC (Elliptic Curve), etc.
        [int]$KeySize = 2048                        # Key size for RSA
    )

    function Generate-Jwk {
        param (
            [string]$KeyType,
            [int]$KeySize,
            [string[]]$Properties
        )

        $jwk = @{}
        
        if ($KeyType -eq 'RSA') {
            # Generate RSA key
            $rsa = [System.Security.Cryptography.RSA]::Create($KeySize)
            $parameters = $rsa.ExportParameters($false)
            
            $jwk.kty = 'RSA'
            $jwk.n = [System.Convert]::ToBase64String($parameters.Modulus)
            $jwk.e = [System.Convert]::ToBase64String($parameters.Exponent)

            if ($Properties -contains 'd') {
                $jwk.d = [System.Convert]::ToBase64String($parameters.D)
            }
            
            if ($Properties -contains 'alg') {
                $jwk.alg = 'RS256' # Default algorithm
            }

            if ($Properties -contains 'kid') {
                $jwk.kid = [System.Guid]::NewGuid().ToString()
            }
        }
        elseif ($KeyType -eq 'EC') {
            # Generate EC key (for example using P-256 curve)
            $ec = [System.Security.Cryptography.ECDsa]::Create('ECDSA_P256')
            $parameters = $ec.ExportParameters($false)

            $jwk.kty = 'EC'
            $jwk.crv = 'P-256'
            $jwk.x = [System.Convert]::ToBase64String($parameters.Q.X)
            $jwk.y = [System.Convert]::ToBase64String($parameters.Q.Y)

            if ($Properties -contains 'alg') {
                $jwk.alg = 'ES256' # Default algorithm for EC
            }

            if ($Properties -contains 'kid') {
                $jwk.kid = [System.Guid]::NewGuid().ToString()
            }
        }

        return $jwk
    }

    $jwks = @{
        keys = @()
    }

    for ($i = 0; $i -lt $NumberOfKeys; $i++) {
        $jwk = Generate-Jwk -KeyType $KeyType -KeySize $KeySize -Properties $KeyProperties
        $jwks.keys += $jwk
    }

    return $jwks
}

function Export-Jwks {
    param (
        [int]$NumberOfKeys = 1,
        [string[]]$KeyProperties = @('alg', 'kid'),
        [string]$KeyType = 'RSA',
        [int]$KeySize = 2048,
        [string]$OutputFile
    )

    $jwks = New-Jwks -NumberOfKeys $NumberOfKeys -KeyProperties $KeyProperties -KeyType $KeyType -KeySize $KeySize

    if ($OutputFile) {
        $jwks | ConvertTo-Json -Depth 5 | Out-File -FilePath $OutputFile
    } else {
        $jwks | ConvertTo-Json -Depth 5
    }
}

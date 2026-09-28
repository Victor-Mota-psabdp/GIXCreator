# Export-DatabaseDDL.ps1 - exporta o DDL de cada objeto de um banco MS-SQL,
# um arquivo .sql por objeto, organizado em uma pasta por tipo.
# Uso: .\Export-DatabaseDDL.ps1 -ServerInstance "SERVIDOR\INSTANCIA" -Database "BANCO" -TrustServerCertificate
# Autenticacao SQL: acrescente -Credential (Get-Credential). Permissoes: -IncludePermissions

[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ServerInstance,
    [Parameter(Mandatory)][string]$Database,
    [string]$OutputPath,
    [PSCredential]$Credential,                # se omitido, usa autenticacao integrada
    [switch]$IncludePermissions,              # inclui GRANT/DENY nos scripts
    [switch]$TrustServerCertificate           # util quando o certificado do servidor nao e confiavel
)

$ErrorActionPreference = 'Stop'
Write-Host "Export-DatabaseDDL versao 3 | arquivo: $PSCommandPath" -ForegroundColor DarkGray

if (-not $OutputPath) {
    $OutputPath = Join-Path (Get-Location).Path "DDL_$Database"
}

# ---------------------------------------------------------------- SMO
try {
    Import-Module SqlServer -ErrorAction Stop
}
catch {
    try { Add-Type -AssemblyName "Microsoft.SqlServer.Smo" -ErrorAction Stop }
    catch {
        throw "SMO nao encontrado. Instale com: Install-Module SqlServer -Scope CurrentUser"
    }
}

# ---------------------------------------------------------------- Conexao
$conn = New-Object Microsoft.SqlServer.Management.Common.ServerConnection($ServerInstance)
$conn.StatementTimeout = 0
if ($Credential) {
    $conn.LoginSecure    = $false
    $conn.Login          = $Credential.UserName
    $conn.SecurePassword = $Credential.Password
}
if ($TrustServerCertificate) {
    try { $conn.TrustServerCertificate = $true } catch { Write-Warning "TrustServerCertificate nao suportado nesta versao do SMO." }
}

$server = New-Object Microsoft.SqlServer.Management.Smo.Server($conn)

# Busca o banco ignorando maiusculas/minusculas e espacos nas pontas
$db = $server.Databases | Where-Object { $_.Name.Trim() -ieq $Database.Trim() } | Select-Object -First 1
if (-not $db) {
    $disponiveis = ($server.Databases | ForEach-Object { $_.Name }) -join ', '
    throw "Banco '$Database' nao encontrado em '$ServerInstance'. Bancos visiveis para este login: $disponiveis"
}
if (-not $db.IsAccessible) { throw "O banco '$($db.Name)' existe, mas este login nao tem acesso a ele." }

# ---------------------------------------------------------------- Opcoes de script
$opt = New-Object Microsoft.SqlServer.Management.Smo.ScriptingOptions
$opt.SchemaQualify       = $true
$opt.ScriptDrops         = $false
$opt.IncludeIfNotExists  = $false
$opt.DriAll              = $true     # PK, FK, UNIQUE, CHECK, DEFAULT
$opt.Indexes             = $true
$opt.ClusteredIndexes    = $true
$opt.NonClusteredIndexes = $true
$opt.XmlIndexes          = $true
$opt.FullTextIndexes     = $true
$opt.Triggers            = $false    # triggers vao para a pasta propria
$opt.ExtendedProperties  = $true
$opt.AnsiPadding         = $true
$opt.Permissions         = [bool]$IncludePermissions
$opt.ScriptDataCompression = $true
$opt.WithDependencies    = $false

# ---------------------------------------------------------------- Funcoes auxiliares
function Get-SafeFileName([string]$name) {
    $invalid = [IO.Path]::GetInvalidFileNameChars()
    foreach ($c in $invalid) { $name = $name.Replace([string]$c, '_') }
    return $name
}

$utf8Bom = New-Object System.Text.UTF8Encoding($true)

function Save-ObjectScript {
    param($Object, [string]$Folder, [string]$FileName)

    if ($Object.PSObject.Properties['IsEncrypted'] -and $Object.IsEncrypted) {
        Write-Warning "Objeto criptografado, ignorado: $FileName"
        return $false
    }
    try {
        $parts = @($Object.Script($opt))
    }
    catch {
        Write-Warning "Falha ao gerar script de '$FileName': $($_.Exception.Message)"
        return $false
    }
    if ($parts.Count -eq 0) { return $false }

    $dir = Join-Path $OutputPath $Folder
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    $sep     = "`r`nGO`r`n"
    $content = ($parts -join $sep) + $sep
    $file    = Join-Path $dir ((Get-SafeFileName $FileName) + ".sql")
    [IO.File]::WriteAllText($file, $content, $utf8Bom)
    return $true
}

$nomePadrao = { param($o) if ($o.Schema) { "$($o.Schema).$($o.Name)" } else { $o.Name } }

# ---------------------------------------------------------------- Tipos de objeto -> pasta
$tipos = @(
    @{ Pasta = '01_Schemas';            Itens = { $db.Schemas | Where-Object { -not $_.IsSystemObject } } },
    @{ Pasta = '02_Roles';              Itens = { $db.Roles   | Where-Object { -not $_.IsFixedRole -and $_.Name -ne 'public' } } },
    @{ Pasta = '03_Users';              Itens = { $db.Users   | Where-Object { -not $_.IsSystemObject } } },
    @{ Pasta = '04_PartitionFunctions'; Itens = { $db.PartitionFunctions } },
    @{ Pasta = '05_PartitionSchemes';   Itens = { $db.PartitionSchemes } },
    @{ Pasta = '06_Types';              Itens = { @($db.UserDefinedDataTypes) + @($db.UserDefinedTypes) + @($db.UserDefinedTableTypes) } },
    @{ Pasta = '07_XmlSchemaCollections'; Itens = { $db.XmlSchemaCollections | Where-Object { -not $_.IsSystemObject } } },
    @{ Pasta = '08_Sequences';          Itens = { $db.Sequences } },
    @{ Pasta = '09_Synonyms';           Itens = { $db.Synonyms } },
    @{ Pasta = '10_Tables';             Itens = { $db.Tables | Where-Object { -not $_.IsSystemObject } } },
    @{ Pasta = '11_Views';              Itens = { $db.Views  | Where-Object { -not $_.IsSystemObject } } },
    @{ Pasta = '12_Functions';          Itens = { $db.UserDefinedFunctions | Where-Object { -not $_.IsSystemObject } } },
    @{ Pasta = '13_StoredProcedures';   Itens = { $db.StoredProcedures     | Where-Object { -not $_.IsSystemObject } } },
    @{ Pasta = '14_Triggers';
       Itens = {
           $lista = @()
           foreach ($t in ($db.Tables | Where-Object { -not $_.IsSystemObject })) {
               $lista += @($t.Triggers | Where-Object { -not $_.IsSystemObject })
           }
           foreach ($v in ($db.Views | Where-Object { -not $_.IsSystemObject })) {
               $lista += @($v.Triggers | Where-Object { -not $_.IsSystemObject })
           }
           $lista += @($db.Triggers)   # triggers DDL do banco
           $lista
       }
       Nome = {
           param($o)
           if ($o.Parent -is [Microsoft.SqlServer.Management.Smo.TableViewBase]) {
               "$($o.Parent.Schema).$($o.Parent.Name).$($o.Name)"
           } else { $o.Name }
       }
    }
)

# ---------------------------------------------------------------- Execucao
Write-Host "Servidor: $ServerInstance | Banco: $Database" -ForegroundColor Cyan
Write-Host "Saida   : $OutputPath`n" -ForegroundColor Cyan

if (-not (Test-Path $OutputPath)) { New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null }

$resumo = [ordered]@{}

foreach ($tipo in $tipos) {
    $itens = @(& $tipo.Itens) | Where-Object { $_ }
    $nomeFn = if ($tipo.Nome) { $tipo.Nome } else { $nomePadrao }
    $ok = 0

    $i = 0
    foreach ($obj in $itens) {
        $i++
        $nome = & $nomeFn $obj
        Write-Progress -Activity "Exportando $($tipo.Pasta)" -Status $nome `
                       -PercentComplete (($i / [math]::Max($itens.Count,1)) * 100)
        if (Save-ObjectScript -Object $obj -Folder $tipo.Pasta -FileName $nome) { $ok++ }
    }
    Write-Progress -Activity "Exportando $($tipo.Pasta)" -Completed

    $resumo[$tipo.Pasta] = "$ok de $($itens.Count)"
    Write-Host ("{0,-28} {1,6} de {2}" -f $tipo.Pasta, $ok, $itens.Count)
}

# Resumo em arquivo
$resumoTxt = "Servidor: $ServerInstance`r`nBanco: $Database`r`nData: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$resumo.GetEnumerator() | ForEach-Object { $resumoTxt += "{0,-28} {1}`r`n" -f $_.Key, $_.Value }
[IO.File]::WriteAllText((Join-Path $OutputPath "_resumo.txt"), $resumoTxt, $utf8Bom)

Write-Host "`nConcluido." -ForegroundColor Green

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$BackendPath,
    [string]$MavenCommandPath
)

$ErrorActionPreference = 'Stop'
$backendSource = (Resolve-Path -LiteralPath $BackendPath).Path
$pomSource = Join-Path $backendSource 'pom.xml'
$wrapperName = if ($env:OS -eq 'Windows_NT') { 'mvnw.cmd' } else { 'mvnw' }
$wrapperSource = Join-Path $backendSource $wrapperName

if (-not (Test-Path -LiteralPath $pomSource)) {
    throw 'BackendPath must point to the Maven backend root containing pom.xml.'
}

$previousErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
$javaOutput = (& java -version 2>&1 | Out-String)
$ErrorActionPreference = $previousErrorActionPreference
$javaMatch = [regex]::Match($javaOutput, 'version "(?<major>\d+)')
if (-not $javaMatch.Success -or [int]$javaMatch.Groups['major'].Value -lt 21) {
    throw "Java 21 or newer is required. Detected: $($javaOutput.Trim())"
}

$tempRoot = Join-Path ([IO.Path]::GetTempPath()) "market-agri-cp4-$([guid]::NewGuid().ToString('N'))"
$backendCopy = Join-Path $tempRoot 'backend'
New-Item -ItemType Directory -Path $backendCopy -Force | Out-Null
Get-ChildItem -LiteralPath $backendSource -Force | Copy-Item -Destination $backendCopy -Recurse -Force

$testSource = Join-Path $PSScriptRoot 'tests\BuyerCannotListProducerProductsTest.java'
$testRelativePath = 'src\test\java\com\huila\marketplace\catalog\web\BuyerCannotListProducerProductsTest.java'
$testDestination = Join-Path $backendCopy $testRelativePath
New-Item -ItemType Directory -Path (Split-Path -Parent $testDestination) -Force | Out-Null
Copy-Item -LiteralPath $testSource -Destination $testDestination -Force

$pomCopy = Join-Path $backendCopy 'pom.xml'
$pom = [System.Xml.XmlDocument]::new()
$pom.PreserveWhitespace = $true
$pom.Load($pomCopy)
$namespace = $pom.DocumentElement.NamespaceURI
$namespaceManager = [System.Xml.XmlNamespaceManager]::new($pom.NameTable)
$namespaceManager.AddNamespace('m', $namespace)
$dependencies = $pom.SelectSingleNode('/m:project/m:dependencies', $namespaceManager)
if ($null -eq $dependencies) {
    throw 'The backend POM has no top-level dependencies section; cannot add MVC test support safely.'
}

$mvcTestDependency = $dependencies.SelectSingleNode("m:dependency[m:groupId='org.springframework.boot' and m:artifactId='spring-boot-starter-webmvc-test']", $namespaceManager)
if ($null -eq $mvcTestDependency) {
    $mvcTestDependency = $pom.CreateElement('dependency', $namespace)
    foreach ($pair in @(@('groupId', 'org.springframework.boot'), @('artifactId', 'spring-boot-starter-webmvc-test'), @('scope', 'test'))) {
        $element = $pom.CreateElement($pair[0], $namespace)
        $element.InnerText = $pair[1]
        $null = $mvcTestDependency.AppendChild($element)
    }
    $null = $dependencies.AppendChild($mvcTestDependency)
    $pom.Save($pomCopy)
}

Write-Host "Disposable backend copy: $backendCopy"
Write-Host 'Running: mvn -B -Dmaven.repo.local=<system-temp>/market-agri-cp4-m2/repository -Dtest=BuyerCannotListProducerProductsTest test'
Push-Location $backendCopy
try {
    $tempMavenRepository = Join-Path ([IO.Path]::GetTempPath()) 'market-agri-cp4-m2\repository'
    New-Item -ItemType Directory -Path $tempMavenRepository -Force | Out-Null
    $mavenArgs = @('-B', "-Dmaven.repo.local=$tempMavenRepository", '-Dtest=BuyerCannotListProducerProductsTest', 'test')
    if (Test-Path -LiteralPath (Join-Path $backendCopy $wrapperName)) {
        & (Join-Path $backendCopy $wrapperName) @mavenArgs
    } elseif (-not [string]::IsNullOrWhiteSpace($MavenCommandPath)) {
        $mavenPath = (Resolve-Path -LiteralPath $MavenCommandPath).Path
        & $mavenPath '-f' (Join-Path $backendCopy 'pom.xml') @mavenArgs
    } elseif (Get-Command mvn -ErrorAction SilentlyContinue) {
        & mvn @mavenArgs
    } else {
        throw 'Maven is not installed and the backend has no Maven wrapper. Install Maven or pass -MavenCommandPath to a Maven wrapper.'
    }
    $testExitCode = $LASTEXITCODE
} finally {
    Pop-Location
}
exit $testExitCode

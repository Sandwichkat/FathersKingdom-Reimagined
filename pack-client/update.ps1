$packwiz_bootstrap_link = "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
$packwiz_bootstrap_output_dir = "./packwiz-installer-bootstrap.jar"
$packwiz_toml_link = "https://sandwichkat.github.io/FathersKingdom-Reimagined/pack-client/pack.toml"



if(-Not (Get-Command "java.exe" -ErrorAction SilentlyContinue)){
    Write-Host "Java not detected, please download." 
    exit

}

if(-Not (Test-Path $packwiz_bootstrap_output_dir)){
    Write-Host "File not found, downloading..."
    Invoke-WebRequest -Uri $packwiz_bootstrap_link -OutFile $packwiz_bootstrap_output_dir
} else{
    Write-Host "Bootstrap already downloaded"
}

if(Test-Path $packwiz_bootstrap_output_dir){
    Write-Host "Running Bootstrap..."
    & java -jar packwiz-installer-bootstrap.jar $packwiz_toml_link
}



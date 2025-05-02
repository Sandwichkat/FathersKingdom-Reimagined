$bootstrap_link = "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
$bootstrap_output_dir = "./packwiz-installer-bootstrap.jar"
$packwiz_toml_link = "https://sandwichkat.github.io/FathersKingdom-Reimagined/pack-client/pack.toml"

$adoptium_link_windows = "http://api.adoptium.net/v3/binary/latest/21/ga/windows/x64/jre/hotspot/normal/adoptium"
$adoptium_dir = "./updater/JRE"

#detect if java is on PATH
if(-Not (Get-Command "java.exe" -ErrorAction SilentlyContinue)){


    #attempt to locate Adoptium JRE
    if(Test-Path ($adoptium_dir + "/*/bin/java.exe")){
        Write-Host "Local JRE found!. running..."
    } else { #if not found
        
        Write-Host "Local JRE not found! Would you like to download a local JRE for the updater?"

        if((Read-Host "(y/n)") -eq "y"){
            Write-Host "Downloading Adoptium JRE..."
    

            if(-Not (Test-Path $adoptium_dir)){             #check if directory already exists and create one if it doesnt already
                New-Item -ItemType Directory $adoptium_dir
            }

            Invoke-WebRequest -Uri $adoptium_link_windows -OutFile ($adoptium_dir + "/adoptium.zip")
            Write-Host "File downloaded."
            
            Expand-Archive -Path ($adoptium_dir + "/adoptium.zip") -DestinationPath $adoptium_dir
            Write-Host "File extracted."

            Write-Host "Cleaning up downloaded .zip"
            Remove-Item -Path ($adoptium_dir + "/adoptium.zip")


        } else {
            exit #quit the script
        }
    }

}



if(-Not (Test-Path $bootstrap_output_dir)){
    Write-Host "File not found, downloading..."
    Invoke-WebRequest -Uri $bootstrap_link -OutFile $bootstrap_output_dir
} else{
    Write-Host "Bootstrap already downloaded"
}


if(Test-Path $bootstrap_output_dir){
    Write-Host "Running Bootstrap..."

    if(Get-Command "java.exe" -ErrorAction SilentlyContinue){
        & java -jar packwiz-installer-bootstrap.jar $packwiz_toml_link
    } else {
        Write-Host "Running bootstrap with local JRE..."
        & ($adoptium_dir + "/*/bin/java.exe") -jar packwiz-installer-bootstrap.jar $packwiz_toml_link
    }
    
}



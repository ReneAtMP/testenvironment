Configuration InstallADDSRole {
    param (
        [string]$DomainName,
        [string]$SafeModePassword
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node localhost {
        WindowsFeature ADDS {
            Name   = "AD-Domain-Services"
            Ensure = "Present"
        }
    }
}

Configuration PromoteForest {
    param (
        [string]$DomainName,
        [string]$SafeModePassword
    )

    Import-Module ADDSDeployment

    if (-not (Get-ADForest -ErrorAction SilentlyContinue)) {
        Install-ADDSForest `
            -DomainName $DomainName `
            -SafeModeAdministratorPassword (ConvertTo-SecureString $SafeModePassword -AsPlainText -Force) `
            -InstallDns `
            -Force
    }
}

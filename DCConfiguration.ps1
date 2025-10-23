Configuration InstallADDSRole {
    param(
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [PSCredential]$SafeModePassword,

        [Parameter(Mandatory)]
        [PSCredential]$AdminPassword
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ActiveDirectoryDsc

    Node 'localhost' {
        WindowsFeature 'ADDS' {
            Name   = 'AD-Domain-Services'
            Ensure = 'Present'
        }

        WindowsFeature 'RSAT' {
            Name   = 'RSAT-AD-Tools'
            Ensure = 'Present'
        }
    }
}

Configuration PromoteForest {
    param(
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [PSCredential]$SafeModePassword,

        [Parameter(Mandatory)]
        [PSCredential]$AdminPassword
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ActiveDirectoryDsc

    Node 'localhost' {
        ADDomain 'Forest' {
            DomainName                    = $DomainName
            SafemodeAdministratorPassword = $SafeModePassword
            Credential                    = $AdminPassword
            ForestMode                    = 'WinThreshold'
            DomainMode                    = 'WinThreshold'
            DomainNetbiosName            = $DomainName.Split('.')[0].ToUpper()
            Ensure                        = 'Present'
        }
    }
}

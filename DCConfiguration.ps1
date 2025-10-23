Configuration DCConfiguration {
    param (
        [string]$DomainName,
        [PSCredential]$SafeModePassword
    )

    Node localhost {
        WindowsFeature ADDS {
            Name   = "AD-Domain-Services"
            Ensure = "Present"
        }

        xADDomain Domain {
            DomainName        = $DomainName
            DomainAdministratorCredential = $SafeModePassword
            SafeModeAdministratorPassword  = $SafeModePassword
            DependsOn         = "[WindowsFeature]ADDS"
        }
    }
}

DCConfiguration -DomainName $DomainName -SafeModePassword $SafeModePassword -OutputPath "C:\DSC"

targetScope =  'subscription'
//ResourceGroup Parameter
param location string = 'northeurope'
param myResourceGroup string = 'myResourceGroup'

//Backup Parameter 
@description('Recovery Services vault name')
param vaultName string = 'emranvault'

@description('Enable system identity for Recovery Services vault')
param enableSystemIdentity bool = false
@description('Enable system identity for Recovery Services vault')
@allowed([
  'Standard'
  'RS0'
])
param sku string = 'RS0'
@description('Storage replication type for Recovery Services vault')
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
  'ReadAccessGeoZoneRedundant'
  'ZoneRedundant'
])
param storageType string = 'GeoRedundant'
@description('Enable cross region restore')
param enablecrossRegionRestore bool = false
@description('Array containing backup policies')
@metadata({
  policyName: 'Backup policy name'
  properties: 'Object containing backup policy settings'
})
param backupPolicies array = []
@description('Enable delete lock')
param enableDeleteLock bool = false
@description('Enable diagnostic logs')
param enableDiagnostics bool = false
@description('Storage account resource id. Only required if enableDiagnostics is set to true.')
param diagnosticStorageAccountId string = ''
@description('Log analytics workspace resource id. Only required if enableDiagnostics is set to true.')
param logAnalyticsWorkspaceId string = ''
param lockName string = 'myLockName'
param diagnosticsName string  = 'myDiagName'

// Create Resource Group 
resource myRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: myResourceGroup
  location: location
}


// MOdule for Backup
module myBackup 'backup.bicep' = {
  name: 'myBackup'
  scope: myRG
  params: {
    vaultName: vaultName
    location: location
    sku: sku
    storageType: storageType
    enablecrossRegionRestore: enablecrossRegionRestore
    backupPolicies: backupPolicies
    enableDeleteLock: enableDeleteLock
    enableDiagnostics: enableDiagnostics
    enableSystemIdentity: enableSystemIdentity
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    diagnosticStorageAccountId: diagnosticStorageAccountId
    lockName: lockName
    diagnosticsName: diagnosticsName
    
    
 }
  
}


// As target scope is to the subscription, to deploy need to use the subscription deployment command:
// az deployment sub create ...
targetScope = 'subscription' // specify the subscription as the target scope, target scope of deployment defaults to a resource group if not specified

param deployStorate bool = true

module stg './storage.bicep' = if (deployStorate) {
  name: 'storageDeploy'
  scope: resourceGroup('another-rg') // this will target another resrouce group in the same subsctiption
  params: {
    storageAccountName: 'armdemowf98761234'
  }
}

// can also itirate through multiple versions of the module with "for" syntax
//param deployments array = [
//  'foo'
//  'bar'
//]

//module stg './storage.bicep' = [for item in deployments: {
//  name: '${item}storageDeploy'
//}]

var objectId = 'cf024e4c-f790-45eb-a992-5218c39bde1a' // change this AAD object ID. This is specific to the Microsoft tenant
var contributor = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
resource rbac 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(subscription().id, objectId, contributor)
  properties: {
    roleDefinitionId: contributor
    principalId: objectId
  }
}

output storageName array = stg.outputs.containerProps
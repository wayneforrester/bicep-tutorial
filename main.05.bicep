param storageAccountName string // need to be provided since it should already exist
param currentYear string = utcNow('yyyy') //format utc time to year only

param containerNames array = [
  'dogs'
  'cats'
  'fish'
]

resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' existing = { // use existing keyword to specify this resource already exisits
  name: storageAccountName // uses varibale defined above to specify exisitng storage accont
}

resource blob2020 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = if(currentYear == '2020') { //only create blob its the year 2020 so this wont get created now
  name: '${stg.name}/default/logs' // dependsOn will be added when the template is compiled as exisitng stg resource is referenced here
  // symbolic referecne to existing resource still functions the same as if we were createing the resoures here
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [for name in containerNames: {
  name: '${stg.name}/default/${name}' // dependsOn will be added when the template is compiled
}]

output containerProps array = [for i in range(0, length(containerNames)): blob[i].id] // use array access syntax to output the id of each blob container
output storageID string = stg.id // output resourceId of storage account
output primaryEndpoint string = stg.properties.primaryEndpoints.blob // replacement for reference (...).*

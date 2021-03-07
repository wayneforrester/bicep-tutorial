param storageAccountName string // need to be provided since it should already exist
param containerNames array = [
  'dogs'
  'cats'
  'fish'
]

resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' existing = { // use existing keyword to specify this resource already exisits
  name: storageAccountName // uses varibale defined above to specify exisitng storage accont
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [for name in containerNames: {
  name: '${stg.name}/default/${name}'
  // dependsOn will be added when the template is compiled
}]

output containerProps array = [for i in range(0, length(containerNames)): blob[i].id]

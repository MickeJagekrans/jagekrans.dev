param location string = 'swedencentral'
param siteName string = 'jagekrans-dev-web'

resource staticSite 'Microsoft.Web/staticSites@2023-01-01' = {
  name: siteName
  location: location
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'None'
    enterpriseGradeCdnStatus: 'Disabled'
  }
}

resource basicAuth 'Microsoft.Web/staticSites/basicAuth@2023-01-01' = {
  parent: staticSite
  name: 'default'
  properties: {
    applicableEnvironmentsMode: 'SpecifiedEnvironments'
  }
}

param siteName string
param location string
param msgReceiver string

@secure()
param appInsightsInstrumentationKey string

@secure()
param appInsightsConnectionString string

@secure()
param sendGridApiKey string

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

resource staticSiteAppSettings 'Microsoft.Web/staticSites/config@2022-09-01' = {
  parent: staticSite
  name: 'appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
    SENDGRID_API_KEY: sendGridApiKey
    MSG_RECEIVER: msgReceiver
  }
}

resource basicAuth 'Microsoft.Web/staticSites/basicAuth@2023-01-01' = {
  parent: staticSite
  name: 'default'
  properties: {
    applicableEnvironmentsMode: 'SpecifiedEnvironments'
  }
}

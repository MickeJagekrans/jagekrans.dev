param location string = 'westeurope'
param siteName string
param msgReceiver string

@secure()
param sendGridApiKey string

module appInsights './app-insights.bicep' = {
  name: '${deployment().name}-appinsights'
  params: {
    location: location
    siteName: siteName
  }
}

module staticWebApp './static-web-app.bicep' = {
  name: '${deployment().name}-static-web-app'
  params: {
    location: location
    siteName: siteName
    appInsightsInstrumentationKey: appInsights.outputs.instrumentationKey
    appInsightsConnectionString: appInsights.outputs.connectionString
    msgReceiver: msgReceiver
    sendGridApiKey: sendGridApiKey
  }
}

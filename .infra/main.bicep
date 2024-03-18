param location string = 'westeurope'
param siteName string
param msgReceiver string

@secure()
param sendGridApiKey string

module appInsights './app-insights.bicep' = {
  name: '${deployment().name}-appInsights'
  params: {
    location: location
    siteName: siteName
  }
}

module staticWebApp './static-web-app.bicep' = {
  name: '${deployment().name}-staticWebApp'
  params: {
    location: location
    siteName: siteName
    appInsightsInstrumentationKey: appInsights.outputs.instrumentationKey
    appInsightsConnectionString: appInsights.outputs.connectionString
    msgReceiver: msgReceiver
    sendGridApiKey: sendGridApiKey
  }
}

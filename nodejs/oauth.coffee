request	= require "request"
qs		= require "querystring"
q 		= require "q"
fs 		= require "fs"

oauth =
	callback		: "http://photoapp.local/#oauth"
	consumer_key	: "729c28593c223ebf23a486b207bf51bb"
	consumer_secret	: "0352c5deda7f39e5"

CONSUMER_KEY	= "729c28593c223ebf23a486b207bf51bb"
CONSUMER_SECRET	= "0352c5deda7f39e5"
CALLBACK		= "http://photoapp.local/#"

requestTokenURL = "https://www.flickr.com/services/oauth/request_token"
accessTokenURL = "https://www.flickr.com/services/oauth/access_token"

API =
	requestForAuthURL: ->
		oauthObj =
			callback		: CALLBACK
			consumer_key	: CONSUMER_KEY
			consumer_secret	: CONSUMER_SECRET

		return q.nfcall(request.post, { url: requestTokenURL, oauth: oauthObj }).then (resp) ->
			body = resp[1]
			parsedData = qs.parse body

			parsedData.url = "https://www.flickr.com/services/oauth/authorize"+ "?" + qs.stringify oauth_token: parsedData.oauth_token
			parsedData

	requestForAccessToken:(authData) ->
		oauthObj =
			consumer_key	: CONSUMER_KEY
			consumer_secret	: CONSUMER_SECRET
			token			: authData.oauth_token
			token_secret	: authData.oauth_token_secret
			verifier		: authData.oauth_verifier

		console.log oauthObj
		return q.nfcall(request.post, url: accessTokenURL, oauth: oauthObj)
			.then (resp) ->
				console.log resp[0].url
				body = resp[1]
				parsedData = qs.parse body

				parsedData

module.exports = API
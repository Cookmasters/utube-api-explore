require 'http'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))

def yt_api_path(path)
  'https://www.googleapis.com/youtube/v3/' + path
end

def call_yt_url(config, url)
  HTTP.headers('Accept' => 'application/json').get(url)
end

yt_response = {}
yt_results = {}

## GOOD VIDEO SEARCH (HAPPY)
recipe_search_query = 'search?key=AIzaSyDjCoBw8PivTK6CnyF9SgZfTWdUiUc-JPA&part=snippet&q=Chicken+and+Broccoli+Stir+fry'
recipe_videos_url = yt_api_path(recipe_search_query)
yt_response[recipe_videos_url] = call_yt_url(config, recipe_videos_url)
search_results = yt_response[recipe_videos_url].parse
yt_results['kind'] = search_results['kind']
# should be youtube#searchListResponse
yt_results['etag'] = search_results['etag']
# should be cbz3lIQ2N25AfwNr-BdxUVxJ_QY/32EyxBw4e-Udgfo5Zdes-pI08F8
yt_results['nextPageToken'] = search_results['nextPageToken']
# should be CAUQAA
yt_results['regionCode'] = search_results['regionCode']
# should be TW
yt_results['pageInfo'] = search_results['pageInfo']
# should be {"totalResults"=>953401, "resultsPerPage"=>5}

videos = search_results['items']

yt_results['videos'] = videos
videos.count
# should be 5 videos array

## BAD VIDEO (SAD)
bad_recipe_search_query = 'search?key=AIzaSyDjCoBw8PivTK6CnyF9SgZfTWdUiUc-JPA&part=snippet&q=Chicken and Broccoli Stir fry'
bad_recipe_videos_url = yt_api_path(bad_recipe_search_query)
yt_response[bad_recipe_videos_url] = call_yt_url(config, bad_recipe_videos_url)

File.write('spec/fixtures/yt_response.yml', yt_response.to_yaml)
File.write('spec/fixtures/yt_results.yml', yt_results.to_yaml)

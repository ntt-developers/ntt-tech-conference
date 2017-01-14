require 'aws-sdk'
require 'json'
require 'github_api'

BUCKET = 'ntt-tech-conference-01'
REGION = 'ap-northeast-1'
TARGETS = ["assets/*/*", "images/*", "*.html"]

class AWSclient
  def initialize(key, secret)
    Aws.config.update({
        region: REGION,
        credentials: Aws::Credentials.new(key,
                                          secret)
    })
    @s3 = Aws::S3::Client.new
  end
  def publish(file, s3key)
    File.open(file, "r") {|f|
      @s3.put_object(acl: 'public-read',
                     storage_class: "REDUCED_REDUNDANCY",
                     bucket: BUCKET,
                     key: s3key, body: f)
    }
  end
end

cred = JSON.parse(File.open(ARGV[0]).read)
client = AWSclient.new(cred['key'], cred['secret'])
base_path = "http://#{BUCKET}.s3-website-#{REGION}.amazonaws.com"
hash = ENV['TRAVIS_COMMIT']

TARGETS.inject([]) {|t, path|
  t.concat Dir.glob(path)
}.each{|file|
  s3key = "#{hash}/#{file}"
  client.publish(file, s3key)
  puts "uploaded: #{base_path}/#{s3key}"
}

pr = ENV['TRAVIS_PULL_REQUEST']
if pr != "false"
  owner, repo = ENV['TRAVIS_REPO_SLUG'].split('/')
  github = Github.new oauth_token: ENV['STATUS_TOKEN']
  comment = github.issues.comments.create owner, repo, pr,
    body: "Preview: #{base_path}/#{hash}/"
  puts "commented: #{comment.html_url}"
end

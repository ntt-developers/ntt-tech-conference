require 'aws-sdk'
require 'json'
require 'github_api'
require 'mime/types'

BUCKET = 'ntt-tech-conference-02'
REGION = 'ap-northeast-1'
TARGETS = ["assets/*/*", "images/*", "images/*/*", "*.html"]

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
                     key: s3key, body: f,
                     content_type: MIME::Types.type_for(file)[0].to_s)
    }
  end
end

cred = JSON.parse(File.open(ARGV[0]).read)
client = AWSclient.new(cred['key'], cred['secret'])
base_path = "http://#{BUCKET}.s3-website-#{REGION}.amazonaws.com"
hash = ENV['TRAVIS_COMMIT']

TARGETS.inject([]) {|t, path|
  t.concat Dir.glob(path).select{|entry| not File.directory? entry }
}.each{|file|
  s3key = "#{hash}/#{file}"
  begin
    client.publish(file, s3key)
    puts "uploaded: #{base_path}/#{s3key}"
  rescue => e
    puts "failed to upload: #{base_path}/#{s3key} because #{e}"
  end
}

pr = ENV['TRAVIS_PULL_REQUEST']
if pr != "false"
  owner, repo = ENV['TRAVIS_REPO_SLUG'].split('/')
  github = Github.new oauth_token: ENV['STATUS_TOKEN']
  comment = github.issues.comments.create owner, repo, pr,
    body: "Preview: #{base_path}/#{hash}/"
  puts "commented: #{comment.html_url}"
end

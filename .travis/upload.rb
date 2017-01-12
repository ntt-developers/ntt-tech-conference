require 'aws-sdk'
require 'json'

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
hash = `git rev-parse HEAD`.chomp

TARGETS.inject([]) {|t, path|
  t.concat Dir.glob(path)
}.each{|file|
  s3key = "#{hash}/#{file}"
  client.publish(file, s3key)
  puts "uploaded: #{base_path}/#{s3key}"
}

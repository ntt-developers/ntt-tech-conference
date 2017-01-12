require 'aws-sdk'
require 'json'

cred = JSON.parse(File.open(ARGV[0], "r").read)
Aws.config.update({
  region: 'ap-northeast-1',
  credentials: Aws::Credentials.new(cred['key'],
                                    cred['secret'])
})

def publish(s3, file)
  hash = `git rev-parse HEAD`.chomp
  File.open(file, "r") {|f|
    filename = "#{hash}/#{file}"
    s3.put_object(acl: 'public-read',
                  storage_class: "REDUCED_REDUNDANCY",
                  bucket: 'ntt-tech-conference-01',
                  key: filename, body: f)
    puts "#{filename} pushed"
  }
end

targets = []
targets.concat Dir.glob("assets/*/*")
targets.concat Dir.glob("images/*")
targets.concat Dir.glob("*.html")

# upload file
s3 = Aws::S3::Client.new
targets.each{|t|
  publish(s3, t)
}

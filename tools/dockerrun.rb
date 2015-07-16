require 'yaml'
require 'pathname'

#*** BEGIN duplicate in Vagrantfile
# find and read chvdocker yaml file
$filepathYaml = ENV["CHVDOCKER_YAML"]
$filepathYaml = $filepathYaml ?
  $filepathYaml :
  Pathname.new(File.dirname(__FILE__)).parent.join('chvdocker.yaml')
chvdocker = YAML.load_file($filepathYaml)

def pathGuestFromShare(share)
    Pathname.new(share["guest"]["path"])
end
#*** END duplicate

def ArgsMiddle(chvdocker)
  argsMiddle=Array.new
  ports = chvdocker["forwarded_ports"] ? chvdocker["forwarded_ports"] : []
  ports.each do |port|
    puts("forwarded port: #{port}")
    guest = port["guest"]
    host = port["host"]
    argsMiddle.push('-p')
    argsMiddle.push("#{host}:#{guest}")
  end
  shares = chvdocker["shares"] ? chvdocker["shares"] : []
  shares.each do |share|
    adirGuest = pathGuestFromShare(share)
    argsMiddle.push('-v')
    argsMiddle.push("#{adirGuest}:#{adirGuest}")
  end
  argsMiddle
end

argsStart=['docker','run','--rm']
argsMiddle=ArgsMiddle(chvdocker)
argsEnd=['-ti']
cmd=Array.new
cmd=cmd.concat(argsStart)
cmd=cmd.concat(argsMiddle)
cmd=cmd.concat(argsEnd)
cmd=cmd.concat(ARGV)
system(*cmd)


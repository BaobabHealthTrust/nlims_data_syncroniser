require 'net/ping'
require 'socket'
require 'open3'

class Sync

  def self.sync_all
    sites = Site.by_enabled.key(true)
    configs = YAML.load_file("#{Rails.root}/config/couchdb.yml")[Rails.env]
    local_ip = self.local_ip
    
    databases = [
        configs['prefix'] + "_" + configs["suffix"],
        configs['prefix'] + "_sites_" + configs["suffix"]
    ]
    crediantials = [
              ['root','password'],
              ['root','letmein'],
              ['admin','password']
    ]
    password = nil
    username = nil
 
    sites.each do |site|        
      next if local_ip == site.host      
      if self.up?(site.host)
        crediantials.each do |cre|   
          puts cre      
          res = `curl -X GET http://"#{cre[0]}:#{cre[1]}@#{site.host}:#{site.port}/_config"`
          if res['error'].blank?
            password = cre[1]
            username = cre[0]          
            databases.each do |database|
             
              remote_address = "http://#{username}:#{password}@#{site.host}:#{site.port}/#{database}"
              local_address = "http://#{configs['username']}:#{configs['password']}@#{local_ip}:#{configs['port']}/#{database}"

              `curl -X POST  http://localhost:5984/_replicate -d '{"source":"#{remote_address}","target":"#{local_address}", "continuous":true}' -H "Content-Type: application/json"`

              if (configs['bidirectional_sync'].to_s rescue nil) == "true"
                `curl -X POST  http://localhost:5984/_replicate -d '{"source":"#{local_address}","target":"#{remote_address}", "continuous":true}' -H "Content-Type: application/json"`
              end
            end
          end
        end
        password = nil
        username = nil
      end
    end
  end

  def self.up?(host, port=5984)
    a, b, c = Open3.capture3("nc -vw 3 #{host} #{port}")
    b.scan(/succeeded/).length > 0
  end

  def self.local_ip
    self.private_ipv4.ip_address rescue (self.public_ipv4.ip_address rescue nil)
  end

  def self.private_ipv4
    Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
  end

  def self.public_ipv4
    Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?}
  end
end

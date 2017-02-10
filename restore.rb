#!/bin/ruby

env = "db1"
postgresl_data_path = "/var/lib/pgsql/data"
postgresql_ip = "192.168.100.109"

def get_value(env,replace_word)

  backup_id = `barman show-backup #{env} latest | grep "#{replace_word}" -m 1`
  backup_id.sub!("#{replace_word}","").sub!(":","").gsub(/\s+/, '')

end

def restore(env,postgresl_data_path,postgresql_ip)

  backup_id = get_value("#{env}","Backup")
  begin_time = get_value("#{env}","Begin time")

  `systemctl stop postgresql`
  #exe("barman recover --target-time \"#{begin_time}\"  --remote-ssh-command \"ssh postgres@#{postgresql_ip}\"   #{env}   #{backup_id}  #{postgresl_data_path}")
  b = `barman recover   --remote-ssh-command "ssh postgres@#{postgresql_ip}"   #{env}   #{backup_id}  #{postgresl_data_path} `
  `systemctl start postgresql`
  #b = "ccbarman recover --target-time \"#{begin_time}\"  --remote-ssh-command \"ssh postgres@#{postgresql_ip}\"   #{env}   #{backup_id}  #{postgresl_data_path} "
  p b
end

restore(env,postgresl_data_path,postgresql_ip)

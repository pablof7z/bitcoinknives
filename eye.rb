BASE = File.expand_path(File.join(File.dirname(__FILE__)))

Eye.config do
  logger "#{BASE}/log/eye.log"
end

def run_daemon(name)
  working_dir BASE

  process name do
    pid_file "#{BASE}/tmp/pids/#{name}.pid"
    start_command "rails runner daemons/#{name}/main.rb"

    daemonize true
    stdall "#{BASE}/log/#{name}.log"
  end
end

Eye.application 'bitcoin-knives' do
  group 'daemons' do
    run_daemon :price_fetcher
    run_daemon :sat_stacker
  end
end

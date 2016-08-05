require "mkpb/ssh/version"

module MKPB
  module SSH
  	def ssh_run(cmd:,username: (self.respond_to?(:user) and self.user.symbol or "root") )

          ret = {}

          Net::SSH.start(self.symbol, username ,password:nil) do |ssh|

                channel = ssh.open_channel do |ch|
                        ch.exec cmd do |ch, success|
                                raise "could not execute command: \"#{cmd}\"" unless success

                                ch.on_data do |c, data|
                                        ret[:stdout] = data
                                end

                                ch.on_extended_data do |c, type, data|
                                        ret[:stderr] = data
                                end

                                ch.on_request("exit-status") do |_,data|
                                        ret[:exit_code] = data.read_long
                                end

                                ch.on_request("exit-signal") do |_, data|
                                        ret[:exit_signal] = data.read_long
                                end

                                ch.on_close { }
                        end
                end

                channel.wait
          end

          ret
  	end
  end
end

require "mkpb/ssh/version"

module MKPB
  class Ssh
	def cmd(user:,host:,cmd:,gunzip:nil)
                `ssh #{user}@#{host} "#{cmd}#{gunzip ? "|gunzip" : ""}"`
        end
  end
end

#
# Rakefile to build Pong game for LOVE engine.
#

task :default => [:build, :test]
task :travis => [:deps, :build, :test, :clean]

task :deps do
	puts "Installing 7-Zip..."
	sh "sudo apt-get install p7zip-full"
	puts "Installing LOVE engine..."
	sh "sudo apt-get install love"
end

task :build do
	sh "7z a -tzip Pong.love LICENSE main.lua ball.lua paddle.lua ai.lua net-paddle.lua net-client.lua scoreboard.lua announcer.lua screentip.lua sfx"
end

task :test do
	puts "Running Pong with LOVE engine..."
	sh "love Pong.love"
end

task :clean do
	puts "Deleting Pong.love..."
	File.delete("Pong.love")
end

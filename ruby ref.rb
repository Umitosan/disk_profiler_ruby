# FILE



# DIR

Dir.entries(".")
#  => ["file","dir","file","file"]

Dir.pwd
# => "c:/users/umi/desktop"

Dir.ftype(".")
# => "directory"
Dir.ftype("./myFile.rb")
# => "file"

# name: tools
# version: 0.2.2
# author: Muhlis Budi Cahyono
# url: https://github.com/ryanerwin/discourse-tools-plugin

after_initialize {

  load File.expand_path("../lib/tools.rb", __FILE__)

}

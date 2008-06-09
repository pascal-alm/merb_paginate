Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")
$LOAD_PATH.unshift(Merb.root / "lib")

Merb::Config.use do |c|
  c[:session_secret_key]  = '830160ac1263802e94ba4fd1f8e88ef6b3c7b790'
  c[:session_store] = 'cookie'
end  

use_orm :datamapper
use_test :rspec

dependencies 'merb-haml', 'dm-aggregates', 'merb_paginate'

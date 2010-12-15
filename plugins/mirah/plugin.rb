Plugin.define do
  name    "mirah"
  version "0.1"
  file    "lib", "syntax_check", "mirah_check"
  object  "Redcar::SyntaxCheck::MirahCheck"
  dependencies "syntax_check", ">0"
end

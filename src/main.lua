<<<<<<< HEAD
=======

>>>>>>> dev_txf
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

<<<<<<< HEAD
require("LuaPanda").start("127.0.0.1", 8818)
package.path = package.path .. ";src/?.lua;src/framework/protobuf/?.lua;"
=======
package.path = package.path .. ";src/?.lua;src/framework/protobuf/?.lua"
>>>>>>> dev_txf
require("app.MyApp").new():run()

using Genie

import AdminController



route("/admin", AdminController.index; method = GET, named = :admin)
route("/admin/:model::String", AdminController.create; method = POST, named = :admin_model_create)
route("/admin/:model::String/:id::Int", AdminController.read; method = GET, named = :admin_model_read)
route("/admin/:model::String/:id::Int", AdminController.update; method = POST, named = :admin_model_update)
route("/admin/:model::String/:id::Int/delete", AdminController.delete; method = GET, named = :admin_model_delete)
route("/admin/:model::String", AdminController.list; method = GET, named = :admin_model_list)

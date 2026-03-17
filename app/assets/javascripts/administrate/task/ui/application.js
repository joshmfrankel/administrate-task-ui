import { Application } from "@hotwired/stimulus";

import AddArgInputsController from "./controllers/add_arg_inputs_controller";
import ViewSourceCodeController from "./controllers/view_source_code_controller";

const app = Application.start();
app.register("administrate-task-ui-view-source-code", ViewSourceCodeController);
app.register("administrate-task-ui-add-arg-inputs", AddArgInputsController);

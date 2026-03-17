import { Application } from "@hotwired/stimulus";

import ViewSourceCodeController from "./controllers/view_source_code_controller";

const app = Application.start();
app.register("administrate-task-ui-view-source-code", ViewSourceCodeController);

module app {
    requires javafx.controls;
    requires javafx.graphics;
    requires java.sql;
    requires javafx.fxml;
    exports app;
    opens app;
}
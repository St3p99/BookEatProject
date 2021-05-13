package unical.dimes.psw2021.server.support.exception;

import unical.dimes.psw2021.server.model.TableService;

public class TableServiceOverlapException extends Exception {
    private TableService tableService;

    public TableServiceOverlapException(TableService tableService) {
        this.tableService = tableService;
    }

    public TableServiceOverlapException(String message, TableService tableService) {
        super(message);
        this.tableService = tableService;
    }

    public TableService getTableService() {
        return tableService;
    }

    public void setTableService(TableService ts) {
        tableService = ts;
    }
}

package unical.dimes.psw2021.server.support;

public final class ResponseMessage {
    public static final String NO_RESULT = "No results!";
    private String message;

    public ResponseMessage(String message) {
        this.message = message;
    }

    public String getMessage() {
        return message;
    }
}

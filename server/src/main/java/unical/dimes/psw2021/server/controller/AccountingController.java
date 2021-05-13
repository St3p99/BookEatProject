package unical.dimes.psw2021.server.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.keycloak.OAuth2Constants;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import unical.dimes.psw2021.server.model.Reservation;
import unical.dimes.psw2021.server.model.User;
import unical.dimes.psw2021.server.service.AccountingService;
import unical.dimes.psw2021.server.support.ResponseMessage;
import unical.dimes.psw2021.server.support.exception.UniqueKeyViolationException;

import javax.validation.Valid;

import java.util.List;

import static org.springframework.beans.support.PagedListHolder.DEFAULT_PAGE_SIZE;

@RestController
@RequestMapping("${base.url}/users")
public class AccountingController {
    private final AccountingService accountingService;


    @Autowired
    public AccountingController(AccountingService accountingService) {
        this.accountingService = accountingService;
    }


    /**
     * POST OPERATION
     **/
    @PostMapping(path = "/new")
    public ResponseEntity create(@RequestBody @Valid User user, @RequestParam(value = "pwd") String pwd) {
        try {
            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(accountingService.registerUser(user, pwd));
        } catch (UniqueKeyViolationException e) {
            return new ResponseEntity<>(new ResponseMessage("ERROR_MAIL_USER_ALREADY_EXISTS"), HttpStatus.CONFLICT);
        }
    }

    /**
     * GET OPERATION
     **/
    @GetMapping("/{id}")
    public ResponseEntity getUser(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(accountingService.getById(id));
        } catch (ResourceNotFoundException e) {
            return new ResponseEntity<>(
                    new ResponseMessage("User not found!"),
                    HttpStatus.NOT_FOUND);
        }
    }

    @Operation(summary = "Return reservations of the user with id")
    @GetMapping(path = "/{id}/reservations")
    public ResponseEntity getReservations(@PathVariable Long id){
        try {
            List<Reservation> result = accountingService.showReservations(id);
            if (result.size() <= 0)
                return ResponseEntity.noContent().build();
            return ResponseEntity.ok(result);
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }//getReservations

    /**
     * DELETE OPERATION
     **/
    @DeleteMapping("/delete/{id}")
    public ResponseEntity deleteUser(@PathVariable Long id){
        accountingService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }


}

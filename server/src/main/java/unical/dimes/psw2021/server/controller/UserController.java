package unical.dimes.psw2021.server.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import unical.dimes.psw2021.server.model.Reservation;
import unical.dimes.psw2021.server.model.Restaurant;
import unical.dimes.psw2021.server.model.Review;
import unical.dimes.psw2021.server.model.User;
import unical.dimes.psw2021.server.service.AccountingService;
import unical.dimes.psw2021.server.service.UserService;
import unical.dimes.psw2021.server.support.ResponseMessage;
import unical.dimes.psw2021.server.support.exception.PostingDateTimeException;
import unical.dimes.psw2021.server.support.exception.UniqueKeyViolationException;

import javax.validation.Valid;

import java.util.List;

@RestController
@RequestMapping("${base-url}/users")
//@PreAuthorize("hasAuthority('user')")
public class UserController {
    private final AccountingService accountingService;
    private final UserService userService;


    @Autowired
    public UserController(AccountingService accountingService, UserService userService) {
        this.accountingService = accountingService;
        this.userService = userService;
    }


    /**
     * POST OPERATION
     **/
    @Operation(method="newUser", summary = "Create a new user")
    @PostMapping(path = "/new")
    public ResponseEntity newUser(@RequestBody @Valid User user, BindingResult bindingResult, @RequestParam(value = "pwd") String pwd) {
        if (bindingResult.hasErrors()) return ResponseEntity.badRequest().build();
        try {
            User created = userService.addUser(user);
            accountingService.registerUser(created, pwd);
            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(created);
        } catch (UniqueKeyViolationException e) {
            return new ResponseEntity<>(new ResponseMessage("ERROR_MAIL_USER_ALREADY_EXISTS"), HttpStatus.CONFLICT);
        }
    }

    @Operation(method="postReview", summary = "Post a review")
    @PostMapping(path = "/post-review")
    public ResponseEntity postReview(@RequestBody @Valid Review review, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) return ResponseEntity.badRequest().build();

        try{
            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(userService.postReview(review));
        }catch (UniqueKeyViolationException e){
            return new ResponseEntity<>(new ResponseMessage("ERROR_REVIEW_ALREADY_EXISTS"), HttpStatus.CONFLICT);
        }catch (PostingDateTimeException e){
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * GET OPERATION
     **/
    @Operation(method="getUser")
    @GetMapping("/{user_id}")
    public ResponseEntity getUser(@PathVariable("user_id") Long id) {
        try {
            return ResponseEntity.ok(userService.getById(id));
        } catch (ResourceNotFoundException e) {
            return new ResponseEntity<>(
                    new ResponseMessage("User not found!"),
                    HttpStatus.NOT_FOUND);
        }
    }

    @Operation(method = "getReservations", summary = "Return reservations of the user with user_id")
    @GetMapping(path = "/reservations/{user_id}")
    public ResponseEntity getReservations(@PathVariable("user_id") Long id){
        try {
            List<Reservation> result = userService.showReservations(id);
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
    @Operation(method = "deleteUser", summary = "Delete a user")
    @DeleteMapping("/delete/{id}")
    public ResponseEntity deleteUser(@PathVariable Long id){
        accountingService.deleteUser(id);
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }


}

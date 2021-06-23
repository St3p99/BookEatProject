package unical.dimes.psw2021.server.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import unical.dimes.psw2021.server.model.Reservation;
import unical.dimes.psw2021.server.model.TableService;
import unical.dimes.psw2021.server.service.ReservationService;
import unical.dimes.psw2021.server.service.RestaurantService;
import unical.dimes.psw2021.server.service.UserService;
import unical.dimes.psw2021.server.support.exception.SeatsUnavailable;
import unical.dimes.psw2021.server.support.exception.UniqueKeyViolationException;

import javax.persistence.OptimisticLockException;
import javax.validation.Valid;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Collections;
import java.util.List;

@RestController
@RequestMapping("${base-url}/booking")
public class ReservationController {
    private final RestaurantService restaurantService;
    private final ReservationService reservationService;
    private final UserService userService;

    @Autowired
    public ReservationController(RestaurantService restaurantService, ReservationService reservationService, UserService userService) {
        this.restaurantService = restaurantService;
        this.reservationService = reservationService;
        this.userService = userService;
    }

    /**
     * POST OPERATION
     **/
    @PreAuthorize("hasAnyAuthority('user', 'restaurant_manager')")
    @Operation(method = "newReservation", summary = "Create a new Reservation")
    @PostMapping(path = "/new")
    public ResponseEntity newReservation(
            @RequestBody @Valid Reservation reservation, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) return ResponseEntity.badRequest().build();
        try {
            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(reservationService.addReservation(reservation));
        } catch (UniqueKeyViolationException e) {
            return ResponseEntity
                    .status(HttpStatus.CONFLICT)
                    .body("ERROR_RESERVATION_ALREADY_EXIST");
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        } catch (SeatsUnavailable e) {
            return ResponseEntity
                    .status(HttpStatus.CONFLICT)
                    .body("ERROR_SEATS_UNAVAILABLE");
        } catch (OptimisticLockException e) {
            return ResponseEntity
                    .status(HttpStatus.LOCKED)
                    .body("ERROR_RESOURCE_LOCKED");
        }
    }

    /**
     * GET OPERATION
     **/
    @PreAuthorize("hasAuthority('user')")
    @Operation(method = "getTableServicesByDate", summary = "Return table service available on date for the restauraunt with id")
    @GetMapping(path = "/services")
    public ResponseEntity getTableServicesByDate(
            @RequestParam("restaurant_id") Long restaurantId,
            @RequestParam(name = "date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        try {
            List<TableService> result = restaurantService.showTableServicesByDay(restaurantId, date.getDayOfWeek());
            if (result.size() <= 0)
                return ResponseEntity.noContent().build();
            else {
                Collections.sort(result);
                return ResponseEntity.ok(result);
            }
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }//getTableServices

    @PreAuthorize("hasAuthority('user')")
    @Operation(method = "getSeatsAvailable", summary = "Returns number of seats available")
    @GetMapping(path = "/availability")
    public ResponseEntity getSeatsAvailable(
            @RequestParam(name = "service_id") Long serviceId,
            @RequestParam(name = "date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @RequestParam(name = "time") @DateTimeFormat(pattern = "HH:mm:ss") LocalTime time) {
        try {
            return ResponseEntity.ok(reservationService.getSeatsAvailable(serviceId, date, time));
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * DELETE OPERATION
     **/
    @PreAuthorize("hasAuthority('user')")
    @Operation(method = "deleteReservation", summary = "Delete a reservation")
    @DeleteMapping(path = "/delete/{id}")
    public ResponseEntity deleteReservation(@PathVariable Long id) {
        userService.deleteReservation(id);
        return ResponseEntity.noContent().build();
    }
}

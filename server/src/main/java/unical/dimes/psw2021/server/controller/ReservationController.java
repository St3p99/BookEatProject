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
import unical.dimes.psw2021.server.support.exception.SeatsUnavailable;
import unical.dimes.psw2021.server.support.exception.UniqueKeyViolationException;

import javax.persistence.OptimisticLockException;
import javax.validation.Valid;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@RestController
@RequestMapping("${base.url}/booking")
@PreAuthorize("hasAnyAuthority('user', 'restaurant_manager')")
public class ReservationController {
    private final RestaurantService restaurantService;
    private final ReservationService reservationService;

    @Autowired
    public ReservationController(RestaurantService restaurantService, ReservationService reservationService) {
        this.restaurantService = restaurantService;
        this.reservationService = reservationService;
    }

    /**
     * POST OPERATION
     **/
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
        } catch ( OptimisticLockException e ){
            return ResponseEntity
                    .status(HttpStatus.LOCKED)
                    .body("ERROR_RESOURCE_LOCKED");
        }
    }

    /**
     * GET OPERATION
     **/
    @Operation(method = "getTableServicesByDate", summary = "Return table service available on date for the restauraunt with id")
    @GetMapping(path = "/{restaurantId}/services/{date}")
    public ResponseEntity getTableServicesByDate(
            @PathVariable Long restaurantId,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        try {
            List<TableService> result = restaurantService.showTableServicesByDay(restaurantId, date.getDayOfWeek());
            if (result.size() <= 0)
                return ResponseEntity.noContent().build();
            return ResponseEntity.ok(result);
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }//getTableServices

    @Operation(method = "getAvailability", summary = "Returns availability")
    @GetMapping(path = "/availability/{serviceId}/{date}/{time}/{nGuests}")
    public ResponseEntity getAvailability(
            @PathVariable Long serviceId,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @PathVariable @DateTimeFormat(pattern = "HH:mm:ss") LocalTime time,
            @PathVariable int nGuests) {
        try {
            return ResponseEntity.ok(reservationService.getAvailability(serviceId, date, time, nGuests));
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }
    /** PUT OPERATION **/
    /** DELETE OPERATION **/
}

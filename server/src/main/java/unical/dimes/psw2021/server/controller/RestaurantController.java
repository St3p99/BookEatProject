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
import unical.dimes.psw2021.server.model.Restaurant;
import unical.dimes.psw2021.server.model.TableService;
import unical.dimes.psw2021.server.service.RestaurantService;
import unical.dimes.psw2021.server.support.ResponseMessage;
import unical.dimes.psw2021.server.support.exception.TableServiceOverlapException;
import unical.dimes.psw2021.server.support.exception.UniqueKeyViolationException;
import javax.validation.Valid;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping(path = "${base.url}/restaurants")
@PreAuthorize("hasAuthority('restaurant_manager')")
public class RestaurantController {
    private final RestaurantService restaurantService;

    @Autowired
    public RestaurantController(RestaurantService restaurantService) {
        this.restaurantService = restaurantService;
    }

    /**
     * POST OPERATION
     ***/
    @Operation(method = "newRestaurant")
    @PostMapping("/new")
    public ResponseEntity newRestaurant(@RequestBody @Valid Restaurant restaurant) {
        try {
            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(restaurantService.addRestaurant(restaurant));
        } catch (UniqueKeyViolationException e) {
            return new ResponseEntity<>(
                    new ResponseMessage("ERROR_RESTAURANT_ALREADY_EXIST"),
                    HttpStatus.CONFLICT);
        }
    }//newRestaurant

    @Operation(method = "newTableService")
    @PostMapping(value = "/{id}/services/new")
    public ResponseEntity newTableService(@PathVariable Long id, @RequestBody @Valid TableService tableService, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) return ResponseEntity.badRequest().build();

        try {
            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(restaurantService.addTableService(id, tableService));
        } catch (UniqueKeyViolationException e) {
            return new ResponseEntity<>(
                    new ResponseMessage("ERROR_SERVICE_ALREADY_EXIST"),
                    HttpStatus.CONFLICT);
        } catch (TableServiceOverlapException e) {
            return new ResponseEntity(
                    e.getTableService(),
                    HttpStatus.CONFLICT);
        } catch (ResourceNotFoundException e) {
            return new ResponseEntity<>(
                    new ResponseMessage("ERROR_RESTAURANT_NOT_FOUND"),
                    HttpStatus.NOT_FOUND);
        }
    }

    /**
     * GET OPERATION
     ***/
    @Operation(method = "getTableServices", summary = "Return all table service of the restauraunt with id")
    @GetMapping(path = "/{id}/services")
    public ResponseEntity getTableServices(@PathVariable Long id) {
        try {
            List<TableService> result = restaurantService.showTableServices(id);
            if (result.size() <= 0)
                return ResponseEntity.noContent().build();
            return ResponseEntity.ok(result);
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }//getTableServices

    @Operation(method = "getReservationsByRestaurantAndDate", summary = "Return reservations of the restauraunt with id")
    @GetMapping(path = "/{id}/reservations/{date}")
    public ResponseEntity getReservationsByRestaurantAndDate(
            @PathVariable Long id,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date
            ){
        try {
            List<Reservation> result = restaurantService.showReservationsByRestaurantAndDate(id, date);
            if (result.size() <= 0)
                return ResponseEntity.noContent().build();
            return ResponseEntity.ok(result);
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }//getReservations

    /**
     * PUT OPERATION
     ***/

    /**
     * DELETE OPERATION
     ***/
    @Operation(method = "rejectReservation", summary = "Reject a reservation")
    @DeleteMapping(path = "/reservations/delete/{id}")
    public ResponseEntity rejectReservation(@PathVariable Long id) {
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).build();
        //        restaurantService.rejectReservation(id);
        //        return ResponseEntity.noContent().build();
        //TODO
    }

    @Operation(method = "deleteRestaurant", summary = "Delete restaurant")
    @DeleteMapping(path = "/delete/{id}")
    public ResponseEntity deleteRestaurant(@PathVariable Long id) {
        restaurantService.deleteRestaurant(id);
        return ResponseEntity.noContent().build();
    }

    @Operation(method = "deleteTableService", summary = "Delete a table service")
    @DeleteMapping(path = "/services/delete/{id}")
    public ResponseEntity deleteTableService(@PathVariable Long id) {
        restaurantService.deleteTableService(id);
        return ResponseEntity.noContent().build();
    }

}

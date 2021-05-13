package unical.dimes.psw2021.server.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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

import static org.springframework.beans.support.PagedListHolder.DEFAULT_PAGE_SIZE;

@RestController
@RequestMapping(path = "${base.url}/restaurants")
public class RestaurantController {
    private final RestaurantService restaurantService;

    @Autowired
    public RestaurantController(RestaurantService restaurantService) {
        this.restaurantService = restaurantService;
    }

    /**
     * POST OPERATION
     ***/
    @Operation(summary = "Add new restaurant")
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

    @Operation(summary = "Add new table service")
    @PostMapping(value = "/{id}/services/new")
    public ResponseEntity newTableService(@PathVariable Long id, @RequestBody @Valid TableService tableService) {
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
    @Operation(summary = "Return all table service of the restauraunt with id")
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

    @Operation(summary = "Return reservations of the restauraunt per table service with id")
    @GetMapping(path = "/{id}/reservations/{date}")
    public ResponseEntity getReservationsByServiceAndDate(
            @PathVariable Long id,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date
            ){
        try {
            List<Reservation> result = restaurantService.showReservationsByServiceAndDate(id, date);
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
    @Operation(summary = "Reject a reservation")
    @DeleteMapping(path = "/reservations/delete/{id}")
    public ResponseEntity rejectReservation(@PathVariable Long id) {
        restaurantService.rejectReservation(id);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Delete restaurant")
    @DeleteMapping(path = "/delete/{id}")
    public ResponseEntity deleteRestaurant(@PathVariable Long id) {
        restaurantService.deleteRestaurant(id);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Delete a table service")
    @DeleteMapping(path = "/services/delete/{id}")
    public ResponseEntity deleteTableService(@PathVariable Long id) {
        restaurantService.deleteTableService(id);
        return ResponseEntity.noContent().build();
    }

}

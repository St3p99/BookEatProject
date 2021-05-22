package unical.dimes.psw2021.server.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import unical.dimes.psw2021.server.model.Reservation;
import unical.dimes.psw2021.server.model.Restaurant;
import unical.dimes.psw2021.server.model.Review;
import unical.dimes.psw2021.server.service.RestaurantService;

import java.time.LocalDate;
import java.util.List;

import static org.springframework.beans.support.PagedListHolder.DEFAULT_PAGE_SIZE;

@RestController
@RequestMapping(path = "${base-url}/search")
public class SearchController {
    private final RestaurantService restaurantService;

    @Autowired
    public SearchController(RestaurantService restaurantService) {
        this.restaurantService = restaurantService;
    }

    /**
     * GET OPERATION
     **/
    @Operation(method = "getByNameAndCity", summary = "Search for restaurants by name and city then return paged content")
    @GetMapping(path = "/paged/byNameAndCity")
    public ResponseEntity getByNameAndCity(
            @RequestParam(value = "name") String name,
            @RequestParam(value = "city") String city,
            @RequestParam(value = "pageNumber",
                    defaultValue = "0") int pageNumber,
            @RequestParam(value = "pageSize",
                    defaultValue = DEFAULT_PAGE_SIZE + "") int pageSize,
            @RequestParam(value = "sortBy",
                    defaultValue = "id") String sortBy) {
        List<Restaurant> result = restaurantService.
                showRestaurantByNameAndCity(name, city, pageNumber, pageSize, sortBy);
        if (result.size() <= 0)
            return ResponseEntity.noContent().build();
        return ResponseEntity.ok(result);
    }//getByNameAndCity

    @Operation(method = "getPagedByCity", summary = "Search for restaurants by city and return paged content")
    @GetMapping(path = "/paged/byCity")
    public ResponseEntity getPagedByCity(
            @RequestParam(value = "city") String city,
            @RequestParam(value = "pageNumber",
                    defaultValue = "0") int pageNumber,
            @RequestParam(value = "pageSize",
                    defaultValue = DEFAULT_PAGE_SIZE + "") int pageSize,
            @RequestParam(value = "sortBy",
                    defaultValue = "id") String sortBy) {
        List<Restaurant> result = restaurantService.showRestaurantPagedByCity(city, pageNumber, pageSize, sortBy);
        if (result.size() <= 0)
            return ResponseEntity.noContent().build();
        return ResponseEntity.ok(result);
    }//getByCity

    @Operation(method = "getbyCity", summary = "Search for restaurants by city")
    @GetMapping(path = "/byCity")
    public ResponseEntity getByCity(@RequestParam(value = "city") String city) {
        System.out.println("getByCity: "+city);
        List<Restaurant> result = restaurantService.showRestaurantByCity(city);
        if (result.size() <= 0)
            return ResponseEntity.noContent().build();
        return ResponseEntity.ok(result);
    }//getByCity


    @Operation(method = "getReviewsByRestaraunt")
    @GetMapping(path = "/review/{id}")
    public ResponseEntity getReviewByRestaurant(
            @PathVariable Long id){
        System.out.println("getReviews: "+id);
        try {
            List<Review> result = restaurantService.showReview(id);
            System.out.println(result);
            if (result.size() <= 0)
                return ResponseEntity.noContent().build();
            return ResponseEntity.ok(result);
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }//getReservations
}

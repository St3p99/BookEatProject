package unical.dimes.psw2021.server.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import unical.dimes.psw2021.server.model.Restaurant;
import unical.dimes.psw2021.server.service.RestaurantService;

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

    @Operation(method = "getbyCity", summary = "Search for restaurants by city and return paged content")
    @GetMapping(path = "/paged/byCity")
    public ResponseEntity getByCity(
            @RequestParam(value = "city") String city,
            @RequestParam(value = "pageNumber",
                    defaultValue = "0") int pageNumber,
            @RequestParam(value = "pageSize",
                    defaultValue = DEFAULT_PAGE_SIZE + "") int pageSize,
            @RequestParam(value = "sortBy",
                    defaultValue = "id") String sortBy) {
        List<Restaurant> result = restaurantService.showRestaurantByCity(city, pageNumber, pageSize, sortBy);
        if (result.size() <= 0)
            return ResponseEntity.noContent().build();
        return ResponseEntity.ok(result);
    }//getByCity
}

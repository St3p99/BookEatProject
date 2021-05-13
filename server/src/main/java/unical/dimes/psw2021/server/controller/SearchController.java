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
@RequestMapping(path = "${base.url}/search")
public class SearchController {
    private final RestaurantService restaurantService;

    @Autowired
    public SearchController(RestaurantService restaurantService) {
        this.restaurantService = restaurantService;
    }

    /**
     * GET OPERATION
     **/
    @Operation(summary = "Search for restaurants by name and country then return paged content")
    @GetMapping(path = "/paged/byNameAndCountry")
    public ResponseEntity getByNameAndCountry(
            @RequestParam(value = "name") String name,
            @RequestParam(value = "country") String country,
            @RequestParam(value = "pageNumber",
                    defaultValue = "0") int pageNumber,
            @RequestParam(value = "pageSize",
                    defaultValue = DEFAULT_PAGE_SIZE + "") int pageSize,
            @RequestParam(value = "sortBy",
                    defaultValue = "id") String sortBy) {
        List<Restaurant> result = restaurantService.
                showRestaurantByNameAndCountry(name, country, pageNumber, pageSize, sortBy);
        if (result.size() <= 0)
            return ResponseEntity.noContent().build();
        return ResponseEntity.ok(result);
    }//getByNameAndCountry

    @Operation(summary = "Search for restaurants by country and return paged content")
    @GetMapping(path = "/paged/byCountry")
    public ResponseEntity getByCountry(
            @RequestParam(value = "country") String country,
            @RequestParam(value = "pageNumber",
                    defaultValue = "0") int pageNumber,
            @RequestParam(value = "pageSize",
                    defaultValue = DEFAULT_PAGE_SIZE + "") int pageSize,
            @RequestParam(value = "sortBy",
                    defaultValue = "id") String sortBy) {
        List<Restaurant> result = restaurantService.showRestaurantByCountry(country, pageNumber, pageSize, sortBy);
        if (result.size() <= 0)
            return ResponseEntity.noContent().build();
        return ResponseEntity.ok(result);
    }//getByCountry

}

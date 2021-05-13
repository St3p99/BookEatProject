package unical.dimes.psw2021.server.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import unical.dimes.psw2021.server.model.Restaurant;

@Repository
public interface RestaurantRepository extends JpaRepository<Restaurant, Long> {
    Page<Restaurant> findByNameIgnoreCaseContainingAndCountryIgnoreCase(String name, String country, Pageable pageable);

    Page<Restaurant> findByCountryIgnoreCase(String country, Pageable pageable);

    boolean existsByNameAndCityAndAddress(String name, String city, String address);
}

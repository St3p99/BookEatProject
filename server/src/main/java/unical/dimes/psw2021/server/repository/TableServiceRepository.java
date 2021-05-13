package unical.dimes.psw2021.server.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.stereotype.Repository;
import unical.dimes.psw2021.server.model.Restaurant;
import unical.dimes.psw2021.server.model.TableService;

import java.util.List;
import java.util.Optional;

@Repository
public interface TableServiceRepository extends JpaRepository<TableService, Long> {
    Optional<TableService> findByServiceNameAndRestaurant(String serviceName, Restaurant restaurant);

    List<TableService> findByRestaurant(Restaurant restaurant);
}

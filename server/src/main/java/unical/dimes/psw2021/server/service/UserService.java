package unical.dimes.psw2021.server.service;

import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import unical.dimes.psw2021.server.model.User;
import unical.dimes.psw2021.server.repository.UserRepository;

@Service
public class UserService {


    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public User getById(Long id) throws ResourceNotFoundException {
        return userRepository.findById(id).
                orElseThrow(ResourceNotFoundException::new);
    }
}

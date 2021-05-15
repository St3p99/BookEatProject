package unical.dimes.psw2021.server.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import unical.dimes.psw2021.server.model.Reservation;
import unical.dimes.psw2021.server.model.Review;
import unical.dimes.psw2021.server.model.TableService;
import unical.dimes.psw2021.server.model.User;
import unical.dimes.psw2021.server.repository.ReservationRepository;
import unical.dimes.psw2021.server.repository.ReviewRepository;
import unical.dimes.psw2021.server.repository.UserRepository;
import unical.dimes.psw2021.server.support.exception.PostingDateTimeException;
import unical.dimes.psw2021.server.support.exception.UniqueKeyViolationException;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final ReviewRepository reviewRepository;
    private final ReservationRepository reservationRepository;

    @Autowired
    public UserService(UserRepository userRepository, ReviewRepository reviewRepository, ReservationRepository reservationRepository) {
        this.userRepository = userRepository;
        this.reviewRepository = reviewRepository;
        this.reservationRepository = reservationRepository;
    }

    @Transactional
    public User addUser(User user) throws UniqueKeyViolationException {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new UniqueKeyViolationException();
        }

        return userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public User getById(Long id) throws ResourceNotFoundException {
        return userRepository.findById(id).
                orElseThrow(ResourceNotFoundException::new);
    }

    public List<Reservation> showReservations(Long id) throws ResourceNotFoundException {
        Optional<User> optUser = userRepository.findById(id);
        if(optUser.isEmpty()) throw new ResourceNotFoundException();

        return optUser.get().getReservations();
    }

    @Transactional
    public Review postReview(Review review) throws UniqueKeyViolationException, PostingDateTimeException {
        Optional<Reservation> optReservation = reservationRepository.findByIdAndRejectedFalse(review.getReservation().getId());
        if (optReservation.isEmpty()) throw new ResourceNotFoundException();
        Reservation reservation = optReservation.get();

        //check posting after 12h + reservation date and time
        LocalDateTime reservationDateTime = LocalDateTime.of(reservation.getDate(), reservation.getStartTime());
        if( LocalDateTime.now().minusHours(12).compareTo(reservationDateTime) < 0 ){
            throw new PostingDateTimeException();
        }

        if (reviewRepository.existsByReservation(reservation)) throw new UniqueKeyViolationException();
        review.setReservation(reservation);

        return reviewRepository.save(review);
    }

    @Transactional
    public void deleteReservation(Long id) {
        Optional<Reservation> opt = reservationRepository.findById(id);
        if (opt.isEmpty()) return;
        reservationRepository.delete(opt.get());
    }

    @Transactional
    public void deleteUser(Long id) {
        Optional<User> opt = userRepository.findById(id);
        if (opt.isEmpty()) return;
        userRepository.delete(opt.get());
    }
}

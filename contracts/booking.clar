;; Booking Contract
;; Manages reservations for container space

(define-data-var last-booking-id uint u0)

(define-map bookings
  { booking-id: uint }
  {
    container-id: uint,
    customer: principal,
    from-location: (string-ascii 50),
    to-location: (string-ascii 50),
    departure-date: uint,
    arrival-date: uint,
    cargo-description: (string-ascii 100),
    cargo-weight: uint,
    status: (string-ascii 20),
    payment-amount: uint,
    payment-status: (string-ascii 20)
  }
)

(define-public (create-booking
    (container-id uint)
    (from-location (string-ascii 50))
    (to-location (string-ascii 50))
    (departure-date uint)
    (arrival-date uint)
    (cargo-description (string-ascii 100))
    (cargo-weight uint)
    (payment-amount uint))
  (let
    ((new-id (+ (var-get last-booking-id) u1)))
    (begin
      (var-set last-booking-id new-id)
      (map-set bookings
        { booking-id: new-id }
        {
          container-id: container-id,
          customer: tx-sender,
          from-location: from-location,
          to-location: to-location,
          departure-date: departure-date,
          arrival-date: arrival-date,
          cargo-description: cargo-description,
          cargo-weight: cargo-weight,
          status: "pending",
          payment-amount: payment-amount,
          payment-status: "unpaid"
        }
      )
      (ok new-id)
    )
  )
)

(define-read-only (get-booking (booking-id uint))
  (map-get? bookings { booking-id: booking-id })
)

(define-public (update-booking-status (booking-id uint) (new-status (string-ascii 20)))
  (let ((booking (map-get? bookings { booking-id: booking-id })))
    (if (is-some booking)
      (begin
        (map-set bookings
          { booking-id: booking-id }
          (merge (unwrap-panic booking) { status: new-status })
        )
        (ok true)
      )
      (err u404) ;; Not found
    )
  )
)

(define-public (confirm-payment (booking-id uint))
  (let ((booking (map-get? bookings { booking-id: booking-id })))
    (if (is-some booking)
      (begin
        (map-set bookings
          { booking-id: booking-id }
          (merge (unwrap-panic booking) { payment-status: "paid" })
        )
        (ok true)
      )
      (err u404) ;; Not found
    )
  )
)

(define-public (cancel-booking (booking-id uint))
  (let ((booking (map-get? bookings { booking-id: booking-id })))
    (if (is-some booking)
      (if (is-eq tx-sender (get customer (unwrap-panic booking)))
        (begin
          (map-set bookings
            { booking-id: booking-id }
            (merge (unwrap-panic booking) { status: "cancelled" })
          )
          (ok true)
        )
        (err u403) ;; Unauthorized
      )
      (err u404) ;; Not found
    )
  )
)

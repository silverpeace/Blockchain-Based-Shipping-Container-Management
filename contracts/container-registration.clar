;; Container Registration Contract
;; Records details of shipping containers

(define-data-var last-container-id uint u0)

(define-map containers
  { container-id: uint }
  {
    owner: principal,
    dimensions: {
      length: uint,
      width: uint,
      height: uint
    },
    max-weight: uint,
    manufacturing-date: uint,
    status: (string-ascii 20)
  }
)

(define-public (register-container
    (length uint)
    (width uint)
    (height uint)
    (max-weight uint)
    (manufacturing-date uint))
  (let
    ((new-id (+ (var-get last-container-id) u1)))
    (begin
      (var-set last-container-id new-id)
      (map-set containers
        { container-id: new-id }
        {
          owner: tx-sender,
          dimensions: {
            length: length,
            width: width,
            height: height
          },
          max-weight: max-weight,
          manufacturing-date: manufacturing-date,
          status: "available"
        }
      )
      (ok new-id)
    )
  )
)

(define-read-only (get-container (container-id uint))
  (map-get? containers { container-id: container-id })
)

(define-public (update-container-status (container-id uint) (new-status (string-ascii 20)))
  (let ((container (map-get? containers { container-id: container-id })))
    (if (is-some container)
      (if (is-eq tx-sender (get owner (unwrap-panic container)))
        (begin
          (map-set containers
            { container-id: container-id }
            (merge (unwrap-panic container) { status: new-status })
          )
          (ok true)
        )
        (err u403) ;; Unauthorized
      )
      (err u404) ;; Not found
    )
  )
)

(define-public (transfer-ownership (container-id uint) (new-owner principal))
  (let ((container (map-get? containers { container-id: container-id })))
    (if (is-some container)
      (if (is-eq tx-sender (get owner (unwrap-panic container)))
        (begin
          (map-set containers
            { container-id: container-id }
            (merge (unwrap-panic container) { owner: new-owner })
          )
          (ok true)
        )
        (err u403) ;; Unauthorized
      )
      (err u404) ;; Not found
    )
  )
)

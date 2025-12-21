CLASS zcl_oo_adt_class_run DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_oo_adt_class_run IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA: it_travel    TYPE TABLE OF ztravel_str_m,
          it_booking   TYPE TABLE OF zbooking_str_m,
          it_booksuppl TYPE TABLE OF zbooksupp_str_m.

    SELECT * FROM
           /dmo/travel_m
           INTO TABLE @DATA(lt_travel).
    IF sy-subrc IS INITIAL.
      it_travel = CORRESPONDING #( lt_travel  ).
      MODIFY ztravel_str_m FROM TABLE @it_travel.
    ENDIF.

    SELECT *
           FROM /dmo/booking_m
           INTO TABLE @DATA(lt_booking).
    IF sy-subrc IS INITIAL.
      it_booking = CORRESPONDING #( lt_booking ).
      MODIFY zbooking_str_m FROM TABLE @it_booking.
    ENDIF.

    SELECT *
           FROM /dmo/booksuppl_m
           INTO TABLE @DATA(lt_booksuppl).
    IF sy-subrc IS INITIAL.
      it_booksuppl = CORRESPONDING #( lt_booksuppl ).
      MODIFY zbooksupp_str_m FROM TABLE @it_booksuppl.
    ENDIF.


  ENDMETHOD.
ENDCLASS.

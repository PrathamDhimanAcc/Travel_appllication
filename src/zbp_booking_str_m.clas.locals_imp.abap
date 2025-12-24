CLASS lhc_zi_booking_str_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE zi_booking_str_m\_Bookingsuppl.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_booking_str_m RESULT result.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_booking_str_m~calculatetotalprice.
    METHODS setCurrencyCode FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_booking_str_m~setCurrencyCode.

ENDCLASS.

CLASS lhc_zi_booking_str_m IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.
    DATA: max_booking_suppl_id TYPE /dmo/booking_supplement_id.

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
      ENTITY zi_booking_str_m BY \_Bookingsuppl
      FROM CORRESPONDING #( entities )
      LINK DATA(booking_supplements).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking_group>)
                     GROUP BY <booking_group>-%tky.
      max_booking_suppl_id =  REDUCE #( INIT max = CONV /dmo/booking_supplement_id( '0' )
                    FOR booksuppl IN booking_supplements USING KEY entity
                    WHERE  ( source-TravelId = <booking_group>-TravelId AND
                              source-BookingId = <booking_group>-BookingId     )
                    NEXT max = COND /dmo/booking_id( WHEN booksuppl-target-BookingSupplementId > max
                                                        THEN booksuppl-target-BookingSupplementId
                                                        ELSE max )
                    ).
      max_booking_suppl_id = REDUCE #( INIT max = max_booking_suppl_id
                                 FOR entity IN entities USING KEY entity
                                 WHERE  ( TravelId = <booking_group>-TravelId AND
                                          BookingId = <booking_group>-BookingId   )
                                 FOR target IN entity-%target
                                 NEXT max = COND /dmo/booking_supplement_id( WHEN target-BookingSupplementId > max
                                                                       THEN target-BookingSupplementId
                                                                       ELSE max )
                                     ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking>)
                       USING KEY entity WHERE TravelId = <booking_group>-TravelId AND
                                              BookingId = <booking_group>-BookingId.

        LOOP AT <booking>-%target ASSIGNING FIELD-SYMBOL(<bookingsuppl_wo_numberes>).
          APPEND CORRESPONDING #( <bookingsuppl_wo_numberes> ) TO mapped-zi_booksuppl_str ASSIGNING FIELD-SYMBOL(<mapped_booksuppl>).
          IF <bookingsuppl_wo_numberes>-BookingSupplementId IS INITIAL.
            max_booking_suppl_id += 1.
            <mapped_booksuppl>-BookingSupplementId = max_booking_suppl_id.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
           ENTITY zi_travel_str_m BY \_Booking
           FIELDS ( TravelId BookingStatus )
           WITH CORRESPONDING #( keys )
           RESULT DATA(lt_booking).

    result = VALUE #( FOR ls_booking IN lt_booking
                          ( %tky = ls_booking-%tky
                            %features-%assoc-_Bookingsuppl = COND #( WHEN ls_booking-BookingStatus = 'X'
                                                                     THEN if_abap_behv=>fc-o-disabled
                                                                     ELSE if_abap_behv=>fc-o-enabled  )
                          )
                      ).
  ENDMETHOD.

  METHOD calculateTotalPrice.

    DATA: it_travel TYPE TABLE FOR READ RESULT zi_travel_str_m.

*    it_travel = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING TravelId = TravelId   ).

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
    ENTITY zi_travel_str_m
        FIELDS ( TravelId CurrencyCode TotalPrice )
        WITH CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING TravelId = TravelId ) RESULT it_travel.

    MODIFY ENTITIES OF zi_travel_str_m IN LOCAL MODE
             ENTITY zi_travel_str_m
             EXECUTE reCalcTotPrice
             FROM CORRESPONDING #( it_travel ).

*    IF lines( it_travel ) > 0.
*      TYPES : BEGIN OF ty_total,
*                price TYPE /dmo/booking_fee,
*                curr  TYPE /dmo/currency_code,
*              END OF ty_total.
*
*      DATA: lt_total      TYPE TABLE OF ty_total,
*            lv_conv_price TYPE /dmo/total_price.
*
*      READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
*          ENTITY zi_travel_str_m
*          FIELDS ( BookingFee CurrencyCode )
*          WITH CORRESPONDING #( it_travel )
*          RESULT DATA(lt_travel).
*
*      DELETE lt_travel WHERE CurrencyCode IS INITIAL.
*
*      READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
*      ENTITY zi_travel_str_m BY \_Booking
*      FIELDS ( FlightPrice CurrencyCode )
*      WITH CORRESPONDING #( lt_travel )
*      RESULT DATA(lt_ba_booking).
*
*      READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
*      ENTITY zi_booking_str_m BY \_Bookingsuppl
*      FIELDS ( Price CurrencyCode )
*      WITH CORRESPONDING #( lt_ba_booking )
*      RESULT DATA(lt_ba_booking_supp).
*
*      LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
*
*        lt_total = VALUE #( ( price = <ls_travel>-BookingFee curr = <ls_travel>-CurrencyCode ) ).
*
*        LOOP AT lt_ba_booking ASSIGNING FIELD-SYMBOL(<ls_book>)
*        USING KEY entity WHERE TravelId = <ls_travel>-TravelId
*        AND CurrencyCode IS NOT INITIAL.
*
*          APPEND VALUE #( price = <ls_book>-FlightPrice curr = <ls_book>-CurrencyCode ) TO lt_total.
*
*          LOOP AT lt_ba_booking_supp ASSIGNING FIELD-SYMBOL(<ls_book_supp>) USING KEY
*          entity WHERE TravelId = <ls_book>-TravelId
*          AND BookingId = <ls_book>-BookingId
*          AND CurrencyCode IS NOT INITIAL.
*
*            APPEND VALUE #( price = <ls_book_supp>-Price curr = <ls_book_supp>-CurrencyCode ) TO lt_total.
*
*          ENDLOOP.
*
*        ENDLOOP.
*
*        LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_total>).
*
*          IF <ls_total>-curr = <ls_travel>-CurrencyCode.
*            lv_conv_price = <ls_total>-price.
*          ELSE.
*
*            DATA(lo_conv) = NEW zcl_curr_conv( ).
*            lv_conv_price = lo_conv->convert_amount(
*                EXPORTING
*                 iv_amount = <ls_total>-price
*                 iv_from_curr = <ls_total>-curr
*                 iv_to_curr = <ls_travel>-CurrencyCode
*                 iv_date = cl_abap_context_info=>get_system_date(  )
*              ).
*
**          /dmo/cl_flight_amdp=>convert_currency(
**            EXPORTING
**              iv_amount               = <ls_total>-price
**              iv_currency_code_source = <ls_total>-curr
**              iv_currency_code_target = <ls_travel>-CurrencyCode
**              iv_exchange_rate_date   = cl_abap_context_info=>get_system_date(  )
**            IMPORTING
**              ev_amount               = lv_conv_price
**          ).
*          ENDIF.
*
*          <ls_travel>-TotalPrice = <ls_travel>-TotalPrice + lv_conv_price.
*
*
*        ENDLOOP.
*
*      ENDLOOP.
*
*      MODIFY ENTITIES OF zi_travel_str_m IN LOCAL MODE
*             ENTITY  zi_travel_str_m
*             UPDATE FIELDS ( TotalPrice )
*             WITH VALUE #(
*                   FOR ls IN lt_travel ( %tky = ls-%tky TotalPrice = ls-TotalPrice  )
*               ).


*    ENDIF.


  ENDMETHOD.

  METHOD setCurrencyCode.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lsc_zi_travel_str_m DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_travel_str_m IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_log TYPE STANDARD TABLE OF zlog_travel_str.
    DATA: lt_log_c TYPE STANDARD TABLE OF zlog_travel_str.

    IF create-zi_travel_str_m IS NOT INITIAL OR update-zi_travel_str_m IS NOT INITIAL.
      lt_log = CORRESPONDING #( create-zi_travel_str_m ).
      LOOP AT lt_log ASSIGNING FIELD-SYMBOL(<ls_log>).
        IF create-zi_travel_str_m IS NOT INITIAL.
          <ls_log>-changing_operation = 'CREATE'.
        ELSE.
          <ls_log>-changing_operation = 'UPDATE'.
        ENDIF.
        GET TIME STAMP FIELD <ls_log>-created_at.

        READ TABLE create-zi_travel_str_m ASSIGNING FIELD-SYMBOL(<ls_travel>)
                            WITH TABLE KEY entity
                            COMPONENTS TravelId = <ls_log>-travelid.
        IF sy-subrc = 0.
          IF <ls_travel>-%control-BookingFee = cl_abap_behv=>flag_changed .
            <ls_log>-changed_field_name = 'Booking Fee'.
            <ls_log>-changed_value = <ls_travel>-BookingFee.
            TRY.
                <ls_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
              CATCH cx_uuid_error.
                "handle= exception
            ENDTRY.
            APPEND <ls_log> TO lt_log_c.
          ENDIF.
          IF <ls_travel>-%control-OverallStatus = cl_abap_behv=>flag_changed .
            <ls_log>-changed_field_name = 'Overall Status'.
            <ls_log>-changed_value = <ls_travel>-OverallStatus.
            TRY.
                <ls_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.
            APPEND <ls_log> TO lt_log_c.
          ENDIF.
        ENDIF.

      ENDLOOP.

      IF lt_log_c IS NOT INITIAL.
        INSERT zlog_travel_str FROM TABLE @lt_log_c.
      ENDIF.
    ENDIF.


    IF delete-zi_travel_str_m IS NOT INITIAL.
      lt_log = CORRESPONDING #( delete-zi_travel_str_m ).
      LOOP AT lt_log ASSIGNING FIELD-SYMBOL(<ls_log_DEL>).
        <ls_log_DEL>-changing_operation = 'DELETE'.
        GET TIME STAMP FIELD <ls_log_DEL>-created_at.
        TRY.
            <ls_log_DEL>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_uuid_error.
            "handle exception
        ENDTRY.
      ENDLOOP.
      INSERT zlog_travel_str FROM TABLE @lt_log.
    ENDIF.
**********************************************************************
* Booking Supplement Unmanaged Save with Managed
**********************************************************************
    DATA: lt_book_suppl TYPE STANDARD TABLE OF zbooksupp_str_m.
    GET TIME STAMP  FIELD DATA(lv_time).
    IF create-zi_booksuppl_str IS NOT INITIAL.
      lt_book_suppl = VALUE #( FOR ls_book IN create-zi_booksuppl_str
      ( travel_id = ls_book-TravelId
        booking_id = ls_book-BookingId
        booking_supplement_id = ls_book-BookingSupplementId
        currency_code = ls_book-CurrencyCode
        price = ls_book-Price
        supplement_id = ls_book-SupplementId
        last_changed_at = lv_time
      ) ).
      INSERT zbooksupp_str_m FROM TABLE @lt_book_suppl.
    ENDIF.

    IF update-zi_booksuppl_str IS NOT INITIAL.
      lt_book_suppl = VALUE #( FOR ls_book IN update-zi_booksuppl_str
      ( travel_id = ls_book-TravelId
        booking_id = ls_book-BookingId
        booking_supplement_id = ls_book-BookingSupplementId
        currency_code = ls_book-CurrencyCode
        price = ls_book-Price
        supplement_id = ls_book-SupplementId
        last_changed_at = lv_time
      ) ).
      UPDATE zbooksupp_str_m FROM TABLE @lt_book_suppl.
    ENDIF.

    IF delete-zi_booksuppl_str IS NOT INITIAL.
      lt_book_suppl = VALUE #( FOR ls_del IN delete-zi_booksuppl_str
      ( travel_id = ls_del-TravelId
        booking_id = ls_del-BookingId
        booking_supplement_id = ls_del-BookingSupplementId
      ) ).
      DELETE zbooksupp_str_m FROM TABLE @lt_book_suppl.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_STR_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_str_m RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_travel_str_m RESULT result.
    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_str_m~accepttravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_str_m~copytravel.

    METHODS recalctotprice FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_str_m~recalctotprice.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_str_m~rejecttravel RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_travel_str_m RESULT result.
    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_str_m~validatecustomer.
    METHODS validatebookingfee FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_str_m~validatebookingfee.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_str_m~validatecurrencycode.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_str_m~validatedates.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_str_m~validatestatus.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_travel_str_m~calculatetotalprice.

    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_str_m\_booking.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_str_m.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_STR_M IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA(lt_entities) = entities.
    DELETE lt_entities WHERE TravelId IS NOT INITIAL.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*        ignore_buffer     =
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( lt_entities ) )
*        subobject         =
*        toyear            =
          IMPORTING
            number            = DATA(lv_latest_num)
            returncode        = DATA(lv_code)
            returned_quantity = DATA(lv_qty)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).
        LOOP AT lt_entities INTO DATA(ls_entity).

          APPEND VALUE #( %cid = ls_entity-%cid
                          %key = ls_entity-%key )
                          TO failed-zi_travel_str_m.
          APPEND VALUE #( %cid = ls_entity-%cid
                          %key = ls_entity-%key
                          %msg = lo_error )
                          TO reported-zi_travel_str_m.
        ENDLOOP.
        EXIT.
    ENDTRY.


    ASSERT lv_qty = lines( lt_entities ).
    DATA: lt_travel_str_m TYPE TABLE FOR MAPPED EARLY zi_travel_str_m,
          ls_travel_str_m LIKE LINE OF lt_travel_str_m.
    DATA(lv_curr_num) = lv_latest_num - lv_qty.
    LOOP AT lt_entities INTO DATA(ls_entities).
      lv_curr_num = lv_curr_num + 1.
      APPEND VALUE #( %cid = ls_entities-%cid
                             TravelId = lv_curr_num )
                   TO mapped-zi_travel_str_m.
      .
*    APPEND ls_travel_str_m to mapped-zi_travel_str_m.

    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

    DATA: lv_max_booking TYPE /dmo/booking_id.

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
      ENTITY zi_travel_str_m BY \_Booking
      FROM CORRESPONDING #( entities )
      LINK DATA(lt_link_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_entity>)
                               GROUP BY <ls_group_entity>-TravelId.
      lv_max_booking =  REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                   FOR ls_link IN lt_link_data USING KEY entity
                                   WHERE  ( source-TravelId = <ls_group_entity>-TravelId )
                                   NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-target-BookingId
                                                                       THEN ls_link-target-BookingId
                                                                       ELSE lv_max )
                                   ).
      lv_max_booking = REDUCE #( INIT lv_max = lv_max_booking
                                 FOR ls_entity IN entities USING KEY entity
                                 WHERE  ( TravelId = <ls_group_entity>-TravelId )
                                 FOR ls_booking IN ls_entity-%target
                                 NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_booking-BookingId
                                                                       THEN ls_booking-BookingId
                                                                       ELSE lv_max )
                                  ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>)
                                 USING KEY entity
                                 WHERE TravelId =  <ls_group_entity>-TravelId.

        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          APPEND CORRESPONDING #( <ls_booking> ) TO mapped-zi_booking_str_m
                 ASSIGNING FIELD-SYMBOL(<ls_new_map_book>).
          IF  <ls_booking>-BookingId IS INITIAL.
            lv_max_booking += 10.

            <ls_new_map_book>-BookingId = lv_max_booking.
          ENDIF.

        ENDLOOP.


      ENDLOOP.

    ENDLOOP.
  ENDMETHOD.

  METHOD acceptTravel.

    MODIFY ENTITIES OF zi_travel_str_m IN LOCAL MODE
    ENTITY zi_travel_str_m
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #(
                  FOR ls_keys IN keys
                  ( %tky = ls_keys-%tky
                    OverallStatus = 'A' ) ).

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
     ENTITY zi_travel_str_m
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result
                           ( %tky = ls_result-%tky
                             %param = ls_result ) ).

  ENDMETHOD.

  METHOD copyTravel.
    DATA: it_travel        TYPE TABLE FOR CREATE zi_travel_str_m,
          it_booking_cba   TYPE TABLE FOR CREATE zi_travel_str_m\_Booking,
          it_booksuppl_cba TYPE TABLE FOR CREATE zi_booking_str_m\_Bookingsuppl.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = ' '.
    ASSERT <ls_without_cid> IS NOT ASSIGNED.

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
          ENTITY zi_travel_str_m
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_travel_r)
          FAILED DATA(lt_failed).

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
    ENTITY zi_travel_str_m BY \_Booking
    ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
    RESULT DATA(lt_booking_r).

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
             ENTITY zi_booking_str_m BY \_Bookingsuppl
             ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
             RESULT DATA(lt_booksuppl_r).

    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).
      APPEND VALUE #( %cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid
                      %data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ) )
                      TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date( ).
      <ls_travel>-EndDate = cl_abap_context_info=>get_system_date( ) +  30.
      <ls_travel>-OverallStatus = 'O'.

      APPEND VALUE #( %cid_ref = <ls_travel>-%cid )
         TO it_booking_cba ASSIGNING FIELD-SYMBOL(<it_booking>) .

      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>)
                           USING KEY entity
                            WHERE TravelId = <ls_travel_r>-TravelId.
        APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId
                        %data = CORRESPONDING #( <ls_booking_r> EXCEPT TravelId ) )
                        TO <it_booking>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).

        <ls_booking_n>-BookingStatus  = 'N'.

        APPEND VALUE #( %cid_ref = <ls_booking_n>-%cid )
                TO it_booksuppl_cba ASSIGNING FIELD-SYMBOL(<ls_booksupp>).

        LOOP AT lt_booksuppl_r ASSIGNING FIELD-SYMBOL(<ls_boosupp_r>)
                               USING KEY entity
                               WHERE TravelId = <ls_travel_r>-TravelId AND
                                      BookingId = <ls_booking_r>-BookingId.
          APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId && <ls_boosupp_r>-BookingSupplementId
                           %data = CORRESPONDING #( <ls_boosupp_r> EXCEPT TravelId BookingId ) )
                           TO <ls_booksupp>-%target.

        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zi_travel_str_m IN LOCAL MODE
           ENTITY zi_travel_str_m
           CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description )
           WITH it_travel
           ENTITY zi_travel_str_m
           CREATE BY \_Booking
           FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
           WITH it_booking_cba
           ENTITY zi_booking_str_m
           CREATE BY \_Bookingsuppl
           FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
           WITH it_booksuppl_cba
           MAPPED DATA(it_mapped).

    mapped-zi_travel_str_m = it_mapped-zi_travel_str_m.           .


  ENDMETHOD.

  METHOD reCalcTotPrice.

    TYPES: BEGIN OF ty_total,
             price TYPE /dmo/booking_fee,
             curr  TYPE /dmo/currency_code,
           END OF ty_total.

    DATA: lt_total      TYPE TABLE OF ty_total,
          lv_conv_price TYPE /dmo/total_price.

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
         ENTITY zi_travel_str_m
         FIELDS ( BookingFee CurrencyCode )
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_travel).

    DELETE lt_travel WHERE CurrencyCode IS INITIAL.

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
    ENTITY zi_travel_str_m BY \_Booking
    FIELDS ( FlightPrice CurrencyCode )
    WITH CORRESPONDING #( lt_travel )
    RESULT DATA(lt_ba_booking).

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
    ENTITY zi_booking_str_m BY \_Bookingsuppl
    FIELDS ( Price CurrencyCode )
    WITH CORRESPONDING #( lt_ba_booking )
    RESULT DATA(lt_ba_booksuppl).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      lt_total = VALUE #( ( price = <ls_travel>-BookingFee curr = <ls_travel>-CurrencyCode ) ).

      LOOP AT lt_ba_booking ASSIGNING FIELD-SYMBOL(<ls_bookibg>)
                            USING KEY entity
                            WHERE TravelId = <ls_travel>-TravelId AND
                                  CurrencyCode IS NOT INITIAL.
        APPEND VALUE #( price = <ls_bookibg>-FlightPrice
                        curr = <ls_bookibg>-CurrencyCode )
                       TO lt_total.
        LOOP AT lt_ba_booksuppl ASSIGNING FIELD-SYMBOL(<ls_booksuppl>)
                                USING KEY entity
                                WHERE TravelId = <ls_bookibg>-TravelId AND
                                      BookingId = <ls_bookibg>-BookingId AND
                                      CurrencyCode IS NOT INITIAL.
          APPEND VALUE #( price = <ls_booksuppl>-Price curr = <ls_booksuppl>-CurrencyCode )
                          TO lt_total.
        ENDLOOP.
      ENDLOOP.

      LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_total>).
        IF <ls_total>-curr = <ls_travel>-CurrencyCode.
          lv_conv_price = <ls_total>-price.
        ELSE.

          /dmo/cl_flight_amdp=>convert_currency(
            EXPORTING
              iv_amount               = <ls_total>-price
              iv_currency_code_source = <ls_total>-curr
              iv_currency_code_target = <ls_travel>-CurrencyCode
              iv_exchange_rate_date   = cl_abap_context_info=>get_system_date(  )
            IMPORTING
              ev_amount               = lv_conv_price
          ).
        ENDIF.
        <ls_travel>-TotalPrice = <ls_travel>-TotalPrice + lv_conv_price.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zi_travel_str_m IN LOCAL MODE
           ENTITY zi_travel_str_m
           UPDATE FIELDS ( TotalPrice )
           WITH CORRESPONDING #( lt_travel ).
  ENDMETHOD.

  METHOD rejectTravel.
    MODIFY ENTITIES OF zi_travel_str_m IN LOCAL MODE
      ENTITY zi_travel_str_m
      UPDATE FIELDS ( OverallStatus )
      WITH VALUE #(
                    FOR ls_keys IN keys
                    ( %tky = ls_keys-%tky
                      OverallStatus = 'X' ) ).

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
     ENTITY zi_travel_str_m
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result
                           ( %tky = ls_result-%tky
                             %param = ls_result ) ).

  ENDMETHOD.


  METHOD get_instance_features.

    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
         ENTITY zi_travel_str_m
         FIELDS ( TravelId OverallStatus )
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_result).

    result = VALUE #( FOR ls_travel IN lt_result
                          ( %tky = ls_travel-%tky
                            %features-%action-acceptTravel = COND #( WHEN ls_travel-OverallStatus = 'A'
                                                                     THEN if_abap_behv=>fc-o-disabled
                                                                     ELSE if_abap_behv=>fc-o-enabled  )

                            %features-%action-rejectTravel = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                                     THEN if_abap_behv=>fc-o-disabled
                                                                     ELSE if_abap_behv=>fc-o-enabled  )
                            %features-%assoc-_Booking = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                                     THEN if_abap_behv=>fc-o-disabled
                                                                     ELSE if_abap_behv=>fc-o-enabled  )
                          )
                      ).
  ENDMETHOD.

  METHOD validateCustomer.

    READ ENTITY IN LOCAL MODE zi_travel_str_m
      FIELDS ( CustomerId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel).

    DATA: lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.
    lt_cust = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId ).
    DELETE lt_cust WHERE customer_id IS INITIAL.
    SELECT
        FROM /dmo/customer
        FIELDS customer_id
        FOR ALL ENTRIES IN @lt_cust
        WHERE customer_id = @lt_cust-customer_id
        INTO TABLE @DATA(lt_cust_db).
    IF sy-subrc IS INITIAL.

    ENDIF.

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      IF <ls_travel>-CustomerId IS INITIAL
         OR NOT line_exists( lt_cust_db[ customer_id = <ls_travel>-CustomerId ] ).

        APPEND VALUE #( %tky = <ls_travel>-%tky )
                TO failed-zi_travel_str_m.
        APPEND VALUE #( %tky = <ls_travel>-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                                        textid                = /dmo/cm_flight_messages=>customer_unkown
                                        customer_id           = <ls_travel>-CustomerId
                                        severity              = if_abap_behv_message=>severity-error
                                        )
                                        %element-CustomerId = if_abap_behv=>mk-on
                                        )
                       TO reported-zi_travel_str_m.


      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD validateBookingFee.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateDates.
    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
         ENTITY zi_travel_str_m
         FIELDS ( BeginDate EndDate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_date).

    LOOP AT lt_date ASSIGNING FIELD-SYMBOL(<ls_date>).
      IF <ls_date>-BeginDate > <ls_date>-EndDate.
        APPEND VALUE #( %tky = <ls_date>-%tky )
                  TO failed-zi_travel_str_m.

        APPEND VALUE #( %tky = <ls_date>-%tky
                        %msg = NEW /dmo/cm_flight_messages(
          textid                = /dmo/cm_flight_messages=>begin_date_bef_end_date
          begin_date            = <ls_date>-BeginDate
          severity              = if_abap_behv_message=>severity-error
        )
        %element-BeginDate = if_abap_behv=>mk-on )
        TO reported-zi_travel_str_m.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateStatus.
    READ ENTITIES OF zi_travel_str_m IN LOCAL MODE
         ENTITY zi_travel_str_m
         FIELDS ( OverallStatus )
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_status).

    LOOP AT lt_status ASSIGNING FIELD-SYMBOL(<ls_status>).
      CASE <ls_status>-OverallStatus.
        WHEN 'A' OR 'O' OR 'X' .

        WHEN OTHERS.
          APPEND VALUE #( %tky = <ls_status>-%tky ) TO failed-zi_travel_str_m.

          APPEND VALUE #( %tky = <ls_status>-%tky
                          %msg = NEW /dmo/cm_flight_messages(
            textid                = /dmo/cm_flight_messages=>status_invalid
            status                = <ls_status>-OverallStatus
            severity              = if_abap_behv_message=>severity-error
          )
          %element-OverallStatus = if_abap_behv=>mk-on
          ) TO reported-zi_travel_str_m.

      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD calculateTotalPrice.

    MODIFY ENTITIES OF zi_travel_str_m IN LOCAL MODE
           ENTITY zi_travel_str_m
           EXECUTE reCalcTotPrice
           FROM CORRESPONDING #( keys ).

  ENDMETHOD.

ENDCLASS.

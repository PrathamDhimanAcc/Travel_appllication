*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lOCAL_PRACT1 definition.

  public section.
    class-data CONN_COUNTER type i.

    methods constructor
        importing CARRIER_ID type /DMO/CARRIER_ID
                  CONNECTION_ID type /DMO/CONNECTION_ID
        raising cx_abap_invalid_value.
    methods GET_ATTRIBUTES
        exporting E_CARRIER_ID type /DMO/CARRIER_ID
                  E_CONNECTION_ID type /DMO/CONNECTION_ID
                  e_airport_from_id type /dmo/airport_from_id
                  e_airport_to_id type /dmo/airport_to_id.
    methods set_airport_ids
        raising cx_abap_invalid_value.

  protected section.
  private section.
    data CARRIER_ID type /DMO/CARRIER_ID.
    data CONNECTION_ID type /DMO/CONNECTION_ID.
    data AIRPORT_FROM_ID type /dmo/airport_from_id.
    data AIRPORT_TO_ID type /dmo/airport_to_id.
endclass.

class lOCAL_PRACT1 implementation.
    method constructor.
        if CARRIER_ID is initial or CONNECTION_ID is initial.
            raise exception type CX_ABAP_INVALID_VALUE.
        endif.
        ME->CARRIER_ID = CARRIER_ID.
        ME->CONNECTION_ID = CONNECTION_ID.
        CONN_COUNTER = CONN_COUNTER + 1.
    endmethod.

    method GET_ATTRIBUTES.
        E_CARRIER_ID = CARRIER_ID.
        E_CONNECTION_ID = CONNECTION_ID.
        e_airport_from_id = me->airport_from_id.
        e_airport_to_id = me->airport_to_id.
    endmethod.

    method set_airport_ids.
        if me->carrier_id is initial or me->connection_id is initial.
            raise exception type cx_abap_invalid_value.
        endif.
        select single from /dmo/connection
            fields airport_from_id,airport_to_id
            where carrier_id = @me->carrier_id
                and connection_id = @me->connection_id
            into ( @me->airport_from_id, @me->airport_to_id ).

    endmethod.
endclass.
